import Foundation
import AVFoundation

// 5/15

public protocol SoundEffectPlayerConfig {
    
    var enforcedSoundFormat: AVAudioFormat { get }
    var soundFiles: [String: URL] { get }
}


public class SoundEffectPlayer {
    
    private var config: SoundEffectPlayerConfig
    private static var sharedInstance: SoundEffectPlayer?
    public static var shared: SoundEffectPlayer {
        guard let instance = sharedInstance else {
            fatalError("Attempted to access SoundEffectPlayer.shared without prior setup. Please configure SoundEffectPlayer using setupSharedInstance(config:) first.")
        }
        return instance
    }
    
    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private var soundBuffers = [String: AVAudioPCMBuffer]()
    
    // ------------------------------------------------------------------------------------------------ INIT
    
    public static func setupSharedInstance(config: SoundEffectPlayerConfig) {
        sharedInstance = SoundEffectPlayer(config: config)
    }
    
    private init(config: SoundEffectPlayerConfig) {
        self.config = config
        setupAudioEngine()
        loadSounds()
    }
    
    private func setupAudioEngine() {
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: config.enforcedSoundFormat)
    }
    
    private func loadSounds() {
            for (soundName, fileURL) in config.soundFiles {
                do {
                    let buffer = try loadSoundEffectFileIntoBuffer(fileURL: fileURL)
                    soundBuffers[soundName] = buffer
                } catch {
                    print("Failed to load sound \(soundName): \(error)")
                }
            }
        }
    
    private func loadSoundEffectFileIntoBuffer(fileURL: URL) throws -> AVAudioPCMBuffer {
        let audioFile = try AVAudioFile(forReading: fileURL)
        let processingFormat = audioFile.processingFormat
        
        assert(processingFormat == config.enforcedSoundFormat)
        
        guard let pcmBuffer = AVAudioPCMBuffer(pcmFormat: processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length)) else {
            throw NSError(domain: "SoundEffectPlayerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create PCM buffer"])
        }
        
        try audioFile.read(into: pcmBuffer)
        return pcmBuffer
    }
    
    deinit {
        stop()
        engine.stop()
        engine.detach(playerNode)
    }
    
    // ------------------------------------------------------------------------------------------------ PUBLIC
    
    public func playSoundEffect(_ soundName: String) {
        guard let buffer = soundBuffers[soundName] else {
            print("Sound not available: \(soundName)")
            return
        }
        playerNode.stop()
        playerNode.scheduleBuffer(buffer, at: nil, options: [])
        do {
            try engine.start()
        } catch {
            print("Failed to start audio engine: \(error)")
            return
        }
        playerNode.play()
    }
    
    public func stop() {
        if playerNode.isPlaying {
            playerNode.stop()
        }
    }
    
}


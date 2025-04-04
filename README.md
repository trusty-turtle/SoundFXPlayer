# SoundFXPlayer
A Simple and Reliable Low-Latency "Fire-and-Forget" Sound Effect Player for Swift/SwiftUI projects

SoundFXPlayer is designed to be used as a singleton via SoundFXPlayer.shared, but...

The SoundFXPlayer must be intialized with a configuration *before* you attempt to access the shared instance (SoundFXPlayer.shared) or you will get a fatalError().

Not intended for very long sound files -- sounds are always resident in memory, so keep an eye on memory if using large sound files.

Sounds are cut off when new sounds are played.

# Usage

Early in your app's lifecycle, such as in App.init() for SwiftUI or AppDelegate for UIKit, <b>create your configuration</b>:

```swift
struct MyPlayerConfig: SoundFXPlayerConfig {

    // Must be a valid AVAudioFormat and all sound files must conform
    var enforcedSoundFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)!

    // Define your sounds' logical name and URL
    var soundFiles: [String:URL] = [
      "myFirstSound":Bundle.main.url(forResource: "gong_forward", withExtension: "wav")!,
      "mySecondSound":Bundle.main.url(forResource: "gong_reverse", withExtension: "wav")!
    // add more ...
    ]
}
```
Create the player using the configuration you just made:

```swift
SoundFXPlayer.setupSharedInstance(config: MyPlayerConfig())
```

Play your sounds from anywhere in your app:

```swift
SoundFXPlayer.shared.playSoundEffect("myFirstSound")
```

Explicitly stop playback:

```swift
SoundEffectPlayer.shared.stop()
```


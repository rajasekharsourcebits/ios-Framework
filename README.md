# TvOSAVPlayer

This library provides an media player support in tvOS with default controls like Play/Pause, Go forward/backward for 10 secs, Full Screen and SeekBar.

## Installation
---
Currently, there is one way to use TvOSplayer in your project:

- using Swift Package Manager

### Installation with Swift Package Manager (Xcode 11+)
[Swift Package Manager](https://swift.org/package-manager/) (SwiftPM) is a tool for managing the distribution of Swift code as well as C-family dependency. From Xcode 11, SwiftPM got natively integrated with Xcode.

TvOSAvPlayer support SwiftPM from version 5.1.0. To use SwiftPM, you should use Xcode 11 to open your project. Click File -> Swift Packages -> Add Package Dependency, enter TvOSAVPlayer repo's URL. Or you can login Xcode with your GitHub account and just type TvOSAVPlayer to search.

After select the package, you can choose the dependency type (tagged version, branch or commit). Then Xcode will setup all the stuff for you.

### How To Use
---
- Swift
``` swift
import TvOSAVPlayer

let avPlayer = TvOSAVPlayer(frame: CGRect(x: xPosition, y: yPosition, width: width, height: height), fileUrl: videoURL)
self.view.addSubview(avPlayer)
```

## Author
---
- Ganesh kumar

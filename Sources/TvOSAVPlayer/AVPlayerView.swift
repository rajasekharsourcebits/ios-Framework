//
//  AVPlayerView.swift
//  TvOSAVPlayer
//
//  Created by Ganesh Kumar on 28/05/20.
//  Copyright © 2020 Ganesh Kumar. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

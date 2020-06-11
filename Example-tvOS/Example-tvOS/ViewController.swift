//
//  ViewController.swift
//  Example-tvOS
//
//  Created by Ganesh Kumar on 21/05/20.
//  Copyright © 2020 Ganesh Kumar. All rights reserved.
//

import UIKit
import TvOSAVPlayer

class ViewController: UIViewController {

    var avPlayer: TvOSAVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let videoURL = URL(string: "https://liveproduseast.global.ssl.fastly.net/btv/desktop/us_live.m3u8")
        let videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")

        avPlayer = TvOSAVPlayer(frame: CGRect(x: 10, y: 10, width: 1500, height: 833), fileUrl: videoURL!)
        avPlayer.backgroundColor = UIColor.green
        self.view.addSubview(avPlayer)
    }
}


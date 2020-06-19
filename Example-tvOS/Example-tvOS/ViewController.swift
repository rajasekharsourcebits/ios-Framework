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

    @IBOutlet weak var avPlayer: TvOSAVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.view.backgroundColor = UIColor.red
        
//        let videoURL = URL(string: "https://liveproduseast.global.ssl.fastly.net/btv/desktop/us_live.m3u8")
        let videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")

//        avPlayer.play(with: videoURL!)
        avPlayer.isHidden = true
        
        let avPlayer1 = TvOSAVPlayer(frame: CGRect(x: 10, y: 10, width: 1500, height: 833), fileUrl: videoURL!)
//        let avPlayer1 = TvOSAVPlayer(frame: self.view.bounds, fileUrl: videoURL!)
        avPlayer1.backgroundColor = UIColor.orange
        self.view.addSubview(avPlayer1)
    }
}


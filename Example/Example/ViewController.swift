//
//  ViewController.swift
//  Example
//
//  Created by Ganesh Kumar on 19/05/20.
//  Copyright © 2020 Ganesh Kumar. All rights reserved.
//

import UIKit
import TvOSAVPlayer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let avPlayer = TvOSAVPlayer()
        avPlayer.printHelloWorld()
    }
}

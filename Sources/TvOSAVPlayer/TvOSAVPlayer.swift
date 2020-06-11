//
//  TvOSAVPlayer.swift
//  TvOSAVPlayer
//
//  Created by Ganesh Kumar on 21/05/20.
//  Copyright © 2020 Ganesh Kumar. All rights reserved.
//

import UIKit
import AVKit

public class TvOSAVPlayer: UIView {
    
    @IBOutlet weak var avPlayerView: AVPlayerView!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var tenSecForwardButton: UIButton!
    @IBOutlet weak var tenSecBackwardButton: UIButton!

    @IBOutlet weak var seekBarSlider: TvOSSlider!
    @IBOutlet weak var totalDurationLbl: UILabel!
    @IBOutlet weak var currentDurationLbl: UILabel!

    var text = "Hello, World!, Welcome to Swift Package Manager"
    
    var fileURL: URL!
    var enableControls: Bool = true
    var playingStatus: Bool = true
    
    fileprivate let seekDuration: Float64 = 10
    fileprivate var currentValue: Float = 0

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience public init(frame: CGRect, fileUrl: URL) {
        self.init(frame: frame)
        self.fileURL = fileUrl
        setUpView()
    }
    
    func setUpView() {
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.backgroundColor = UIColor.orange
        self.addSubview(view)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        seekBarSlider.addTarget(self, action: #selector(sliderValueChanges), for: .valueChanged)
        seekBarSlider.minimumValue = 0
        seekBarSlider.maximumValue = 100
        seekBarSlider.stepValue = 1//0.10
        seekBarSlider.minimumTrackTintColor = .lightGray
        seekBarSlider.maximumTrackTintColor = .white
        seekBarSlider.thumbTintColor = .lightGray
        seekBarSlider.backgroundColor = UIColor.clear
    }

    private func loadViewFromNib() -> TvOSAVPlayer {
        let bundle = Bundle(for: TvOSAVPlayer.self)
        let nib = UINib(nibName: "\(TvOSAVPlayer.self)", bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! TvOSAVPlayer
        
        let playerItem = AVPlayerItem(url: fileURL!)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = nibView.avPlayerView.layer as! AVPlayerLayer
        playerLayer.player = player
        player.play()

        let duration: CMTime = playerItem.asset.duration

        nibView.totalDurationLbl.text = getFormatedDateString(duration: duration)
        nibView.currentDurationLbl.text = "00:00:00"

        nibView.seekBarSlider.maximumValue = Float(CMTimeGetSeconds(duration))

        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] (time) -> Void in
            nibView.currentDurationLbl.text = self?.getFormatedDateString(duration: time)
            self?.updateSlider(duration: time)
        }

        return nibView
    }

    @objc func sliderValueChanges(slider: TvOSSlider) {
        
        var newTime = 0.0
        if slider.value > self.currentValue {
            newTime = Float64(slider.value) + seekDuration
        } else {
            newTime = Float64(slider.value) - seekDuration
        }

        if let view = self.subviews.first as? AVPlayerView {
            if let playerLayer = view.layer as? AVPlayerLayer {
                let time: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
                playerLayer.player?.seek(to: time)
                playerLayer.player?.play()
            }
        }
    }
    
    override public func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        guard context.nextFocusedView != nil else {
            return
        }

        context.nextFocusedView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        context.previouslyFocusedView?.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
}

extension TvOSAVPlayer {
    
    func getFormatedDateString(duration: CMTime) -> String {

        let totalSeconds = CMTimeGetSeconds(duration)
        let hours:Int = Int(totalSeconds / 3600)
        let minutes:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))

        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
    
    func updateSlider(duration: CMTime) {
        if let view = self.subviews.first as? TvOSAVPlayer {
            view.seekBarSlider.value = Float(CMTimeGetSeconds(duration))
            view.currentValue = Float(CMTimeGetSeconds(duration))
        }
    }

    @IBAction func playPauseAction(_ sender: Any) {
        
        playingStatus = !playingStatus

        let bundle = Bundle(for: TvOSAVPlayer.self)
        
        guard let avPlayerLayer = self.avPlayerView.layer as? AVPlayerLayer else {
            return
        }

        if playingStatus == true {
            playOrPauseButton.setBackgroundImage(UIImage(named: "pause", in: bundle, compatibleWith: nil), for: .normal)
            avPlayerLayer.player?.play()
        } else {
            playOrPauseButton.setBackgroundImage(UIImage(named: "play", in: bundle, compatibleWith: nil), for: .normal)
            avPlayerLayer.player?.pause()
        }
    }

    @IBAction func tenSecBackwardAction(_ sender: Any) {

        guard let avPlayerLayer = self.avPlayerView.layer as? AVPlayerLayer else {
            return
        }
        
        let playerCurrentTime = CMTimeGetSeconds((avPlayerLayer.player?.currentTime())!)
        var newTime = playerCurrentTime - seekDuration

        if newTime < 0 {
            newTime = 0
        }

        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        avPlayerLayer.player?.seek(to: time2)
    }
    
    @IBAction func tenSecForwardAction(_ sender: Any) {
        guard let avPlayerLayer = self.avPlayerView.layer as? AVPlayerLayer else {
            return
        }
        
        guard let duration  = avPlayerLayer.player?.currentItem?.duration else{
            return
        }

        let playerCurrentTime = CMTimeGetSeconds((avPlayerLayer.player?.currentTime())!)
        let newTime = playerCurrentTime + seekDuration

        if newTime < CMTimeGetSeconds(duration) {
            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            avPlayerLayer.player?.seek(to: time2)
        }
    }
    
    @IBAction func fullScreenAction(_ sender: Any) {
    }
}

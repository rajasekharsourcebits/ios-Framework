//
//  TvOSAVPlayer.swift
//  TvOSAVPlayer
//
//  Created by Ganesh Kumar on 21/05/20.
//  Copyright © 2020 Ganesh Kumar. All rights reserved.
//

import UIKit
import AVKit

extension Bundle {
    /// The bundle associated with the current Swift module.
    static let module: Bundle = Bundle()
}

public class TvOSAVPlayer: UIView {

    var containerView: UIView!
    var avPlayerView: AVPlayerView!
    var avPlayer: AVPlayer!
    var controlsView: UIView!

    var playOrPauseButton: UIButton!
    var fullScreenButton: UIButton!
    var tenSecForwardButton: UIButton!
    var tenSecBackwardButton: UIButton!
    
    var seekBarSlider: TvOSSlider!
    var totalDurationLbl: UILabel!
    var currentDurationLbl: UILabel!
    
    var fileURL: URL!
    var enableControls: Bool = true
    var playingStatus: Bool = true
    
    fileprivate let seekDuration: Float64 = 10
    fileprivate var currentValue: Float = 0

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience public init(frame: CGRect, fileUrl: URL) {
        self.init(frame: frame)
        self.fileURL = fileUrl
        setUpView(fileUrl: fileUrl)
    }
    
    func setUpView(fileUrl: URL) {
        let frame = CGRect(x: 10, y: 10, width: self.bounds.size.width - 20, height: self.bounds.size.height - 20)
        containerView = UIView(frame: frame)
        containerView.backgroundColor = UIColor.lightGray
        self.addSubview(containerView)
        
        setUpPlayerView(fileUrl: fileUrl)
        setUpControlsView()

//        let view = loadViewFromNib()
//        if view != nil  {
//            print("view loaded")
//        } else {
//            print("view not loaded")
//        }
//        view?.frame = self.bounds
//        view?.backgroundColor = UIColor.orange
//        self.addSubview(view!)
    }

    func setUpPlayerView(fileUrl: URL) {
        
        avPlayerView = AVPlayerView(frame: containerView.bounds)
        containerView.addSubview(avPlayerView)
        
//        let playerItem = AVPlayerItem(url: fileURL!)
//        avPlayer = AVPlayer(playerItem: playerItem)
//        let playerLayer = avPlayerView.layer as! AVPlayerLayer
//        playerLayer.player = avPlayer
//        avPlayer.play()

//        let duration: CMTime = playerItem.asset.duration

//        nibView.totalDurationLbl.text = getFormatedDateString(duration: duration)
//        nibView.currentDurationLbl.text = "00:00:00"
//
//        nibView.seekBarSlider.maximumValue = Float(CMTimeGetSeconds(duration))
//
//        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] (time) -> Void in
//            nibView.currentDurationLbl.text = self?.getFormatedDateString(duration: time)
//            self?.updateSlider(duration: time)
//        }
        
    }
    
    func setUpControlsView() {
        
        let viewWidth: CGFloat = containerView.bounds.size.width * 0.498437
        let viewHeight: CGFloat = containerView.bounds.size.height * 0.13888
        let xPosition: CGFloat = (containerView.bounds.size.width - viewWidth) / 2
        let yPosition: CGFloat = containerView.bounds.size.height - viewHeight - 50
        controlsView = UIView(frame: CGRect(x: xPosition, y: yPosition, width: viewWidth, height: viewHeight))
        controlsView.backgroundColor = UIColor.darkGray
        containerView.addSubview(controlsView)
        
        setUpPlayBackControls()
        setUpSeekBarControls()
    }
    
    func setUpPlayBackControls() {
        
        let playBackControlsView = UIView(frame: CGRect(x: 0, y: 0, width: controlsView.bounds.size.width, height: controlsView.bounds.size.height * 0.56))
        playBackControlsView.backgroundColor = UIColor.clear
        controlsView.addSubview(playBackControlsView)
        
        let buttonSize = playBackControlsView.bounds.size.height * 0.5
        let buttonXPosition = (playBackControlsView.bounds.size.width - buttonSize) / 2
        let buttonYPosition = (playBackControlsView.bounds.size.height - buttonSize) / 2
                
        let picture = Bundle.module.path(forResource: "pause", ofType: "png")
        let bundle = Bundle()
        
        for framework in Bundle.allFrameworks {
            print("bundle path: \(framework.bundleIdentifier)")
            if framework.bundleIdentifier == "TvOSAVPlayer" {
//                bundle = framework.bundlePath
                print("framework")
            }
        }
        
        playOrPauseButton = UIButton(type: .custom)
        playOrPauseButton.frame = CGRect(x: buttonXPosition, y: buttonYPosition, width: buttonSize, height: buttonSize)
        playOrPauseButton.setBackgroundImage(UIImage(named: "pause", in: nil, compatibleWith: nil), for: .normal)
        playOrPauseButton.addTarget(self, action: #selector(playPauseAction(_:)), for: .primaryActionTriggered)
        playOrPauseButton.backgroundColor = UIColor.red
        playBackControlsView.addSubview(playOrPauseButton)

        tenSecBackwardButton = UIButton(type: .custom)
        tenSecBackwardButton.frame = CGRect(x: buttonXPosition - buttonSize - 30, y: buttonYPosition, width: buttonSize, height: buttonSize)
        tenSecBackwardButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
        tenSecBackwardButton.addTarget(self, action: #selector(tenSecBackwardAction(_:)), for: .primaryActionTriggered)
        tenSecBackwardButton.backgroundColor = UIColor.green
        playBackControlsView.addSubview(tenSecBackwardButton)

        tenSecForwardButton = UIButton(type: .custom)
        tenSecForwardButton.frame = CGRect(x: buttonXPosition + buttonSize + 30, y: buttonYPosition, width: buttonSize, height: buttonSize)
        tenSecForwardButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
        tenSecForwardButton.addTarget(self, action: #selector(tenSecForwardAction(_:)), for: .primaryActionTriggered)
        tenSecForwardButton.backgroundColor = UIColor.orange
        playBackControlsView.addSubview(tenSecForwardButton)
        
        fullScreenButton = UIButton(type: .custom)
        fullScreenButton.frame = CGRect(x: playBackControlsView.bounds.size.width - buttonSize - 20 , y: buttonYPosition, width: buttonSize, height: buttonSize)
        fullScreenButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
        fullScreenButton.addTarget(self, action: #selector(tenSecForwardAction(_:)), for: .primaryActionTriggered)
        fullScreenButton.backgroundColor = UIColor.orange
        playBackControlsView.addSubview(fullScreenButton)
    }
    
    func setUpSeekBarControls() {
        
        let yPosition = controlsView.bounds.size.height * 0.56
        let seekBarControlsView = UIView(frame: CGRect(x: 0, y: yPosition, width: controlsView.bounds.size.width, height: controlsView.bounds.size.height * 0.44))
        seekBarControlsView.backgroundColor = UIColor.clear
        controlsView.addSubview(seekBarControlsView)

        let lblYPosition = (seekBarControlsView.bounds.size.height - 30) / 2
        currentDurationLbl = UILabel(frame: CGRect(x: 30, y: lblYPosition, width: 100, height: 30))
        currentDurationLbl.text = "00:10:00"
        currentDurationLbl.textColor = UIColor.lightGray
        currentDurationLbl.textAlignment = .center
        currentDurationLbl.font = UIFont.systemFont(ofSize: 24)
        seekBarControlsView.addSubview(currentDurationLbl)

        let lblXPosition = seekBarControlsView.bounds.size.width - 130
        totalDurationLbl = UILabel(frame: CGRect(x: lblXPosition, y: lblYPosition, width: 100, height: 30))
        totalDurationLbl.text = "00:10:00"
        totalDurationLbl.textColor = UIColor.lightGray
        totalDurationLbl.textAlignment = .center
        totalDurationLbl.font = UIFont.systemFont(ofSize: 24)
        seekBarControlsView.addSubview(totalDurationLbl)
        
        let seekBarXPosition = currentDurationLbl.bounds.origin.x + currentDurationLbl.bounds.size.width + 60
        let seekBarWidth = seekBarControlsView.bounds.size.width - (seekBarXPosition * 2)
        seekBarSlider = TvOSSlider(frame: CGRect(x: seekBarXPosition, y: lblYPosition, width: seekBarWidth, height: 30))
        seekBarSlider.addTarget(self, action: #selector(sliderValueChanges(_:)), for: .valueChanged)
        seekBarSlider.minimumValue = 0
        seekBarSlider.maximumValue = 100
        seekBarSlider.stepValue = 1//0.10
        seekBarSlider.minimumTrackTintColor = .lightGray
        seekBarSlider.maximumTrackTintColor = .white
        seekBarSlider.thumbTintColor = .lightGray
        seekBarSlider.backgroundColor = UIColor.clear
        seekBarControlsView.addSubview(seekBarSlider)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        seekBarSlider.addTarget(self, action: #selector(sliderValueChanges(_:)), for: .valueChanged)
        seekBarSlider.minimumValue = 0
        seekBarSlider.maximumValue = 100
        seekBarSlider.stepValue = 1//0.10
        seekBarSlider.minimumTrackTintColor = .lightGray
        seekBarSlider.maximumTrackTintColor = .white
        seekBarSlider.thumbTintColor = .lightGray
        seekBarSlider.backgroundColor = UIColor.clear
    }

    private func loadViewFromNib() -> TvOSAVPlayer? {
        let bundle = Bundle(identifier: "TvOSAVPlayer") //Bundle(for: TvOSAVPlayer.self)
        print("bundle: \(String(describing: bundle))")
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

    @objc func sliderValueChanges(_ slider: TvOSSlider) {
        
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

    @objc func playPauseAction(_ sender: Any) {
        
        playingStatus = !playingStatus

//        let bundle = Bundle(for: TvOSAVPlayer.self)
        let bundle = Bundle(identifier: "TvOSAVPlayer")
        
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

    @objc func tenSecBackwardAction(_ sender: Any) {

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
    
    @objc func tenSecForwardAction(_ sender: Any) {
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
    
    @objc func fullScreenAction(_ sender: Any) {
    }
}

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
    var fullScreenStatus: Bool = false

    fileprivate let seekDuration: Float64 = 10
    fileprivate var currentValue: Float = 0

    var playImage: UIImage?
    var pauseImage: UIImage?
    var forwardImage: UIImage?
    var backwardImage: UIImage?
    var fullScreenImage: UIImage?

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
    
    public func play(with videoUrl: URL) {
        
        self.fileURL = videoUrl
        setUpView(fileUrl: videoUrl)
    }
    
    func setUpView(fileUrl: URL) {
        containerView = UIView(frame: self.bounds)
        containerView.backgroundColor = UIColor.lightGray
        self.addSubview(containerView)
        
        setUpControlsView()
        setUpPlayerView(fileUrl: fileUrl)
    }

    func setUpPlayerView(fileUrl: URL) {
        
        avPlayerView = AVPlayerView(frame: containerView.bounds)
        containerView.insertSubview(avPlayerView, at: 0)

        let playerItem = AVPlayerItem(url: fileURL!)
        avPlayer = AVPlayer(playerItem: playerItem)
        let playerLayer = avPlayerView.layer as! AVPlayerLayer
        playerLayer.player = avPlayer
        playerLayer.videoGravity = .resizeAspectFill
        avPlayer.play()

        let duration: CMTime = playerItem.asset.duration

        totalDurationLbl.text = getFormatedDateString(duration: duration)
        currentDurationLbl.text = "00:00"

        seekBarSlider.maximumValue = Float(CMTimeGetSeconds(duration))

        avPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] (time) -> Void in
            self?.currentDurationLbl.text = self?.getFormatedDateString(duration: time)
            self?.updateSlider(duration: time)
        }
    }
    
    func setUpControlsView() {
        
        let viewWidth: CGFloat = containerView.bounds.size.width * 0.8
        let viewHeight: CGFloat = containerView.bounds.size.height * 0.13888
        let xPosition: CGFloat = (containerView.bounds.size.width - viewWidth) / 2
        let yPosition: CGFloat = containerView.bounds.size.height - viewHeight - 50
        controlsView = UIView(frame: CGRect(x: xPosition, y: yPosition, width: viewWidth, height: viewHeight))
        controlsView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.65)
        containerView.addSubview(controlsView)
        
        setUpPlayBackControls()
        setUpSeekBarControls()
        
//        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideControlsView), userInfo: nil, repeats: true)
    }
    
//    @objc func hideControlsView() {
//        controlsView.isHidden = true
//    }
    
    func setUpPlayBackControls() {
        
        let playBackControlsView = UIView(frame: CGRect(x: 0, y: 0, width: controlsView.bounds.size.width, height: controlsView.bounds.size.height * 0.56))
        playBackControlsView.backgroundColor = UIColor.clear
        controlsView.addSubview(playBackControlsView)
        
        let buttonSize = playBackControlsView.bounds.size.height * 0.5
        let buttonXPosition = (playBackControlsView.bounds.size.width - buttonSize) / 2
        let buttonYPosition = (playBackControlsView.bounds.size.height - buttonSize) / 2

        if #available(tvOS 13.0, *) {
            playImage = UIImage(systemName: "play")
            pauseImage = UIImage(systemName: "pause")
            forwardImage = UIImage(systemName: "goforward.10")
            backwardImage = UIImage(systemName: "gobackward.10")
            fullScreenImage = UIImage(systemName: "viewfinder")
        }

        playOrPauseButton = UIButton(type: .custom)
        playOrPauseButton.frame = CGRect(x: buttonXPosition, y: buttonYPosition, width: buttonSize, height: buttonSize)
        playOrPauseButton.setBackgroundImage(pauseImage, for: .normal)
        playOrPauseButton.addTarget(self, action: #selector(playPauseAction), for: .primaryActionTriggered)
        playBackControlsView.addSubview(playOrPauseButton)

        tenSecBackwardButton = UIButton(type: .custom)
        tenSecBackwardButton.frame = CGRect(x: buttonXPosition - buttonSize - 30, y: buttonYPosition, width: buttonSize, height: buttonSize)
        tenSecBackwardButton.setBackgroundImage(backwardImage, for: .normal)
        tenSecBackwardButton.addTarget(self, action: #selector(tenSecBackwardAction), for: .primaryActionTriggered)
        playBackControlsView.addSubview(tenSecBackwardButton)

        tenSecForwardButton = UIButton(type: .custom)
        tenSecForwardButton.frame = CGRect(x: buttonXPosition + buttonSize + 30, y: buttonYPosition, width: buttonSize, height: buttonSize)
        tenSecForwardButton.setBackgroundImage(forwardImage, for: .normal)
        tenSecForwardButton.addTarget(self, action: #selector(tenSecForwardAction), for: .primaryActionTriggered)
        playBackControlsView.addSubview(tenSecForwardButton)

        fullScreenButton = UIButton(type: .custom)
        fullScreenButton.frame = CGRect(x: playBackControlsView.bounds.size.width - buttonSize - 20 , y: buttonYPosition, width: buttonSize, height: buttonSize)
        fullScreenButton.setBackgroundImage(fullScreenImage, for: .normal)
        fullScreenButton.addTarget(self, action: #selector(fullScreenAction), for: .primaryActionTriggered)
        playBackControlsView.addSubview(fullScreenButton)
        
        if self.bounds == UIScreen.main.bounds {
            fullScreenButton.isEnabled = false
        } else {
            fullScreenButton.isEnabled = true
        }
    }

    func setUpSeekBarControls() {
        
        let yPosition = controlsView.bounds.size.height * 0.56
        let seekBarControlsView = UIView(frame: CGRect(x: 0, y: yPosition, width: controlsView.bounds.size.width, height: controlsView.bounds.size.height * 0.44))
        seekBarControlsView.backgroundColor = UIColor.clear
        controlsView.addSubview(seekBarControlsView)

        let lblYPosition = (seekBarControlsView.bounds.size.height - 30) / 2
        currentDurationLbl = UILabel(frame: CGRect(x: 30, y: lblYPosition, width: 100, height: 30))
        currentDurationLbl.text = "00:00"
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

    override public func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        guard context.nextFocusedView != nil else {
            return
        }

        context.nextFocusedView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        context.previouslyFocusedView?.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    override public func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
       guard let buttonPress = presses.first?.type else { return }

       switch(buttonPress) {
       case .playPause:
          print("Play/Pause")
        playPauseAction()
       default:
        print("default action")
        }
        
//        controlsView.isHidden = false
    }
}

extension TvOSAVPlayer {
    
    @objc func sliderValueChanges(_ slider: TvOSSlider) {
        
        var newTime = 0.0
        if slider.value > self.currentValue {
            newTime = Float64(slider.value) + seekDuration
        } else {
            newTime = Float64(slider.value) - seekDuration
        }
        
        let time: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
        avPlayer.seek(to: time)
    }

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
        seekBarSlider.value = Float(CMTimeGetSeconds(duration))
        currentValue = Float(CMTimeGetSeconds(duration))
    }

    @objc func playPauseAction() {

        playingStatus = !playingStatus

        if playingStatus == true {
            playOrPauseButton.setBackgroundImage(pauseImage, for: .normal)
            avPlayer.play()
        } else {
            playOrPauseButton.setBackgroundImage(playImage, for: .normal)
            avPlayer.pause()
        }
    }

    @objc func tenSecBackwardAction() {
        
        let playerCurrentTime = CMTimeGetSeconds(avPlayer.currentTime())
        var newTime = playerCurrentTime - seekDuration

        if newTime < 0 {
            newTime = 0
        }

        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        avPlayer.seek(to: time2)
    }

    @objc func tenSecForwardAction() {

        guard let duration  = avPlayer.currentItem?.duration else {
            return
        }

        let playerCurrentTime = CMTimeGetSeconds(avPlayer.currentTime())
        let newTime = playerCurrentTime + seekDuration

        if newTime < CMTimeGetSeconds(duration) {
            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            avPlayer.seek(to: time2)
        }
    }

    @objc func fullScreenAction() {
        print("full screen action")
    }
}

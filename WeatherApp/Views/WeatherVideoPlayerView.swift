//
//  WeatherVideoPlayerView.swift
//  WeatherApp
//
//  Created by Devmal Wijesinghe on 2025-01-12.
// Code refference declaration: the following code on how to utilize the AVKit and AVFoundation
// relies on the example provided here: https://betterprogramming.pub/how-to-create-a-looping-video-background-in-swiftui-3-0-b4844553880d
import SwiftUI
import AVKit
import AVFoundation

struct WeatherVideoPlayerView: UIViewRepresentable {
    @Binding var videoName: String  // Accept video name as a parameter

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<WeatherVideoPlayerView>) {
        // Update the video when videoName changes
        if let loopingView = uiView as? LoopingPlayerUIView {
            loopingView.updateVideo(videoName: videoName)
        }
    }

    func makeUIView(context: Context) -> UIView {
        let view = LoopingPlayerUIView(frame: .zero)
        view.updateVideo(videoName: videoName) // Initial setup
        return view
    }
}
class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var player: AVQueuePlayer?
    private var currentVideoName: String? // Keep track of the current video name to avoid duplicate setups
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    private func setupPlayer() {
        player = AVQueuePlayer()
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
    }
    
    func updateVideo(videoName: String) {
        // Check if the video is already playing
        guard currentVideoName != videoName else {
            print("Video already set to \(videoName), no need to update.")
            return
        }
        
        // Add a transition animation
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.5 // Adjust duration as needed
        playerLayer.add(transition, forKey: "videoTransition")
        
        // Update the current video name
        currentVideoName = videoName
        
        // Stop and clear the current player looper
        player?.pause()
        player?.removeAllItems()
        playerLooper = nil
        
        // Load the new video
        if let fileUrl = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            let asset = AVURLAsset(url: fileUrl)
            let newItem = AVPlayerItem(asset: asset)
            
            // Create a new player looper
            if let player = player {
                playerLooper = AVPlayerLooper(player: player, templateItem: newItem)
                player.play()
            }
        } else {
            print("Error: Video file \(videoName).mp4 not found in the bundle.")
        }
    }
}

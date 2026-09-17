//
//  AudioPlayerViewModel.swift
//  MiniCalm
//
//  Created by Varun Sharma on 17/09/26.
//
import Foundation
import AVFoundation

class AudioPlayerViewModel {
    private var player: AVPlayer?
    private var timeObserverToken: Any?
    var currentSpeed: PlayBackSpeed = .speed1x
    /// Tracks current playback state
    var playingStatus: Bool = false
    
    
    
    var onProgressUpdate: ((Float) -> Void)?
    
    init() {
        configureAudioSession()
    }
    
    /// Sets up background playback and respects device sound settings
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure AVAudioSession: \(error.localizedDescription)")
        }
    }
    
    /// Toggles playback state between play and pause
    func playAudio() {
        playingStatus.toggle()
        
        guard let url = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") else {
            print("Invalid URL")
            playingStatus = false
            return
        }
        
        // Lazy initialization of AVPlayer
        if player == nil {
            player = AVPlayer(url: url)
        }
        
        if playingStatus {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    func seek(to percentage: Float) {
            guard let currentItem = player?.currentItem else { return }
            let totalSeconds = currentItem.duration.seconds
            
            guard totalSeconds > 0 && !totalSeconds.isNaN else { return }
            
            let targetTime = CMTime(seconds: Double(percentage) * totalSeconds, preferredTimescale: 1000)
            player?.seek(to: targetTime)
        }
    
    func togglePlaybackSpeed() -> PlayBackSpeed {
            currentSpeed = currentSpeed.next
            
         
            if playingStatus {
                player?.rate = currentSpeed.rawValue
            }
            
            return currentSpeed
        }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self,
                  let currentItem = self.player?.currentItem else { return }
            
            let duration = currentItem.duration.seconds
            let currentTime = time.seconds
            
            if duration > 0 {
                let progress = Float(currentTime / duration)
                self.onProgressUpdate?(progress)
            }
        }
    }
    deinit {
            if let token = timeObserverToken {
                player?.removeTimeObserver(token)
            }
        }
}

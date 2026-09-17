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
    
    /// Tracks current playback state
    var playingStatus: Bool = false
    
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
        
        guard let url = URL(string: "") else {
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
}

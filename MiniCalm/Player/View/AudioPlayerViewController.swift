//
//  AudioPlayerViewController.swift
//  MiniCalm
//
//  Created by Varun Sharma on 17/09/26.
//

import SwiftUI
import UIKit
import AVFoundation


class AudioPlayerViewController: UIViewController {
    
    var session: Session?
    var viewModel = AudioPlayerViewModel()
    var audioUrl:String?
    let playButton = UIButton(type: .custom)
    
    
    private var isScrubbing = false
    
    let premiumImage = UIImageView()
    let playbackSpeedButton = UIButton()
    let titleLabel = UILabel()
    let teacherTitle = UILabel()
    let bgImage = UIImageView()
    
    let progressSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.tintColor = .systemPurple
        return slider
    }()
    
    init(session: Session? = nil) {
        self.session = session
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupActions()
        bindViewModel()
        configureSessionData()
    }
    
    private func bindViewModel() {
        viewModel.onProgressUpdate = { [weak self] progress in
            guard let self = self, !self.isScrubbing else { return }
            self.progressSlider.setValue(progress, animated: true)
        }
    }
    
    
    @objc private func didTapPlayButton() {
        viewModel.playAudio(audioUrl: session?.audioUrl)
        let imageName = viewModel.playingStatus ? "pause.circle" : "play.circle"
        playButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
    @objc private func sliderTouchBegan() {
        isScrubbing = true
    }
    
    @objc private func sliderTouchEnded() {
        viewModel.seek(to: progressSlider.value)
        isScrubbing = false
    }
    
    @objc private func didTapSpeedButton() {
        let newSpeed = viewModel.togglePlaybackSpeed()
        playbackSpeedButton.setTitle(newSpeed.title, for: .normal)
    }
    
    private func configureSessionData() {
        guard let session = session else { return }
        
        titleLabel.text = session.title
        teacherTitle.text = session.teacher
        premiumImage.isHidden = !session.isPremium
        
        
        // Fetch background image asynchronously if present
        if let artworkUrl = session.artworkUrl {
            URLSession.shared.dataTask(with: artworkUrl) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.bgImage.image = image
                    }
                }
            }.resume()
        }
    }
    
    
    private func setupActions() {
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        progressSlider.addTarget(self, action: #selector(sliderTouchBegan), for: .touchDown)
        progressSlider.addTarget(self, action: #selector(sliderTouchEnded), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        playbackSpeedButton.addTarget(self, action: #selector(didTapSpeedButton), for: .touchUpInside)
    }
    
    
    private func setupUI() {
        
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        bgImage.image = UIImage(named: "bgImage")
        bgImage.contentMode = .scaleAspectFill
        bgImage.clipsToBounds = true
        bgView.addSubview(bgImage)
        
        teacherTitle.translatesAutoresizingMaskIntoConstraints = false
        teacherTitle.text = "Teacher 1"
        teacherTitle.textColor = .white
        
        premiumImage.translatesAutoresizingMaskIntoConstraints = false
        premiumImage.image = UIImage(named: "crown")
        
        let playerView = UIView()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.backgroundColor = darkPurple.withAlphaComponent(0.9)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Dummy Music 1"
        titleLabel.textColor = .white
        
        playbackSpeedButton.translatesAutoresizingMaskIntoConstraints = false
        playbackSpeedButton.setTitle("1x", for: .normal)
        playbackSpeedButton.tintColor = .systemPurple
        playbackSpeedButton.setImage(UIImage(systemName: "figure.run"), for: .normal)
        playbackSpeedButton.contentHorizontalAlignment = .fill
        playbackSpeedButton.contentVerticalAlignment = .fill
        playbackSpeedButton.imageView?.contentMode = .scaleAspectFit
        
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.tintColor = .systemPurple
        playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        playButton.contentHorizontalAlignment = .fill
        playButton.contentVerticalAlignment = .fill
        playButton.imageView?.contentMode = .scaleAspectFit
        
        playerView.addSubview(titleLabel)
        playerView.addSubview(playbackSpeedButton)
        playerView.addSubview(playButton)
        playerView.addSubview(progressSlider)
        playerView.addSubview(teacherTitle)
        playerView.addSubview(premiumImage)
        
        view.addSubview(bgView)
        view.addSubview(playerView)
        
        NSLayoutConstraint.activate([
            // bgView
            bgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            // bgView Subviews
            bgImage.topAnchor.constraint(equalTo: bgView.topAnchor),
            bgImage.bottomAnchor.constraint(equalTo: bgView.bottomAnchor),
            bgImage.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            bgImage.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            
            // playerView
            playerView.topAnchor.constraint(equalTo: bgView.bottomAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // playerView Subviews
            titleLabel.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 20),
            
            teacherTitle.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 20),
            teacherTitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            playbackSpeedButton.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -20),
            playbackSpeedButton.centerYAnchor.constraint(equalTo: teacherTitle.centerYAnchor),
            playbackSpeedButton.widthAnchor.constraint(equalToConstant: 100),
            playbackSpeedButton.heightAnchor.constraint(equalToConstant: 30),
            
            playButton.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: playerView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            
            progressSlider.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 20),
            progressSlider.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -20),
            progressSlider.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            
        ])
    }
}

// SwiftUI Bridge
struct AudioPlayerViewControllerRepresentable: UIViewControllerRepresentable {
    let session: Session

    func makeUIViewController(context: Context) -> AudioPlayerViewController {
        return AudioPlayerViewController(session: session)
    }
    
    func updateUIViewController(_ uiViewController: AudioPlayerViewController, context: Context) {
        uiViewController.session = session
    }
}

//
//  SoundPlayer.swift
//  EggBoilingTimer
//
//  Created by joonwon lee on 2020/04/10.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import AVFoundation

enum SoundType: Int {
    case rooster
    case babyChick
    
    var key: String {
        switch self {
        case .rooster: return "rooster"
        case .babyChick: return "babyChick"
        }
    }
    
    var url: URL {
        let url = Bundle.main.url(forResource: self.key, withExtension: "mp3")!
        return url
    }
}

class SoundPlayer {
    static let shared = SoundPlayer()
    private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    var soundType: SoundType {
        return TimerConfiguration.sound
    }
    
    var isPlaying: Bool {
        return audioPlayer.isPlaying
    }
    
    init() {
        createPlayer(TimerConfiguration.sound.url)
        configureAudioSession()
    }
    
    func createPlayer(_ url: URL) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
        } catch {
            fatalError()
        }
    }
    
    func change(_ type: SoundType) {
        let url = type.url
        createPlayer(url)
        UserDefaults.standard.set(type.rawValue, forKey: "sound")
    }
    
    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        } catch let error {
            print("Err: Cannot configure audiosession, - \(error.localizedDescription)")
        }
    }
    
    func play() {
        audioPlayer.play()
    }
    
    func stop() {
        audioPlayer.pause()
    }
}


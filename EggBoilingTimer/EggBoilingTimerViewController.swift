//
//  EggBoilingTimerViewController.swift
//  EggBoilingTimer
//
//  Created by joonwon lee on 2020/03/24.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class EggBoilingTimerViewController: UIViewController {

    @IBOutlet weak var chickenHeadTop: NSLayoutConstraint!
    @IBOutlet weak var chickenHeadHeight: NSLayoutConstraint!
    @IBOutlet weak var typeViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    let viewModel = EggBoilingTimerViewModel()
    let volumeView = MPVolumeView(frame: CGRect(x: -100, y: -100, width: 50, height: 50))
    var previousVolume: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(volumeView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustConstraints()
        resetUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("---> volume: \(volumeView.volume)")
        previousVolume = volumeView.volume
    }
    
    @IBAction func softButtonTapped(_ sender: Any) {
        guard SoundPlayer.shared.isPlaying == false, viewModel.isTimerRunning == false else { return }
        viewModel.updateBoilingTime(type: .soft)
        timerLabel.text = viewModel.timeString
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    @IBAction func mediumButtonTapped(_ sender: Any) {
        guard SoundPlayer.shared.isPlaying == false, viewModel.isTimerRunning == false else { return }
        viewModel.updateBoilingTime(type: .medium)
        timerLabel.text = viewModel.timeString
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    @IBAction func hardButtonTapped(_ sender: Any) {
        guard SoundPlayer.shared.isPlaying == false, viewModel.isTimerRunning == false else { return }
        viewModel.updateBoilingTime(type: .hard)
        timerLabel.text = viewModel.timeString
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        guard viewModel.eggBoilingTime > 0 else {
            let alert = UIAlertController(title: "잠깐만요", message: "타이머 시작을 위해서 시간을 설정해주세요!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        startButton.isSelected = !startButton.isSelected
        resetButton.isEnabled = !startButton.isSelected
        let isStarted = startButton.isSelected
        if isStarted {
            volumeView.setVolume(0.8)
            viewModel.startTimer { [unowned self] remainingString in
                self.timerLabel.text = remainingString
            }
        } else {
            volumeView.setVolume(previousVolume)
            viewModel.stopTimer()
            timerLabel.text = viewModel.timeString
        }
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        guard viewModel.isTimerRunning == false  else { return }
        print("--> able to reset")
        viewModel.resetTime()
        timerLabel.text = viewModel.timeString
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController else { return }
        present(vc, animated: true, completion: nil)
    }
    
}

extension EggBoilingTimerViewController {
    private func adjustConstraints() {
          if IdentityHelper.isSmallScreen {
              chickenHeadHeight.constant = 0
          } else if IdentityHelper.isMediumScreen, UIScreen.hasNotch == false {
              chickenHeadTop.constant = 20
          } else {
              chickenHeadTop.constant = 80
              typeViewBottom.constant = 80
          }
      }
      
      private func resetUI() {
          startButton.isSelected = false
          startButton.layer.cornerRadius = startButton.bounds.height/2
          startButton.layer.masksToBounds = true
          timerLabel.text = "00 : 00"
      }
}

class EggBoilingTimerViewModel {
    
    init() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    enum EggBoilingType {
        case soft
        case medium
        case hard
        
        var time: TimeInterval {
            switch self {
            case .soft: return 6 * 60
            case .medium: return 8 * 60
            case .hard: return 10 * 60
            }
        }
    }
    
    var eggBoilingTime: TimeInterval = 0
    var targetTime: Date = Date()
    
    var timeString: String {
        guard eggBoilingTime > 0 else { return "00 : 00" }
        return secondsToString(sec: eggBoilingTime)
    }
    
    func resetTime() {
        eggBoilingTime = 0
    }
    
    func updateBoilingTime(type: EggBoilingType) {
        resetTime()
        eggBoilingTime = type.time
    }
    
    private func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00 : 00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d : %02d", min, seconds)
    }
    
    var timer: Timer?
    
    var isTimerRunning: Bool {
        return timer != nil
    }
    
    func startTimer(completion: @escaping (String) -> Void) {
        guard eggBoilingTime > 0 else { return }
        targetTime = Date(timeInterval: eggBoilingTime, since: Date())
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [unowned self] timer in
            let remaining = self.targetTime.timeIntervalSince(Date())
            
            if remaining <= 0 {
                completion("00 : 00")
                timer.invalidate()
                self.playSound()
            } else {
                let timeString = self.secondsToString(sec: remaining)
                completion(timeString)
            }
        }
        timer?.fire()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        resetTime()
        stopSound()
    }
    
    func playSound() {
        print("--> playSound")
        SoundPlayer.shared.play()
    }
    
    func stopSound() {
        print("--> stopSound")
        SoundPlayer.shared.stop()
    }
}

class SoundPlayer {
    static let shared = SoundPlayer()
    
    private let audioPlayer: AVAudioPlayer

    var isPlaying: Bool {
        return audioPlayer.isPlaying
    }
    
    init() {
        let url = Bundle.main.url(forResource: "rooster", withExtension: "mp3")!
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
        } catch {
            fatalError()
        }
        configureAudioSession()
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

extension MPVolumeView {
    func setVolume(_ volume: Float) {
        let slider = self.subviews.first { $0 is UISlider } as? UISlider
        slider?.value = volume
    }
    
    var volume: Float {
        let slider = self.subviews.first { $0 is UISlider } as? UISlider
        return slider?.value ?? 0
    }
}

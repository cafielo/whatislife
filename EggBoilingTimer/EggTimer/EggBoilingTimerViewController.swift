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
    
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var softTimeLabel: UILabel!
    @IBOutlet weak var mediumTimeLabel: UILabel!
    @IBOutlet weak var hardTimeLabel: UILabel!
    
    let viewModel = EggBoilingTimerViewModel()
    let volumeView = MPVolumeView(frame: CGRect(x: -100, y: -100, width: 50, height: 50))
    var previousVolume: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        adjustConstraints()
        updateTimeLabel()
        
        previousVolume = volumeView.volume
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimeLabel), name: .boilingTimeConfigDidChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        guard viewModel.eggBoilingType != .none else {
            showDefaultAlert(title: "잠깐만요", message: "타이머 시작을 위해서 시간을 설정해주세요!", actionTitle: "확인")
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        startButton.isSelected = !startButton.isSelected
        resetButton.isEnabled = !startButton.isSelected
        
        let isStarted = startButton.isSelected
        if isStarted {
            #if DEBUG
            volumeView.setVolume(0.1)
            #else
            volumeView.setVolume(0.8)
            #endif
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
    @objc private func updateTimeLabel() {
        softTimeLabel.text = "\(TimerConfiguration.softTime)분"
        mediumTimeLabel.text = "\(TimerConfiguration.mediumTime)분"
        hardTimeLabel.text = "\(TimerConfiguration.hardTime)분"
    }
    
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
    
    private func configUI() {
        startButton.isSelected = false
        startButton.layer.cornerRadius = startButton.bounds.height/2
        startButton.layer.masksToBounds = true
        timerLabel.text = "00 : 00"
        view.addSubview(volumeView)
    }
}

extension EggBoilingTimerViewController: AlertPresentable {
    var presenter: UIViewController {
        return self
    }
}


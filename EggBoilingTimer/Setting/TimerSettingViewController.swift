//
//  TimerSettingViewController.swift
//  EggBoilingTimer
//
//  Created by joonwon lee on 2020/04/03.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit

class TimerSettingViewController: UIViewController {
    
    @IBOutlet weak var softTimeLabel: UILabel!
    @IBOutlet weak var mediumTimeLabel: UILabel!
    @IBOutlet weak var hardTimeLabel: UILabel!
    
    @IBOutlet weak var roosterButton: UIButton!
    @IBOutlet weak var babyChickButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    var softTime: Int = TimerConfiguration.softTime
    var mediumTime: Int = TimerConfiguration.mediumTime
    var hardTime: Int = TimerConfiguration.hardTime
    
    private func updateUI() {
        softTimeLabel.text = String(format: "%2d", TimerConfiguration.softTime)
        mediumTimeLabel.text = String(format: "%2d", TimerConfiguration.mediumTime)
        hardTimeLabel.text = String(format: "%2d", TimerConfiguration.hardTime)
        
        roosterButton.isSelected = SoundPlayer.shared.soundType == .rooster
        babyChickButton.isSelected = !roosterButton.isSelected
    }
    
    private func sync() {
        UserDefaults.standard.set(softTime, forKey: EggBoilingType.soft.userdefaultKey)
        UserDefaults.standard.set(mediumTime, forKey: EggBoilingType.medium.userdefaultKey)
        UserDefaults.standard.set(hardTime, forKey: EggBoilingType.hard.userdefaultKey)
        updateUI()
        NotificationCenter.default.post(name: .boilingTimeConfigDidChanged, object: nil)
    }
    
    @IBAction func addSoft(_ sender: Any) {
        softTime += 1
        sync()
    }
    
    @IBAction func subtractSoft(_ sender: Any) {
        guard softTime > 1 else { return }
        softTime -= 1
        sync()
    }
    
    @IBAction func addMedium(_ sender: Any) {
        mediumTime += 1
        sync()
    }
    
    @IBAction func subtractMedium(_ sender: Any) {
        guard mediumTime > 1 else { return }
        mediumTime -= 1
        sync()
    }
    
    
    @IBAction func addHard(_ sender: Any) {
        hardTime += 1
        sync()
    }
    
    @IBAction func subtractHard(_ sender: Any) {
        guard hardTime > 1 else { return }
        hardTime -= 1
        sync()
    }
    
    @IBAction func roosterTapped(_ sender: Any) {
        guard SoundPlayer.shared.isPlaying == false else {
            return
        }
        
        roosterButton.isSelected = !roosterButton.isSelected
        babyChickButton.isSelected = !babyChickButton.isSelected
        SoundPlayer.shared.change(.rooster)
    }
    
    @IBAction func babyChickTapped(_ sender: Any) {
        guard SoundPlayer.shared.isPlaying == false else {
            return
        }
        
        roosterButton.isSelected = !roosterButton.isSelected
        babyChickButton.isSelected = !babyChickButton.isSelected
        SoundPlayer.shared.change(.babyChick)
    }
}


class TimerConfiguration {
    
    struct DefaultConfig {
        let softTime: Int = 6
        let meidumTime: Int = 8
        let hardTime: Int = 10
        
        let sound: SoundType = .rooster
    }
    
    static let `default` = DefaultConfig()
    
    static var softTime: Int {
        let customTime = UserDefaults.standard.integer(forKey: EggBoilingType.soft.userdefaultKey)
        return customTime > 0 ? customTime : TimerConfiguration.default.softTime
    }
    
    static var mediumTime: Int {
        let customTime = UserDefaults.standard.integer(forKey: EggBoilingType.medium.userdefaultKey)
        return customTime > 0 ? customTime : TimerConfiguration.default.meidumTime
    }
    
    static var hardTime: Int {
        let customTime = UserDefaults.standard.integer(forKey: EggBoilingType.hard.userdefaultKey)
        return customTime > 0 ? customTime : TimerConfiguration.default.hardTime
    }
    
    static var sound: SoundType {
        let type = UserDefaults.standard.integer(forKey: "sound")
        return SoundType(rawValue: type) ?? TimerConfiguration.default.sound
    }
}

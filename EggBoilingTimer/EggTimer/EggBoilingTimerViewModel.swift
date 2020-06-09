//
//  EggBoilingTimerViewModel.swift
//  EggBoilingTimer
//
//  Created by joonwon lee on 2020/04/10.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit

enum EggBoilingType: String, Codable {
    case soft
    case medium
    case hard
    case none
    
    var userdefaultKey: String {
        return self.rawValue
    }
    
    var time: TimeInterval {
        switch self {
        case .soft: return TimeInterval(TimerConfiguration.softTime) * 60
        case .medium: return TimeInterval(TimerConfiguration.mediumTime) * 60
        case .hard: return TimeInterval(TimerConfiguration.hardTime) * 60
        case .none: return 0
        }
    }
    
    var title: String {
        switch self {
        case .soft: return "핵촉촉"
        case .medium: return "촉촉"
        case .hard: return "퍽퍽"
        case .none: return "-"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .soft: return  #imageLiteral(resourceName: "img_soft_egg")
        case .medium: return #imageLiteral(resourceName: "img_medium_egg")
        case .hard: return #imageLiteral(resourceName: "img_hard_egg")
        case .none: return #imageLiteral(resourceName: "img_soft_egg")
        }
    }
}


struct BoilingHistory: Codable {
    let type: EggBoilingType
    let timestamp: TimeInterval
}

class EggBoilingTimerViewModel {
    
    init() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    var eggBoilingType: EggBoilingType = .soft
    var targetTime: Date = Date()
    
    var timeString: String {
        guard eggBoilingType != .none else { return "00 : 00" }
        return secondsToString(sec: eggBoilingType.time)
    }
    
    func resetTime() {
        eggBoilingType = .none
    }
    
    func updateBoilingTime(type: EggBoilingType) {
        resetTime()
        eggBoilingType = type
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
        guard eggBoilingType != .none else { return }
        targetTime = Date(timeInterval: eggBoilingType.time, since: Date())
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [unowned self] timer in
            let remaining = self.targetTime.timeIntervalSince(Date())
            if remaining <= 0 {
                completion("00 : 00")
                timer.invalidate()
                self.playSound()
                let history = BoilingHistory(type: self.eggBoilingType, timestamp: Date().timeIntervalSince1970)
                HistoryManager.shared.addHistory(history)
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

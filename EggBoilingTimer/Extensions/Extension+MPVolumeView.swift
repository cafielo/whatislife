//
//  Extension+MPVolumeView.swift
//  EggBoilingTimer
//
//  Created by joonwon lee on 2020/04/10.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import MediaPlayer

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

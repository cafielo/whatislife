//
//  Extension+UIScreen.swift
//  EggBoilingTimer
//
//  Created by joonwon lee on 2020/04/10.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit

extension UIScreen {
    static var hasNotch: Bool {
        let insets = UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
        return insets.bottom > 0
    }
}

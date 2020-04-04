//
//  IdentifyHelper.swift
//  EggBoilingTimer
//
//  Created by joonwon lee on 2020/03/24.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import Foundation

/// Get the screen width
public var SCREEN_WIDTH: CGFloat {
    get {
        return UIScreen.main.bounds.width
    }
}

/// Get the screen height
public var SCREEN_HEIGHT: CGFloat {
    get {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        if statusBarHeight > 20 {
            return UIScreen.main.bounds.height - 20
        }
        return UIScreen.main.bounds.height
    }
}

class IdentityHelper {
    
    static let isSmallScreen: Bool = SCREEN_HEIGHT <= 568
    static let isMediumScreen: Bool = SCREEN_HEIGHT > 568 && SCREEN_HEIGHT < 812
    
    /// Weather it's running on iPad or not
    static let isPad: Bool = {
        return UI_USER_INTERFACE_IDIOM() == .pad
    }()
    
    
    static var isDebugging: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}


extension UIScreen {
    static var hasNotch: Bool {
        let insets = UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
        return insets.bottom > 0
    }
}

//
//  Window+Extenstions.swift
//  CNavBarLib
//
//  Created by Talish George on 24/06/20.
//  Copyright © 2020 Talish George. All rights reserved.
//

import Foundation
import UIKit

public extension UIWindow {
    
    /// Protperty return true, if the device is >= iPhone X
    /// - Parameter
    /// - Returns:bool value
    var hasTopNotch: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }
}

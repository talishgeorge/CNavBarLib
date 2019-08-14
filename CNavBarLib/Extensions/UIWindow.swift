//
//  Window+Extenstions.swift
//  CNavBarLib
//
//  Created by Talish George on 14/08/19.
//  Copyright © 2019 Talish George. All rights reserved.
//

import Foundation
import UIKit

public extension UIWindow {
    /// Protperty return true, if the device is >= iPhone X
    /// - Parameter
    /// - Returns:bool value
    var hasTopNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}

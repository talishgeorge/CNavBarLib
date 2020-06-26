//
//  UIApplication.swift
//  CNavBarLib
//
//  Created by Talish George on 24/06/20.
//  Copyright © 2020 Talish George. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {

    /// Get Status bar view
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

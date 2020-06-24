//
//  UIApplication.swift
//  CNavBarLib
//
//  Created by Talish George on 02/09/19.
//  Copyright © 2019 Talish George. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {

    /// Get Status bar view
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

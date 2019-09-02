//
//  UIApplication.swift
//  CNavBarLib
//
//  Created by Talish George on 02/09/19.
//  Copyright © 2019 Talish George. All rights reserved.
//

import Foundation
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

//
//  UIViewController.swift
//  CNavBarLib
//
//  Created by Talish George on 24/06/20.
//  Copyright © 2020 Talish George. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {

    /// Get Top View Controller
    func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
}

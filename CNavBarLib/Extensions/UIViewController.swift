//
//  UIViewController.swift
//  CNavBarLib
//
//  Created by Talish George on 14/08/19.
//  Copyright © 2019 Talish George. All rights reserved.
//

import Foundation
public extension UIViewController {
     func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
}

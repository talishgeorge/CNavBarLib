//
//  UIVew+Exentsion.swift
//  OakLib
//
//  Created by Talish George on 24/06/20.
//  Copyright © 2020 Talish George. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    /// Controller
    public func controller() -> UIViewController? {
        if let nextViewControllerResponder = next as? UIViewController {
            return nextViewControllerResponder
        } else if let nextViewResponder = next as? UIView {
            return nextViewResponder.controller()
        } else {
            return nil
        }
    }

    /// Navigation Controller
    public func navigationController() -> UINavigationController? {
        if let controller = controller() {
            return controller.navigationController
        } else {
            return nil
        }
    }
}

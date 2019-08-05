//
//  Constants.swift
//  CNavBarLib
//
//  Created by Talish George on 05/08/19.
//  Copyright © 2019 Talish George. All rights reserved.
//

import Foundation
import UIKit

public struct NavBarConstants {
    /// Specify this property to determine the navigation bar background color.
    public static var barBGColor: UIColor = UIColor.init(hexString: "#0074b1", alpha: 1.0)
    public static var transparentBGColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    /// Specify this property to determine which title color that would be used
    /// at the midst of navigation bar.
    public static var titleColor: UIColor = UIColor.init(hexString: "#FFFFFF", alpha: 1.0)
    public static var transparentTitleColor: UIColor = UIColor.init(hexString: "#fc3d39", alpha: 1.0)
    /// Specify this property to determine the image that would be used as
    /// the back button's image.
    public static var leftNavButtonImage: UIImage = UIImage(named: "back-navigation")!
    public static var rightNavButtonImage: UIImage = UIImage(named: "menu")!
    /// Specify this property to determine which title font that would be used
    /// at the midst of navigation bar.
    public static var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 16)
    public static var nibName = "CNavBar"
}

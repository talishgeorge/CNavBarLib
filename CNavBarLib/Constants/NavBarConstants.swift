//
//  Constants.swift
//  CNavBarLib
//
//  Created by Talish George on 05/08/19.
//  Copyright © 2019 Talish George. All rights reserved.
//

import Foundation
import UIKit
/// Customizable Properties for the Nav Bar.
public struct NavBarConstants {
    /// Specify this property to determine the navigation bar background color.
    public static var barBGColor: UIColor = UIColor.blue
    /// Specify this property to determine the navigation bar transparent background color.
    public static var transparentBGColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    /// Specify this property to determine which title color that would be used
    /// at the midst of navigation bar.
    public static var titleColor: UIColor = UIColor.white
    /// Specify this property to determine the navigation bar transparent title color.
    public static var transparentTitleColor: UIColor = UIColor.white
    /// Specify this property to determine the image that would be used as
    /// the back button image.
    public static var leftNavButtonImage: UIImage = UIImage()
    /// Specify this property to determine the image that would be used as
    /// the right button image.
    public static var rightNavButtonImage: UIImage = UIImage()
    /// Specify this property to determine which title font
    public static var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 16)
    /// Specify this property to determine which left & right title font
    public static var leftRightTitleFont: UIFont = UIFont.boldSystemFont(ofSize: 12)
    /// Specify this property to set the nav bar title
    public static var titleText: String = ""
    /// Specify this property to set the nav bar left title
    public static var leftTitleText: String = ""
    /// Specify this property to set the nav bar right title
    public static var rightTitleText: String = ""
    /// Specify this property to set the progressbar BG color
    public static var backgroundProgressBarColor: UIColor = UIColor.lightGray
    /// Specify this property to set the progressbar bar color
    public static var progressBarColor: UIColor = UIColor.white
    /// Specify this property to set the progressbar height
    public static var heightForLinearBar: CGFloat = 5
    /// Specify this property to set the progressbar width
    public static var widthForLinearBar: CGFloat = 0
    ///Progressbar Animation mode
    public static var animaitonType: ProgressType = .fill
    public static var rootNavigationController: UINavigationController?
}

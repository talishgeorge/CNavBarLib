//
//  CustomNavigationBar.swift
//  CNavBarLib
//
//  Created by Talish George on 24/06/20.
//  Copyright © 2020 Talish George. All rights reserved.
//

import Foundation
import UIKit

/// Custom Navigation Bar
public class CustomNavigationBar: UINavigationBar {

    static public let shared = CustomNavigationBar()
    public var onLeftButtonAction: OnLeftButtonAction = nil
    public var onRightButtonAction: OnRightButtonAction = nil
    public var  navigationBar = NavBarConstants.rootNavigationController?.navigationBar
    private var horizontalProgressBar: HorizontalProgressBar = HorizontalProgressBar()
}

extension CustomNavigationBar {

    /// User Tapped back button
    /// - Parameter sender: UIButton
    @objc func leftBarButtonTapped(sender: UIButton) {
        onLeftButtonAction?(true)
    }

    /// User Tapped Right button
    /// - Parameter sender: UIButton
    @objc func rightBarButtonTapped(sender: UIButton) {
        onRightButtonAction?(true)
    }
}

public extension CustomNavigationBar {

    /// Update Navigation
    func updateNavigation() {
        navigationBar = NavBarConstants.rootNavigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        var barView = navigationBar?.subviews.first?.subviews.first
        if barView == nil || barView != nil && type(of: barView!) != UIView.self {
            barView = UIView(frame: CGRect.zero)
            if let navBarSize = navigationBar?.frame.size {
                let statusBarSize = UIApplication.shared.statusBarFrame.size
                barView?.frame.size = CGSize(width: navBarSize.width, height: navBarSize.height + statusBarSize.height)
            }
            navigationBar?.subviews.first?.insertSubview(barView!, at: 0)
        }
        barView?.backgroundColor = NavBarConstants.barBGColor
        var titleTextAttributes = navigationBar?.titleTextAttributes ?? [:]
        titleTextAttributes[NSAttributedString.Key.foregroundColor] = NavBarConstants.titleColor
        titleTextAttributes[NSAttributedString.Key.font] = NavBarConstants.titleFont
        navigationBar?.titleTextAttributes = titleTextAttributes
        navigationBar?.items?.first?.title = NavBarConstants.titleText
        //Nav bar Left Button
        navigationBar?.items?.first?.leftBarButtonItems = []
        let backImage = NavBarConstants.leftNavButtonImage
        var imageButtonFrame = CGRect(x: 0, y: 0, width: backImage.size.width, height: backImage.size.width)
        var imageButton = UIButton(frame: imageButtonFrame)
        imageButton.setImage(backImage, for: .normal)
        imageButton.addTarget(self, action: #selector(leftBarButtonTapped(sender:)), for: .touchUpInside)
        var imageBarButtonItem = UIBarButtonItem(customView: imageButton)
        navigationBar?.items?.first?.leftBarButtonItems?.append(imageBarButtonItem)
        var textBarButtonItem = UIBarButtonItem(title: NavBarConstants.leftTitleText,
                                                style: .plain,
                                                target: self,
                                                action: #selector(leftBarButtonTapped(sender:)))
        textBarButtonItem.tintColor = NavBarConstants.titleColor
        navigationBar?.items?.first?.leftBarButtonItems?.append(textBarButtonItem)
        //Nav Bar Right Button
        navigationBar?.items?.first?.rightBarButtonItems = []
        configureNavBarRightItem(&imageButtonFrame, &imageButton, &imageBarButtonItem, &textBarButtonItem)
        navigationBar?.items?.first?.rightBarButtonItems?.append(textBarButtonItem)
    }

    /// Apply Theme to Navigation Bar
    /// - Parameters:
    ///   - opacity: CGFloat
    ///   - color: UIColor
    func applyTransparentBackgroundToTheNavigationBar(_ opacity: CGFloat, _ color: UIColor) {
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.isTranslucent = true
        navigationBar?.backgroundColor = UIColor.clear
        let barView = navigationBar?.subviews.first?.subviews.first
        barView?.backgroundColor = color
    }

    /// Reset Navigation
    func resetNavigation() {
        navigationBar?.prefersLargeTitles = false
    }

    /// Start Horizonatal Progress bar
    func startHorizontalProgressbar() {
        let navigationBarHeight: CGFloat = (navigationBar?.frame.height)!
        let navigationBarWidth: CGFloat = (navigationBar?.frame.width)!
        horizontalProgressBar = HorizontalProgressBar(frame: CGRect(x: 0,
                                                                    y: navigationBarHeight,
                                                                    width: navigationBarWidth,
                                                                    height: NavBarConstants.heightForLinearBar))
        navigationBar?.addSubview(horizontalProgressBar)
        horizontalProgressBar.startAnimating()
    }

    /// Hide Progress Bar
    func hideProgressBar() {
        horizontalProgressBar.stopAnimating()
    }

    /// Enable Larfe Title Display Mode
    /// - Parameter color: UIColor
    func enableLargeTitleDisplayMode(_ color: UIColor) {
        navigationBar?.prefersLargeTitles = true
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        let barView = navigationBar?.subviews.first?.subviews.first
        barView?.backgroundColor = color
        navigationBar?.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "Papyrus", size: 30) ??
                UIFont.systemFont(ofSize: 30)]
    }
}

private extension CustomNavigationBar {

    /// Configure NavBar RightItem
    private func configureNavBarRightItem(_ imageButtonFrame: inout CGRect,
                                          _ imageButton: inout UIButton,
                                          _ imageBarButtonItem: inout UIBarButtonItem,
                                          _ textBarButtonItem: inout UIBarButtonItem) {
        let righImage = NavBarConstants.rightNavButtonImage
        imageButtonFrame = CGRect(x: 0, y: 0, width: righImage.size.width, height: righImage.size.width)
        imageButton = UIButton(frame: imageButtonFrame)
        imageButton.setImage(righImage, for: .normal)
        imageButton.addTarget(self, action: #selector(rightBarButtonTapped(sender:)), for: .touchUpInside)
        imageBarButtonItem = UIBarButtonItem(customView: imageButton)
        navigationBar?.items?.first?.rightBarButtonItems?.append(imageBarButtonItem)
        textBarButtonItem = UIBarButtonItem(title: NavBarConstants.rightTitleText,
                                            style: .plain,
                                            target: self,
                                            action: #selector(rightBarButtonTapped(sender:)))
        textBarButtonItem.tintColor = NavBarConstants.titleColor
    }
}

//
//  CustomNavigationBar.swift
//  CNavBarLib
//
//  Created by Talish George on 01/09/19.
//  Copyright © 2019 Talish George. All rights reserved.
//

import Foundation

public class CustomNavigationBar: UINavigationBar {
    static public let shared = CustomNavigationBar()
    public var onLeftButtonAction: OnLeftButtonAction = nil
    public var onRightButtonAction: OnRightButtonAction = nil
    public var  navigationBar = NavBarConstants.rootNavigationController?.navigationBar
    private var horizontalProgressBar: HorizontalProgressBar = HorizontalProgressBar()
    public func updateNavigation() {
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
        navigationBar?.items?.first?.rightBarButtonItems?.append(textBarButtonItem)
    }
    public func applyTransparentBackgroundToTheNavigationBar(_ opacity: CGFloat, _ color: UIColor) {
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.isTranslucent = true
        navigationBar?.backgroundColor = UIColor.clear
        let barView = navigationBar?.subviews.first?.subviews.first
        barView?.backgroundColor = color
    }
    public func resetNavigation() {
        navigationBar?.prefersLargeTitles = false
    }
    public func startHorizontalProgressbar() {
        let navigationBarHeight: CGFloat = (navigationBar?.frame.height)!
        let navigationBarWidth: CGFloat = (navigationBar?.frame.width)!
        horizontalProgressBar = HorizontalProgressBar(frame: CGRect(x: 0,
                                                                    y: navigationBarHeight,
                                                                    width: navigationBarWidth,
                                                                    height: NavBarConstants.heightForLinearBar))
        navigationBar?.addSubview(horizontalProgressBar)
        horizontalProgressBar.startAnimating()
    }
    public func hideProgressBar() {
        horizontalProgressBar.stopAnimating()
    }
    public func enableLargeTitleDisplayMode(_ color: UIColor) {
        navigationBar?.prefersLargeTitles = true
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        let barView = navigationBar?.subviews.first?.subviews.first
        barView?.backgroundColor = color
        navigationBar?.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "Papyrus", size: 30) ??
                UIFont.systemFont(ofSize: 30)]
    }
    @objc func leftBarButtonTapped(sender: UIButton) {
        onLeftButtonAction?(true)
    }
    @objc func rightBarButtonTapped(sender: UIButton) {
        onRightButtonAction?(true)
    }
}

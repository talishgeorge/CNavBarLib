///  CustomNavigationController.swift
///  Created by Talish George on 08/08/19.
///  Copyright © 2019 Talish George. All rights reserved.

import Foundation
import UIKit
///  Fully customizable Navigation controller typically displayed at the top of the screen
public class CustomNavigationController: UIView {
    ///Left nav bar button action
    public var onLeftButtonAction: ((_ success: Bool) -> Void)?
    ///Right nav bar button action
    public var onRightButtonAction: ((_ success: Bool) -> Void)?
    ///Linear activity indicator with material design
    var linearBar: LinearProgressBar = LinearProgressBar()
    ///Horizon progress bar
    var horizontalProgressBar: HorizontalProgressbar = HorizontalProgressbar()
    ///IBOutlets for nav bar
    @IBOutlet weak var rightNavBarButtonImage: UIImageView!
    @IBOutlet weak var leftNavButtonImage: UIImageView!
    @IBOutlet var outerContentView: UIView!
    @IBOutlet var innerContentView: UIView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var rightTitleLabel: UILabel!
    ///Protperty Observer for left nav button visibility
    /// - Parameter
    /// - Returns
    public var isLeftTitleHidden: Bool {
        didSet {
            self.leftTitleLabel.isHidden = isLeftTitleHidden
        }
    }
    ///Protperty Observer for right nav button visibility
    /// - Parameter
    /// - Returns
    public var isRightTitleHidden: Bool {
        didSet {
            self.rightTitleLabel.isHidden = isRightTitleHidden
        }
    }
    ///This constructor/initializer will be called when we are creating view programmatically with init(frame: CGRect)
    /// - Parameter NSCoder
    /// - Returns
    public override init(frame: CGRect) {
        self.isLeftTitleHidden = false
        self.isRightTitleHidden = false
        super.init(frame: frame)
    }
    ///This constructore is called when the view is unarchived from a nib.
    /// - Parameter NSCoder
    /// - Returns:
    public required init?(coder aDecoder: NSCoder) {
        self.isLeftTitleHidden = false
        self.isRightTitleHidden = false
        super.init(coder: aDecoder)
    }
    /// Configure safearea layout constraints for the custom view
    /// - Parameter UILayoutGuide
    /// - Returns:
    public func setupSafeAreaGuide(guide: UILayoutGuide) {
        AppConstants.yPos = AppConstants.osXOffSet
        if #available(iOS 11, *) {
            //self.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            self.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            if hasTopNotch == false {
                self.heightAnchor.constraint(equalToConstant: AppConstants.defaultOffSet).isActive = true
                AppConstants.yPos = AppConstants.defaultOffSet
            }
        } else {
            let standardSpacing: CGFloat = 0.0
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: standardSpacing),
                safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.bottomAnchor, constant: standardSpacing)
                ])
        }
    }
    /// Protperty return true, if the device is >= iPhone X
    /// - Parameter
    /// - Returns:bool value
    var hasTopNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    /// Load Navigation Bar
    /// - Parameter sender
    /// - Returns:Custom NavigationController
    public static func loadNavBar() -> CustomNavigationController {
        let bundle =  Bundle(for: CustomNavigationController.self)
        let nib = UINib(nibName: AppConstants.nibName, bundle: bundle)
        let custView = (nib.instantiate(withOwner: self, options: nil)[0] as? CustomNavigationController)!
        return custView
    }
    /// Invoked when user tapped right nav button
    /// - Parameter sender
    /// - Returns:
    @IBAction func userTappedRightButton(_ sender: Any) {
        onRightButtonAction?(true)
    }
    /// Invoked when user tapped left nav button
    /// - Parameter sender
    /// - Returns:
    @IBAction func userTappedLeftButton(_ sender: Any) {
        onLeftButtonAction?(true)
    }
    /// Configure Navigation Bar
    /// - Parameter
    /// - Returns:
    public func configureNavBar() {
        setBGColorWithAlpha(alpha: Float(AppConstants.alpha))
        self.leftNavButtonImage.image = NavBarConstants.leftNavButtonImage
        self.rightNavBarButtonImage.image = NavBarConstants.rightNavButtonImage
        self.titleLabel.text = NavBarConstants.titleText
        self.leftTitleLabel.text = NavBarConstants.leftTitleText
        self.rightTitleLabel.text = NavBarConstants.rightTitleText
    }
    ///Set Transparency for the nav bar
    /// - Parameter alpha value
    /// - Returns:
    public func setTransparency(alpha: Float) {
        self.backgroundColor =  UIColor.black.withAlphaComponent(CGFloat(alpha))//NavBarConstants.transparentBGColor
        self.outerContentView.backgroundColor = UIColor.clear
        self.innerContentView.backgroundColor = UIColor.clear
        self.leftButton?.setTitleColor(NavBarConstants.transparentTitleColor, for: .normal)
        self.rightButton?.setTitleColor(NavBarConstants.transparentTitleColor, for: .normal)
        setNavBarTitle()
    }
    ///Configure Nav bar title
    /// - Parameter
    /// - Returns:
    private func setNavBarTitle() {
        self.titleLabel.textColor = NavBarConstants.titleColor
        self.titleLabel.font = NavBarConstants.titleFont
        self.leftTitleLabel.textColor = NavBarConstants.titleColor
        self.leftTitleLabel.font = NavBarConstants.leftRightTitleFont
        self.rightTitleLabel.textColor = NavBarConstants.titleColor
        self.rightTitleLabel.font = NavBarConstants.leftRightTitleFont
    }
    ///Configure set bachground color for the nav bar
    /// - Parameter alpha value
    /// - Returns:
    public func setBGColorWithAlpha(alpha: Float) {
        self.backgroundColor = NavBarConstants.barBGColor
        self.alpha = AppConstants.alpha
        self.outerContentView.backgroundColor = NavBarConstants.barBGColor
        self.innerContentView.backgroundColor = NavBarConstants.barBGColor
        self.leftButton.setTitleColor(NavBarConstants.titleColor, for: .normal)
        self.rightButton.setTitleColor(NavBarConstants.titleColor, for: .normal)
        setNavBarTitle()
    }
    ///Start linear progress bar with material rendering
    /// - Parameter
    /// - Returns:
    public func startLinearProgress() {
        linearBar.heightForLinearBar = NavBarConstants.heightForLinearBar
        linearBar.backgroundProgressBarColor = NavBarConstants.backgroundProgressBarColor
        linearBar.progressBarColor = NavBarConstants.progressBarColor
        linearBar.yPos = AppConstants.yPos
        linearBar.startAnimating()
    }
    ///Start horizontal progress bar
    /// - Parameter
    /// - Returns:
    public func stratHorizontalProgressbar() {
        self.horizontalProgressBar = HorizontalProgressbar(frame: CGRect(x: 0,
                                                                         y: AppConstants.yPos,
                                                                         width: self.frame.size.width,
                                                                         height: NavBarConstants.heightForLinearBar))
        self.addSubview(horizontalProgressBar)
        horizontalProgressBar.noOfChunks = 1
        horizontalProgressBar.progressTintColor = NavBarConstants.progressBarColor
        horizontalProgressBar.trackTintColor = NavBarConstants.backgroundProgressBarColor
        horizontalProgressBar.loadingStyle = .fill
        horizontalProgressBar.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            //self.horizontalProgressBar.stopAnimating()
        }
    }
    ///Hide progress progress bar
    /// - Parameter
    /// - Returns:
    public func hidePrgressBar() {
        self.horizontalProgressBar.stopAnimating()
        linearBar.stopAnimation()
    }
}

extension UIView {
    public func controller() -> UIViewController? {
        if let nextViewControllerResponder = next as? UIViewController {
            return nextViewControllerResponder
        } else if let nextViewResponder = next as? UIView {
            return nextViewResponder.controller()
        } else {
            return nil
        }
    }
    public func navigationController() -> UINavigationController? {
        if let controller = controller() {
            return controller.navigationController
        } else {
            return nil
        }
    }
}

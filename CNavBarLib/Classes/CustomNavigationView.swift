///  CustomNavigationController.swift
///  Created by Talish George on 08/08/19.
///  Copyright © 2019 Talish George. All rights reserved.

import Foundation
import UIKit
public typealias OnLeftButtonAction = ((_ success: Bool) -> Void)?
public typealias OnRightButtonAction = ((_ success: Bool) -> Void)?

///  Fully customizable Navigation controller typically displayed at the top of the screen
public class CustomNavigationView: UIView {
    // MARK: - Private Stored Properties
    ///Linear activity indicator with material design
    private var linearBar: LinearProgressBar = LinearProgressBar()
    ///Horizon progress bar
    private var horizontalProgressBar: HorizontalProgressBar = HorizontalProgressBar()
    // MARK: - IBOutlets
    ///IBOutlets for Nav Bar
    @IBOutlet weak var rightNavBarButtonImage: UIImageView!
    @IBOutlet weak var leftNavButtonImage: UIImageView!
    @IBOutlet var outerContentView: UIView!
    @IBOutlet var innerContentView: UIView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var rightTitleLabel: UILabel!
    // MARK: - Public Stored Properties
    ///Left nav bar button action
    public var onLeftButtonAction: OnLeftButtonAction = nil
    ///Right nav bar button action
    public var onRightButtonAction: OnRightButtonAction = nil
    ///Protperty Observer for left nav button visibility
    /// - Parameter
    /// - Returns
    public var isLeftTitleHidden: Bool? {
        didSet {
            self.leftTitleLabel.isHidden = isLeftTitleHidden ?? false
        }
    }
    ///Protperty Observer for right nav button visibility
    /// - Parameter
    /// - Returns
    public var isRightTitleHidden: Bool? {
        didSet {
            self.rightTitleLabel.isHidden = isRightTitleHidden ?? false
        }
    }
    // MARK: - Init  
    ///This constructor/initializer will be called when we are creating view programmatically with init(frame: CGRect)
    /// - Parameter NSCoder
    /// - Returns
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    ///This constructore is called when the view is unarchived from a nib.
    /// - Parameter NSCoder
    /// - Returns:
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public func initializeMemberVariables() {
        self.isLeftTitleHidden = false
        self.isRightTitleHidden = false
        self.onLeftButtonAction = nil
        self.onRightButtonAction = nil
    }
}
// MARK: - Private Methods
private extension CustomNavigationView {
    ///Configure Nav bar title
    /// - Parameter
    /// - Returns:
    private func setNavigationBarTitle() {
        self.titleLabel.textColor = NavBarConstants.titleColor
        self.titleLabel.font = NavBarConstants.titleFont
        self.leftTitleLabel.textColor = NavBarConstants.titleColor
        self.leftTitleLabel.font = NavBarConstants.leftRightTitleFont
        self.rightTitleLabel.textColor = NavBarConstants.titleColor
        self.rightTitleLabel.font = NavBarConstants.leftRightTitleFont
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
}
// MARK: - Public Methods
public extension CustomNavigationView {
    /// Configure safearea layout constraints for the custom view
    /// - Parameter UILayoutGuide
    /// - Returns:
    func setupSafeArea(guide: UILayoutGuide) {
        AppConstants.yPos = AppConstants.osXOffSet
        if #available(iOS 11, *) {
            self.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            self.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            if UIApplication.shared.keyWindow?.hasTopNotch == false {
                self.heightAnchor.constraint(equalToConstant: AppConstants.defaultOffSet).isActive = true
                AppConstants.yPos = AppConstants.defaultOffSet
            }
        } else {
            let margins = self.layoutMarginsGuide
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
                ])
        }
    }
    /// Load Navigation Bar
    /// - Parameter sender
    /// - Returns:Custom NavigationController
    static func loadNavigationBar() -> CustomNavigationView {
        let bundle =  Bundle(for: CustomNavigationView.self)
        let nib = UINib(nibName: AppConstants.nibName, bundle: bundle)
        let custView = (nib.instantiate(withOwner: self, options: nil)[0] as? CustomNavigationView)!
        return custView
    }
    func configureNavigationBar() {
        setBackgroundColorWithAlpha(alpha: Float(AppConstants.alpha))
        self.leftNavButtonImage.image = NavBarConstants.leftNavButtonImage
        self.rightNavBarButtonImage.image = NavBarConstants.rightNavButtonImage
        self.titleLabel.text = NavBarConstants.titleText
        self.leftTitleLabel.text = NavBarConstants.leftTitleText
        self.rightTitleLabel.text = NavBarConstants.rightTitleText
    }
    ///Set Transparency for the nav bar
    /// - Parameter alpha value
    /// - Returns:
    func setTransparency(alpha: Float) {
        self.backgroundColor =  UIColor.black.withAlphaComponent(CGFloat(alpha))//NavBarConstants.transparentBGColor
        self.outerContentView.backgroundColor = UIColor.clear
        self.innerContentView.backgroundColor = UIColor.clear
        self.leftButton?.setTitleColor(NavBarConstants.transparentTitleColor, for: .normal)
        self.rightButton?.setTitleColor(NavBarConstants.transparentTitleColor, for: .normal)
        setNavigationBarTitle()
    }
    ///Configure set bachground color for the nav bar
    /// - Parameter alpha value
    /// - Returns:
    func setBackgroundColorWithAlpha(alpha: Float) {
        self.backgroundColor = NavBarConstants.barBGColor
        self.alpha = AppConstants.alpha
        self.outerContentView.backgroundColor = NavBarConstants.barBGColor
        self.innerContentView.backgroundColor = NavBarConstants.barBGColor
        self.leftButton.setTitleColor(NavBarConstants.titleColor, for: .normal)
        self.rightButton.setTitleColor(NavBarConstants.titleColor, for: .normal)
        setNavigationBarTitle()
    }
    ///Start linear progress bar with material rendering
    /// - Parameter
    /// - Returns:
    func startLinearProgressbar() {
        linearBar.startAnimating()
    }
    ///Start horizontal progress bar
    /// - Parameter
    /// - Returns:
    func startHorizontalProgressbar() {
        self.horizontalProgressBar = HorizontalProgressBar(frame: CGRect(x: 0,
                                                                         y: AppConstants.yPos,
                                                                         width: self.frame.size.width,
                                                                         height: NavBarConstants.heightForLinearBar))
        self.addSubview(horizontalProgressBar)
        horizontalProgressBar.startAnimating()
    }
    ///Hide progress progress bar
    /// - Parameter
    /// - Returns:
    func hideProgressBar() {
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

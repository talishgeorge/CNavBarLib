//
//  CNavBar.swift
//  CustomNavBar
//
//  Created by Talish George on 26/07/19.
//  Copyright © 2019 Talish George. All rights reserved.
//

import Foundation
import UIKit

public class CustomNavigationController: UIView {

    var view: CustomNavigationController!
    var nibName: String = NavBarConstants.nibName
    public var onLeftButtonAction: ((_ success: Bool) -> Void)?
    public var onRightButtonAction: ((_ success: Bool) -> Void)?
    var timer: Timer?
    var linearBar: LinearProgressBar = LinearProgressBar()
    var horizontalProgressBar: HorizontalProgressbar = HorizontalProgressbar()
    public var backgroundProgressBarColor: UIColor = UIColor.lightGray
    public var progressBarColor: UIColor = UIColor.white
    public var heightForLinearBar: CGFloat = 5
    public var widthForLinearBar: CGFloat = 0
    public var yPos: CGFloat = 0
    @IBOutlet weak var rightNavBarButtonImage: UIImageView!
    @IBOutlet weak var leftNavButtonImage: UIImageView!
    @IBOutlet var outerContentView: UIView!
    @IBOutlet var innerContentView: UIView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    //This constructor/initializer will be called when we are creating view programmatically with init(frame: CGRect)
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    public func setupSafeAreaGuide(guide: UILayoutGuide) {
        yPos = NavBarConstants.osXOffSet
        if #available(iOS 11, *) {
            //self.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            self.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            if hasTopNotch == false {
               self.heightAnchor.constraint(equalToConstant: NavBarConstants.yOffSet).isActive = true
                 yPos = NavBarConstants.yOffSet
            }
        } else {
            let standardSpacing: CGFloat = 0.0
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: standardSpacing),
                safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.bottomAnchor, constant: standardSpacing)
                ])
        }
    }
    var hasTopNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    public static func loadNavBar() -> CustomNavigationController {
        let bundle =  Bundle(for: CustomNavigationController.self)
        let nib = UINib(nibName: NavBarConstants.nibName, bundle: bundle)
        let custView = (nib.instantiate(withOwner: self, options: nil)[0] as? CustomNavigationController)!
        return custView
    }
    @IBAction func userTappedRightButton(_ sender: Any) {
        onRightButtonAction?(true)
    }
    @IBAction func userTappedLeftButton(_ sender: Any) {
        onLeftButtonAction?(true)
    }
    public func configureNavBar() {
        setBGColorWithAlpha(alpha: 1.0)
        self.leftNavButtonImage.image = NavBarConstants.leftNavButtonImage
        self.rightNavBarButtonImage.image = NavBarConstants.rightNavButtonImage
        self.titleLabel.text = NavBarConstants.titleText
    }
    public func setTransparency(alpha: Float) {
        self.backgroundColor =  UIColor.black.withAlphaComponent(CGFloat(alpha))//NavBarConstants.transparentBGColor
        self.outerContentView.backgroundColor = UIColor.clear
        self.innerContentView.backgroundColor = UIColor.clear
        self.leftButton?.setTitleColor(NavBarConstants.transparentTitleColor, for: .normal)
        self.rightButton?.setTitleColor(NavBarConstants.transparentTitleColor, for: .normal)
        self.titleLabel?.textColor = NavBarConstants.transparentTitleColor
        self.titleLabel.font = NavBarConstants.titleFont
    }
    public func setBGColorWithAlpha(alpha: Float) {
        self.backgroundColor = NavBarConstants.barBGColor
        self.alpha = 1.0
        self.outerContentView.backgroundColor = NavBarConstants.barBGColor
        self.innerContentView.backgroundColor = NavBarConstants.barBGColor
        self.leftButton.setTitleColor(NavBarConstants.titleColor, for: .normal)
        self.rightButton.setTitleColor(NavBarConstants.titleColor, for: .normal)
        self.titleLabel.textColor = NavBarConstants.titleColor
        self.titleLabel.font = NavBarConstants.titleFont
    }
    public func startLinearProgress() {
        linearBar.heightForLinearBar = heightForLinearBar
        linearBar.backgroundProgressBarColor = backgroundProgressBarColor
        linearBar.progressBarColor = progressBarColor
        linearBar.yPos = yPos
        linearBar.startAnimating()
    }
    public func stratHorizontalProgressbar() {
        self.horizontalProgressBar = HorizontalProgressbar(frame: CGRect(x: 0,
                                                              y: yPos,
                                                              width: self.frame.size.width,
                                                              height: heightForLinearBar))
        self.addSubview(horizontalProgressBar)
        horizontalProgressBar.noOfChunks = 1
        horizontalProgressBar.progressTintColor = progressBarColor
        horizontalProgressBar.trackTintColor = backgroundProgressBarColor
        horizontalProgressBar.loadingStyle = .fill
        horizontalProgressBar.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
         //self.horizontalProgressBar.stopAnimating()
        }
    }
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

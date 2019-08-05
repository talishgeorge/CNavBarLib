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
    var counter = 0.0
    @IBOutlet weak var progressBar: CustomProgressBar!
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
        print("override init(frame: CGRect)")
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    public func setupSafeAreaGuide(guide: UILayoutGuide) {
        if #available(iOS 11, *) {
            //self.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            self.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            if hasTopNotch == false {
               self.heightAnchor.constraint(equalToConstant: 64).isActive = true
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
        hidePrgressBar()
        self.leftNavButtonImage.image = NavBarConstants.leftNavButtonImage
        self.rightNavBarButtonImage.image = NavBarConstants.rightNavButtonImage
    }
    public func setTransparency(alpha: Float) {
        self.backgroundColor =  NavBarConstants.transparentBGColor
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
    public func setupButtonView() {
        progressBar.layer.cornerRadius = progressBar.frame.height / 2
        progressBar.clipsToBounds = true
    }
    public func startProgress() {
        counter = 0.0
        self.progressBar.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                                     selector: #selector(update), userInfo: nil,
                                     repeats: true)
    }
    public func hidePrgressBar() {
        progressBar.isHidden = true
    }
    @objc func update () {
        self.progressBar.linearLoadingWith(progress: CGFloat(counter))
        counter += 1
        if counter > 100 {
            timer?.invalidate()
            self.progressBar.isHidden = true
        }
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

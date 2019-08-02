//
//  CNavBar.swift
//  CustomNavBar
//
//  Created by Talish George on 26/07/19.
//  Copyright © 2019 Talish George. All rights reserved.
//

import Foundation
import UIKit

public class CNavBar: UIView {
    let kCONTENT_XIB_NAME = "CNavBar"
    var view: CNavBar!
    var nibName: String = "CNavBar"
    public var onLeftButtonAction: ((_ success: Bool) -> ())?
    public var onRightButtonAction: ((_ success: Bool) -> ())?
    var timer: Timer?
    var i = 0.0
    @IBOutlet weak var progressBar: CustomProgressBar!
    @IBOutlet weak var rightNavBarButtonImage: UIImageView!
    @IBOutlet weak var leftNavButtonImage: UIImageView!
    @IBOutlet var outerContentView: UIView!
    @IBOutlet var innerContentView: UIView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    /// Specify this property to determine the navigation bar background color.
   var barBackgroundColor: UIColor { return .white }
    
    /// Specify this property to determine which title color that would be used
    /// at the midst of navigation bar.
    var titleColor: UIColor { return .black }
    
    /// Specify this property to determine which title font that would be used
    /// at the midst of navigation bar.
    var titleFont: UIFont { return .systemFont(ofSize: 17) }
    
    /// Specify this property to determine the image that would be used as
    /// the back button's image.
    var backImage: UIImage? { return nil }
    
    /// Specify this property to determine the text that would be used at
    /// the right of the back button's image.
    var backText: String? { return nil }
    
    var isUsingInteractivePopGesture: Bool { return true }
    // #1
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init(image: UIImage, title: String) {
        self.init(frame: .zero)
        titleLabel.text = title
    }
    
    public func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func commonInit() {
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
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
    public func setupView() -> CNavBar {
        self.view = UINib(nibName: nibName, bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as? CNavBar
        return self.view
    }
    
    @IBAction func userTappedRightButton(_ sender: Any) {
        print("Hello Right")
        onRightButtonAction?(true)
    }
    
    @IBAction func userTappedLeftButton(_ sender: Any) {
        print("Hello left")
        onLeftButtonAction?(true)
    }
    
    public func setTransparency(alpha:Float) {
        //self.backgroundColor = UIColor.clear
        //self.alpha = 0.8
        //self.backgroundColor = UIColor(white: 1, alpha: 0.2)
        self.backgroundColor =  UIColor.black.withAlphaComponent(0.3)
            
        self.outerContentView.backgroundColor = UIColor.clear
        self.innerContentView.backgroundColor = UIColor.clear
//        UIView.animate(withDuration: 5.0, delay: 2.0, animations: {
//            self.alpha = 0
//            print("animations")
//        })
        self.leftButton?.setTitleColor(UIColor.init(hexString: "#fc3d39", alpha: alpha), for: .normal)
        self.rightButton?.setTitleColor(UIColor.init(hexString: "#fc3d39", alpha: alpha), for: .normal)
       self.titleLabel?.textColor = UIColor.init(hexString: "#fc3d39", alpha: alpha)
    }
    
    public func setTransparency() {
        //self.backgroundColor = UIColor.clear
         //self.alpha = 0.8
        //self.backgroundColor = UIColor(white: 1, alpha: 0.2)
        self.backgroundColor =  UIColor.black.withAlphaComponent(0.3)
        self.outerContentView.backgroundColor = UIColor.clear
        self.innerContentView.backgroundColor = UIColor.clear
        self.leftButton?.setTitleColor(UIColor.init(hexString: "#fc3d39", alpha: 1.0), for: .normal)
        self.rightButton?.setTitleColor(UIColor.init(hexString: "#fc3d39", alpha: 1.0), for: .normal)
        self.titleLabel?.textColor = UIColor.init(hexString: "#fc3d39", alpha: 1.0)
    }
    
    public func setBGColor() {
        self.backgroundColor = UIColor.init(hexString: "#0074b1", alpha: 1.0)
        self.alpha = 1.0
        self.outerContentView.backgroundColor = UIColor.init(hexString: "#0074b1", alpha: 1.0)
        self.innerContentView.backgroundColor = UIColor.init(hexString: "#0074b1", alpha: 1.0)
        
        self.leftButton.setTitleColor(UIColor.init(hexString: "#FFFFFF", alpha: 1.0), for: .normal)
        self.rightButton.setTitleColor(UIColor.init(hexString: "#FFFFFF",alpha: 1.0), for: .normal)
        self.titleLabel.textColor = UIColor.init(hexString: "#FFFFFF",alpha: 1.0)
    }
    
    public func setBGColorWithAlpha(alpha:Float) {
        self.backgroundColor = UIColor.init(hexString: "#0074b1", alpha: alpha)
        self.alpha = 1.0
        self.outerContentView.backgroundColor = UIColor.init(hexString: "#0074b1", alpha: alpha)
        self.innerContentView.backgroundColor = UIColor.init(hexString: "#0074b1", alpha: alpha)
        self.leftButton.setTitleColor(UIColor.init(hexString: "#FFFFFF", alpha: 1.0), for: .normal)
        self.rightButton.setTitleColor(UIColor.init(hexString: "#FFFFFF",alpha: 1.0), for: .normal)
        self.titleLabel.textColor = UIColor.init(hexString: "#FFFFFF",alpha: 1.0)
        
//        UIView.animate(withDuration: 0.2, animations: { () -> Void in
//            self.backgroundColor = UIColor.init(hexString: "3b5998", alpha: alpha)
//        })
    }
    
    public func setupButtonView() {
        progressBar.layer.cornerRadius = progressBar.frame.height / 2
        progressBar.clipsToBounds = true
    }
    
    public func startProgress() {
        i = 0.0
        self.progressBar.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update () {
        self.progressBar.linearLoadingWith(progress: CGFloat(i))
        i += 1
        if i > 100 {
            timer?.invalidate()
            self.progressBar.isHidden = true
        }
    }
    
    public func hidePrgressBar() {
        progressBar.isHidden = true
    }
    
}

extension UIView
{
    public func controller() -> UIViewController? {
        if let nextViewControllerResponder = next as? UIViewController {
            return nextViewControllerResponder
        }
        else if let nextViewResponder = next as? UIView {
            return nextViewResponder.controller()
        }
        else  {
            return nil
        }
    }
    
    public func navigationController() -> UINavigationController? {
        if let controller = controller() {
            return controller.navigationController
        }
        else {
            return nil
        }
    }
    
}


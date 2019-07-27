//
//  CNavBar.swift
//  CustomNavBar
//
//  Created by Talish George on 26/07/19.
//  Copyright © 2019 Talish George. All rights reserved.
//

import Foundation
import UIKit

class CNavBar: UIView {
    
    let kCONTENT_XIB_NAME = "CNavBar"
    let MAXTIME : Float = 10.0
    var currentTime :Float = 0.0
    
    @IBOutlet var outerContentView: UIView!
    @IBOutlet var innerContentView: UIView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var prgressView: UIProgressView!
    let progress = Progress(totalUnitCount: 10)
    
    // #1
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // #2
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // #3
    public convenience init(image: UIImage, title: String) {
        self.init(frame: .zero)
        titleLabel.text = title
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        //commonInit()
        // Create, add and layout the children views ..
    }
    
    func commonInit() {
        // Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        //fixInView(self)
    }
    
    func setBGColor() {
        self.outerContentView.backgroundColor = UIColor.init(hexString: "00bfff")
    }
    
    func setupSafeAreaGuide(guide: UILayoutGuide) {
        if #available(iOS 11, *) {
            self.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
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
    
    class func getScreen() -> CNavBar {
        let xib = Bundle.main.loadNibNamed(String(describing :self), owner: self, options: nil)
        let navBar = xib![0] as! CNavBar
        return navBar
    }
    
    @IBAction func userTappedRightButton(_ sender: Any) {
        print("Hello Right")
    }
    
    @IBAction func userTappedLeftButton(_ sender: Any) {
        print("Hello left")
    }
    
    func startProgress() {
        prgressView.setProgress(currentTime, animated: true)
        perform(#selector(updateProgress), with: nil, afterDelay: 0.5)
    }
    
    @objc func updateProgress() {
        currentTime = currentTime + 1.0
        prgressView.progress = currentTime/MAXTIME
        
        if currentTime < MAXTIME {
           perform(#selector(updateProgress), with: nil, afterDelay: 0.5)
        }
        else{
            currentTime = 0.0
            updateProgress()
        }
    }
}

extension UIView
{
    func getNavBarheight() -> Float {
        return Float(self.frame.size.height)
    }
}

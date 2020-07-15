//
//  Created by TCS.
//  Copyright © 2020 TCS. All rights reserved.
//  

import Foundation
import UIKit

/**
 Adjusts the length (constant value) of the bottom layout constraint when keyboard shows and hides.
 */
@objc public class UnderKeyboardLayoutConstraint: NSObject {
    private weak var bottomLayoutConstraint: NSLayoutConstraint?
    private var keyboardObserver = UnderKeyboardObserver()
    private var initialConstraintConstant: CGFloat = 0
    private var minMargin: CGFloat = 10
    
    private var viewToAnimate: UIView?
    
    /// Creates an instance of the class
    public override init() {
        super.init()
        
        keyboardObserver.willAnimateKeyboard = { [weak self] height in
            self?.keyboardWillAnimate(height)
        }
        keyboardObserver.animateKeyboard = { [weak self] height in
            self?.animateKeyboard(height)
        }
        
        keyboardObserver.start()
    }
    
    deinit {
        stop()
    }
    
    /// Stop listening for keyboard notifications.
    public func stop() {
        keyboardObserver.stop()
    }
    
    /**
     
     Supply a bottom Auto Layout constraint. Its constant value will be adjusted by the height of the keyboard when it appears and hides.
     
     - parameter bottomLayoutConstraint: Supply a bottom layout constraint. Its constant value will be adjusted when keyboard is shown and hidden.
     
     - parameter view: Supply a view that will be used to animate the constraint. It is usually the superview containing the view with the constraint.
     
     - parameter minMargin: Specify the minimum margin between the keyboard and the bottom of the view the constraint is attached to. Default: 10.
     
     */
    public func setup(_ bottomLayoutConstraint: NSLayoutConstraint,
                      view: UIView,
                      minMargin: CGFloat = 10) {
        
        initialConstraintConstant = bottomLayoutConstraint.constant
        self.bottomLayoutConstraint = bottomLayoutConstraint
        self.minMargin = minMargin
        self.viewToAnimate = view
        
        // Keyboard is already open when setup is called
        if let currentKeyboardHeight = keyboardObserver.currentKeyboardHeight, currentKeyboardHeight > 0 {
            keyboardWillAnimate(currentKeyboardHeight)
        }
    }
    
    func keyboardWillAnimate(_ height: CGFloat) {
        guard let bottomLayoutConstraint = bottomLayoutConstraint else { return }
        if height > 0 {
            let newConstantValue = height + minMargin
            
            if newConstantValue > initialConstraintConstant {
                // Keyboard height is bigger than the initial constraint length.
                // Increase constraint length.
                bottomLayoutConstraint.constant = newConstantValue
            } else {
                // Keyboard height is NOT bigger than the initial constraint length.
                // Show the initial constraint length.
                bottomLayoutConstraint.constant = initialConstraintConstant
            }
            
        } else {
            bottomLayoutConstraint.constant = initialConstraintConstant
        }
    }
    
    func animateKeyboard(_ height: CGFloat) {
        guard let viewToAnimate = viewToAnimate else { return }
        
        // Check if view is shown, otherwise layoutIfNeeded() will crash
        if viewToAnimate.window != nil {
            viewToAnimate.layoutIfNeeded()
        }
    }
}

/**
 Detects appearance of software keyboard and calls the supplied closures that can be used for changing the layout and moving view from under the keyboard.
 */
public final class UnderKeyboardObserver: NSObject {
    public typealias AnimationCallback = (_ height: CGFloat) -> Void
    
    let notificationCenter: NotificationCenter
    
    /// Function that will be called before the keyboard is shown and before animation is started.
    public var willAnimateKeyboard: AnimationCallback?
    
    /// Function that will be called inside the animation block. This can be used to call `layoutIfNeeded` on the view.
    public var animateKeyboard: AnimationCallback?
    
    /// Current height of the keyboard. Has value `nil` if unknown.
    public var currentKeyboardHeight: CGFloat?
    
    /// Creates an instance of the class
    public override init() {
        notificationCenter = NotificationCenter.default
        super.init()
    }
    
    deinit {
        stop()
    }
    
    /// Start listening for keyboard notifications.
    public func start() {
        stop()
        
        notificationCenter.addObserver(self, selector: #selector(UnderKeyboardObserver.keyboardNotification(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(UnderKeyboardObserver.keyboardNotification(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Stop listening for keyboard notifications.
    public func stop() {
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Notification
    
    @objc func keyboardNotification(_ notification: Notification) {
        let isShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        if let userInfo = (notification as NSNotification).userInfo,
            let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            
            let correctedHeight = isShowing ? height : 0
            willAnimateKeyboard?(correctedHeight)
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: UIView.AnimationOptions(rawValue: animationCurveRawNSN.uintValue),
                           animations: { [weak self] in
                            self?.animateKeyboard?(correctedHeight)
                },
                           completion: nil
            )
            
            currentKeyboardHeight = correctedHeight
        }
    }
}

class SpringAnimationCALayer {
    // Animates layer with spring effect.
    class func animate(_ layer: CALayer,
                       keypath: String,
                       duration: CFTimeInterval,
                       usingSpringWithDamping: Double,
                       initialSpringVelocity: Double,
                       fromValue: Double,
                       toValue: Double,
                       onFinished: (() -> Void)?) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(onFinished)
        
        let animation = create(keypath, duration: duration,
                               usingSpringWithDamping: usingSpringWithDamping,
                               initialSpringVelocity: initialSpringVelocity,
                               fromValue: fromValue, toValue: toValue)
        
        layer.add(animation, forKey: keypath + " spring animation")
        CATransaction.commit()
    }
    
    // Creates CAKeyframeAnimation object
    class func create(_ keypath: String,
                      duration: CFTimeInterval,
                      usingSpringWithDamping: Double,
                      initialSpringVelocity: Double,
                      fromValue: Double,
                      toValue: Double) -> CAKeyframeAnimation {
        
        let dampingMultiplier = Double(10)
        let velocityMultiplier = Double(10)
        
        let values = animationValues(fromValue, toValue: toValue,
                                     usingSpringWithDamping: dampingMultiplier * usingSpringWithDamping,
                                     initialSpringVelocity: velocityMultiplier * initialSpringVelocity)
        
        let animation = CAKeyframeAnimation(keyPath: keypath)
        animation.values = values
        animation.duration = duration
        
        return animation
    }
    
    class func animationValues(_ fromValue: Double,
                               toValue: Double,
                               usingSpringWithDamping: Double,
                               initialSpringVelocity: Double) -> [Double] {
        
        let numOfPoints = 1000
        var values = [Double](repeating: 0.0, count: numOfPoints)
        
        let distanceBetweenValues = toValue - fromValue
        
        for point in (0..<numOfPoints) {
            let x = Double(point) / Double(numOfPoints)
            let valueNormalized = animationValuesNormalized(x,
                                                            usingSpringWithDamping: usingSpringWithDamping,
                                                            initialSpringVelocity: initialSpringVelocity)
            let value = toValue - distanceBetweenValues * valueNormalized
            values[point] = value
        }
        
        return values
    }
    
    private class func animationValuesNormalized(_ x: Double,
                                                 usingSpringWithDamping: Double,
                                                 initialSpringVelocity: Double) -> Double {
        
        return pow(M_E, -usingSpringWithDamping * x) * cos(initialSpringVelocity * x)
    }
}

/**
 
 Calling tap with closure.
 
 */
class OnTap: NSObject {
    var closure: () -> Void
    
    init(view: UIView, gesture: UIGestureRecognizer, closure: @escaping () -> Void ) {
        self.closure = closure
        super.init()
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        gesture.addTarget(self, action: #selector(OnTap.didTap(_:)))
    }
    
    @objc func didTap(_ gesture: UIGestureRecognizer) {
        closure()
    }
}

class TegAutolayoutConstraints {
    class func centerX(_ viewOne: UIView,
                       viewTwo: UIView,
                       constraintContainer: UIView) -> [NSLayoutConstraint] {
        
        return center(viewOne, viewTwo: viewTwo, constraintContainer: constraintContainer, vertically: false)
    }
    
    @discardableResult
    class func centerY(_ viewOne: UIView,
                       viewTwo: UIView,
                       constraintContainer: UIView) -> [NSLayoutConstraint] {
        
        return center(viewOne, viewTwo: viewTwo, constraintContainer: constraintContainer, vertically: true)
    }
    
    private class func center(_ viewOne: UIView,
                              viewTwo: UIView,
                              constraintContainer: UIView,
                              vertically: Bool = false) -> [NSLayoutConstraint] {
        
        let attribute = vertically ? NSLayoutConstraint.Attribute.centerY : NSLayoutConstraint.Attribute.centerX
        let constraint = NSLayoutConstraint(
            item: viewOne,
            attribute: attribute,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: viewTwo,
            attribute: attribute,
            multiplier: 1,
            constant: 0)
        
        constraintContainer.addConstraint(constraint)
        
        return [constraint]
    }
    
    @discardableResult
    class func alignSameAttributes(_ item: AnyObject,
                                   toItem: AnyObject,
                                   constraintContainer: UIView,
                                   attribute: NSLayoutConstraint.Attribute,
                                   margin: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let constraint = NSLayoutConstraint(
            item: item,
            attribute: attribute,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: toItem,
            attribute: attribute,
            multiplier: 1,
            constant: margin)
        
        constraintContainer.addConstraint(constraint)
        
        return [constraint]
    }
    
    class func alignVerticallyToAnchor(_ item: AnyObject,
                                       onTop: Bool,
                                       anchor: NSLayoutYAxisAnchor,
                                       margin: CGFloat = 0) -> [NSLayoutConstraint] {
        let constraint = onTop ? anchor.constraint(equalTo: item.topAnchor) : anchor.constraint(equalTo: item.bottomAnchor)
        constraint.constant = margin
        constraint.isActive = true
        
        return [constraint]
    }
    
    class func aspectRatio(_ view: UIView, ratio: CGFloat) {
        let constraint = NSLayoutConstraint(
            item: view,
            attribute: NSLayoutConstraint.Attribute.width,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: view,
            attribute: NSLayoutConstraint.Attribute.height,
            multiplier: ratio,
            constant: 0)
        view.addConstraint(constraint)
    }
    
    class func fillParent(_ view: UIView, parentView: UIView, margin: CGFloat = 0, vertically: Bool = false) {
        var marginFormat = ""
        
        if margin != 0 {
            marginFormat = "-\(margin)-"
        }
        
        var format = "|\(marginFormat)[view]\(marginFormat)|"
        
        if vertically {
            format = "V:" + format
        }
        
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format,
                                                         options: [], metrics: nil,
                                                         views: ["view": view])
        parentView.addConstraints(constraints)
    }
    
    @discardableResult
    class func viewsNextToEachOther(_ views: [UIView],
                                    constraintContainer: UIView,
                                    margin: CGFloat = 0,
                                    vertically: Bool = false) -> [NSLayoutConstraint] {
        
        if views.count < 2 { return []  }
        var constraints = [NSLayoutConstraint]()
        for (index, view) in views.enumerated() {
            if index >= views.count - 1 { break }
            let viewTwo = views[index + 1]
            constraints += twoViewsNextToEachOther(view, viewTwo: viewTwo,
                                                   constraintContainer: constraintContainer,
                                                   margin: margin,
                                                   vertically: vertically)
        }
        return constraints
    }
    
    class func twoViewsNextToEachOther(_ viewOne: UIView,
                                       viewTwo: UIView,
                                       constraintContainer: UIView,
                                       margin: CGFloat = 0,
                                       vertically: Bool = false) -> [NSLayoutConstraint] {
        var marginFormat = ""
        if margin != 0 {
            marginFormat = "-\(margin)-"
        }
        var format = "[viewOne]\(marginFormat)[viewTwo]"
        
        if vertically {
            format = "V:" + format
        }
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format,
                                                         options: [], metrics: nil,
                                                         views: [ "viewOne": viewOne, "viewTwo": viewTwo ])
        constraintContainer.addConstraints(constraints)
        return constraints
    }
    
    class func equalWidth(_ viewOne: UIView,
                          viewTwo: UIView,
                          constraintContainer: UIView) -> [NSLayoutConstraint] {
        
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "[viewOne(==viewTwo)]",
                                                         options: [],
                                                         metrics: nil,
                                                         views: ["viewOne": viewOne, "viewTwo": viewTwo])
        constraintContainer.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    class func height(_ view: UIView, value: CGFloat) -> [NSLayoutConstraint] {
        return widthOrHeight(view, value: value, isWidth: false)
    }
    
    @discardableResult
    class func width(_ view: UIView, value: CGFloat) -> [NSLayoutConstraint] {
        return widthOrHeight(view, value: value, isWidth: true)
    }
    
    private class func widthOrHeight(_ view: UIView,
                                     value: CGFloat,
                                     isWidth: Bool) -> [NSLayoutConstraint] {
        let attribute = isWidth ? NSLayoutConstraint.Attribute.width : NSLayoutConstraint.Attribute.height
        let constraint = NSLayoutConstraint(
            item: view,
            attribute: attribute,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: value)
        view.addConstraint(constraint)
        return [constraint]
    }
}

public class FBLoafColor {
    /**
     
     Creates a UIColor object from a string.
     
     - parameter rgba: a RGB/RGBA string representation of color. It can include optional alpha value. Example: "#cca213" or "#cca21312" (with alpha value).
     
     - returns: UIColor object.
     
     */
    public class func fromHexString(_ rgba: String) -> UIColor {
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        var alpha: CGFloat = 1.0
        
        if !rgba.hasPrefix("#") {
            print("Warning: FBLoafColor.fromHexString, # character missing")
            return UIColor()
        }
        
        let index = rgba.index(rgba.startIndex, offsetBy: 1)
        let hex = String(rgba.suffix(from: index))
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        
        if !scanner.scanHexInt64(&hexValue) {
            print("Warning: FBLoafColor.fromHexString, error scanning hex value")
            return UIColor()
        }
        
        if hex.count == 6 {
            red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
            blue  = CGFloat(hexValue & 0x0000FF) / 255.0
        } else if hex.count == 8 {
            red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
            blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
            alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
        } else {
            print("Warning: FBLoafColor.fromHexString, invalid rgb string, length should be 7 or 9")
            return UIColor()
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

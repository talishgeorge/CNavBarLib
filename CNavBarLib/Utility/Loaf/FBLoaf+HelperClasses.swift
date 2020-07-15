//
//  Created by TCS.
//  Copyright © 2020 TCS. All rights reserved.
//  

import Foundation
import UIKit

/**
 Used in unit tests to verify the messages that were shown in the message bar.
 */
public struct FBLoafMockResults {
    /// An array of success messages displayed in the message bar.
    public var success: [String] {
        return messages.filter({ $0.preset == FBPresets.success }).map({ $0.message })
    }
    
    /// An array of information messages displayed in the message bar.
    public var info: [String] {
        return messages.filter({ $0.preset == FBPresets.info }).map({ $0.message })
    }
    
    /// An array of warning messages displayed in the message bar.
    public var warning: [String] {
        return messages.filter({ $0.preset == FBPresets.warning }).map({ $0.message })
    }
    
    /// An array of error messages displayed in the message bar.
    public var errors: [String] {
        return messages.filter({ $0.preset == FBPresets.error }).map({ $0.message })
    }
    
    /// Total number of messages shown.
    public var total: Int {
        return messages.count
    }
    
    /// Indicates whether the message is visible
    public var visible = false
    
    var messages = [FBLoafMockMessage]()
}

/// Collection of animation effects use for hiding the notification bar.
struct FBLoafAnimationsHide {
    /**
     
     Animation that rotates the bar around X axis in perspective with spring effect.
     
     - parameter view: View supplied for animation.
     - parameter completed: A closure to be called after animation completes.
     
     */
    static func rotate(_ view: UIView,
                       duration: TimeInterval?,
                       locationTop: Bool,
                       completed: @escaping FBLoafAnimationCompleted) {
        FBLoafAnimations.doRotate(duration,
                                  showView: false,
                                  view: view,
                                  completed: completed)
    }
    
    /**
     
     Animation that swipes the bar from to the left with fade-in effect.
     
     - parameter view: View supplied for animation.
     - parameter completed: A closure to be called after animation completes.
     
     */
    static func slideLeft(_ view: UIView,
                          duration: TimeInterval?,
                          locationTop: Bool,
                          completed: @escaping FBLoafAnimationCompleted) {
        FBLoafAnimations.doSlide(duration, right: false, showView: false, view: view, completed: completed)
    }
    
    /**
     
     Animation that swipes the bar to the right with fade-out effect.
     
     - parameter view: View supplied for animation.
     - parameter completed: A closure to be called after animation completes.
     
     */
    static func slideRight(_ view: UIView,
                           duration: TimeInterval?,
                           locationTop: Bool,
                           completed: @escaping FBLoafAnimationCompleted) {
        
        FBLoafAnimations.doSlide(duration, right: true, showView: false, view: view, completed: completed)
    }
    
    /**
     
     Animation that fades the bar out.
     
     - parameter view: View supplied for animation.
     - parameter completed: A closure to be called after animation completes.
     
     */
    static func fade(_ view: UIView,
                     duration: TimeInterval?,
                     locationTop: Bool,
                     completed: @escaping FBLoafAnimationCompleted) {
        
        FBLoafAnimations.doFade(duration, showView: false, view: view, completed: completed)
    }
    
    /**
     
     Animation that slides the bar vertically out of view.
     
     - parameter view: View supplied for animation.
     - parameter completed: A closure to be called after animation completes.
     
     */
    static func slideVertically(_ view: UIView,
                                duration: TimeInterval?,
                                locationTop: Bool,
                                completed: @escaping FBLoafAnimationCompleted) {
        
        FBLoafAnimations.doSlideVertically(duration,
                                           showView: false,
                                           view: view,
                                           locationTop: locationTop, completed: completed)
    }
}

/// Collection of animation effects use for showing and hiding the notification bar.
public enum FBLoafAnimations: String {
    /// Animation that fades the bar in/out.
    case fade = "Fade"
    
    /// Used for showing notification without animation.
    case noAnimation = "No animation"
    
    /// Animation that rotates the bar around X axis in perspective with spring effect.
    case rotate = "Rotate"
    
    /// Animation that swipes the bar to/from the left with fade effect.
    case slideLeft = "Slide left"
    
    /// Animation that swipes the bar to/from the right with fade effect.
    case slideRight = "Slide right"
    
    /// Animation that slides the bar in/out vertically.
    case slideVertically = "Slide vertically"
    
    /**
     
     Get animation function that can be used for showing notification bar.
     
     - returns: Animation function.
     
     */
    public var show: FBLoafAnimation {
        switch self {
        case .fade:
            return FBLoafAnimationsShow.fade
            
        case .noAnimation:
            return FBLoafAnimations.doNoAnimation
            
        case .rotate:
            return FBLoafAnimationsShow.rotate
            
        case .slideLeft:
            return FBLoafAnimationsShow.slideLeft
            
        case .slideRight:
            return FBLoafAnimationsShow.slideRight
            
        case .slideVertically:
            return FBLoafAnimationsShow.slideVertically
        }
    }
    
    /**
     
     Get animation function that can be used for hiding notification bar.
     
     - returns: Animation function.
     
     */
    public var hide: FBLoafAnimation {
        switch self {
        case .fade:
            return FBLoafAnimationsHide.fade
            
        case .noAnimation:
            return FBLoafAnimations.doNoAnimation
            
        case .rotate:
            return FBLoafAnimationsHide.rotate
            
        case .slideLeft:
            return FBLoafAnimationsHide.slideLeft
            
        case .slideRight:
            return FBLoafAnimationsHide.slideRight
            
        case .slideVertically:
            return FBLoafAnimationsHide.slideVertically
        }
    }
    
    /**
     
     A empty animator which is used when no animation is supplied.
     It simply calls the completion closure.
     
     - parameter view: View supplied for animation.
     - parameter completed: A closure to be called after animation completes.
     
     */
    static func doNoAnimation(_ view: UIView,
                              duration: TimeInterval?,
                              locationTop: Bool,
                              completed: FBLoafAnimationCompleted) {
        completed()
    }
    
    /// Helper function for fading the view in and out.
    static func doFade(_ duration: TimeInterval?,
                       showView: Bool,
                       view: UIView,
                       completed: @escaping FBLoafAnimationCompleted) {
        
        let actualDuration = duration ?? 0.5
        let startAlpha: CGFloat = showView ? 0 : 1
        let endAlpha: CGFloat = showView ? 1 : 0
        view.alpha = startAlpha
        UIView.animate(withDuration: actualDuration,
                       animations: {
                        view.alpha = endAlpha
        },
                       completion: { _ in
                        completed()
        }
        )
    }
    
    /// Helper function for sliding the view vertically
    static func doSlideVertically(_ duration: TimeInterval?,
                                  showView: Bool,
                                  view: UIView,
                                  locationTop: Bool,
                                  completed: @escaping FBLoafAnimationCompleted) {
        
        let actualDuration = duration ?? 0.5
        view.layoutIfNeeded()
        
        var distance: CGFloat = 0
        
        if locationTop {
            distance = view.frame.height + view.frame.origin.y
        } else {
            distance = UIScreen.main.bounds.height - view.frame.origin.y
        }
        
        let transform = CGAffineTransform(translationX: 0, y: locationTop ? -distance : distance)
        
        let start: CGAffineTransform = showView ? transform : CGAffineTransform.identity
        let end: CGAffineTransform = showView ? CGAffineTransform.identity : transform
        
        view.transform = start
        
        UIView.animate(withDuration: actualDuration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: {
                        view.transform = end
        },
                       completion: { _ in
                        completed()
        }
        )
    }
    
    static weak var timer: MoaTimer?
    
    /// Animation that rotates the bar around X axis in perspective with spring effect.
    static func doRotate(_ duration: TimeInterval?, showView: Bool, view: UIView, completed: @escaping FBLoafAnimationCompleted) {
        
        let actualDuration = duration ?? 2.0
        let start: Double = showView ? Double(Double.pi / 2) : 0
        let end: Double = showView ? 0 : Double(Double.pi / 2)
        let damping = showView ? 0.85 : 3
        
        let myCALayer = view.layer
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/200.0
        myCALayer.transform = CATransform3DRotate(transform, CGFloat(end), 1, 0, 0)
        myCALayer.zPosition = 300
        
        SpringAnimationCALayer.animate(myCALayer,
                                       keypath: "transform.rotation.x",
                                       duration: actualDuration,
                                       usingSpringWithDamping: damping,
                                       initialSpringVelocity: 1,
                                       fromValue: start,
                                       toValue: end,
                                       onFinished: showView ? completed : nil)
        
        // Hide the bar prematurely for better looks
        timer?.cancel()
        if !showView {
            timer = MoaTimer.runAfter(0.3) { _ in
                completed()
            }
        }
    }
    
    /// Animation that swipes the bar to the right with fade-out effect.
    static func doSlide(_ duration: TimeInterval?,
                        right: Bool,
                        showView: Bool,
                        view: UIView,
                        completed: @escaping FBLoafAnimationCompleted) {
        
        let actualDuration = duration ?? 0.4
        let distance = UIScreen.main.bounds.width
        let transform = CGAffineTransform(translationX: right ? distance : -distance, y: 0)
        
        let start: CGAffineTransform = showView ? transform : CGAffineTransform.identity
        let end: CGAffineTransform = showView ? CGAffineTransform.identity : transform
        
        let alphaStart: CGFloat = showView ? 0.2 : 1
        let alphaEnd: CGFloat = showView ? 1 : 0.2
        
        view.transform = start
        view.alpha = alphaStart
        
        UIView.animate(withDuration: actualDuration,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        view.transform = end
                        view.alpha = alphaEnd
        },
                       completion: { _ in
                        completed()
        }
        )
    }
}

/// Collection of animation effects use for showing the notification bar.
struct FBLoafAnimationsShow {
    /**
     
     Animation that rotates the bar around X axis in perspective with spring effect.
     
     - parameter view: View supplied for animation.
     - parameter completed: A closure to be called after animation completes.
     
     */
    static func rotate(_ view: UIView,
                       duration: TimeInterval?,
                       locationTop: Bool,
                       completed: @escaping FBLoafAnimationCompleted) {
        
        FBLoafAnimations.doRotate(duration, showView: true, view: view, completed: completed)
    }
    
    /**
     
     Animation that swipes the bar from the left with fade-in effect.
     
     - parameter view: View supplied for animation.
     - parameter completed: A closure to be called after animation completes.
     
     */
    static func slideLeft(_ view: UIView,
                          duration: TimeInterval?,
                          locationTop: Bool,
                          completed: @escaping FBLoafAnimationCompleted) {
        FBLoafAnimations.doSlide(duration, right: false, showView: true, view: view, completed: completed)
    }
    
    /**
     
     Animation that swipes the bar from the right with fade-in effect.
     
     - parameter view: View supplied for animation.
     - parameter completed: A closure to be called after animation completes.
     
     */
    static func slideRight(_ view: UIView,
                           duration: TimeInterval?,
                           locationTop: Bool,
                           completed: @escaping FBLoafAnimationCompleted) {
        FBLoafAnimations.doSlide(duration, right: true, showView: true, view: view, completed: completed)
    }
    
    /**
     
     Animation that fades the bar in.
     
     - parameter view: View supplied for animation.
     - parameter completed: A closure to be called after animation completes.
     
     */
    static func fade(_ view: UIView,
                     duration: TimeInterval?,
                     locationTop: Bool,
                     completed: @escaping FBLoafAnimationCompleted) {
        FBLoafAnimations.doFade(duration, showView: true, view: view, completed: completed)
    }
    
    /**
     
     Animation that slides the bar in/out vertically.
     
     - parameter view: View supplied for animation.
     - parameter completed: A closure to be called after animation completes.
     
     */
    static func slideVertically(_ view: UIView,
                                duration: TimeInterval?,
                                locationTop: Bool,
                                completed: @escaping FBLoafAnimationCompleted) {
        FBLoafAnimations.doSlideVertically(duration,
                                           showView: true,
                                           view: view,
                                           locationTop: locationTop,
                                           completed: completed)
    }
}

/// A closure that is called for animation of the bar when it is being shown or hidden.
public typealias FBLoafAnimation = (UIView,
    _ duration: TimeInterval?,
    _ locationTop: Bool,
    _ completed: @escaping FBLoafAnimationCompleted) -> Void

/// A closure that is called by the animator when animation has finished.
public typealias FBLoafAnimationCompleted = () -> Void

/**
 Creates a timer that executes code after delay.
 
 Usage
 
 var timer: MoaTimer.runAfter?
 ...
 
 func myFunc() {
 timer = MoaTimer.runAfter(0.010) { timer in
 ... code to run
 }
 }
 
 Canceling the timer
 
 Timer is Canceling automatically when it is deallocated. You can also cancel it manually:
 
 let timer = MoaTimer.runAfter(0.010) { timer in ... }
 timer.cancel()
 
 */
final class MoaTimer: NSObject {
    private let repeats: Bool
    private var timer: Timer?
    private var callback: ((MoaTimer) -> Void )?
    private init(interval: TimeInterval, repeats: Bool = false, callback: @escaping (MoaTimer) -> Void ) {
        self.repeats = repeats
        super.init()
        self.callback = callback
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(MoaTimer.timerFired(_:)),
                                     userInfo: nil, repeats: repeats)
    }
    
    /// Timer is cancelled automatically when it is deallocated.
    deinit {
        cancel()
    }
    
    /**
     
     Cancels the timer and prevents it from firing in the future.
     Note that timer is cancelled automatically whe it is deallocated.
     */
    func cancel() {
        timer?.invalidate()
        timer = nil
    }
    
    /**
     
     Runs the closure after specified time interval.
     - parameter interval: Time interval in milliseconds.
     :repeats: repeats When true, the code is run repeatedly.
     - returns: callback A closure to be run by the timer.
     
     */
    @discardableResult
    class func runAfter(_ interval: TimeInterval,
                        repeats: Bool = false,
                        callback: @escaping (MoaTimer) -> Void ) -> MoaTimer {
        
        return MoaTimer(interval: interval, repeats: repeats, callback: callback)
    }
    
    @objc func timerFired(_ timer: Timer) {
        self.callback?(self)
        if !repeats { cancel() }
    }
}

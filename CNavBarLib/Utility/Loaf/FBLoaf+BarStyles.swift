//
//  Created by TCS.
//  Copyright © 2020 TCS. All rights reserved.
//  

import Foundation
import UIKit

/// Defines styles related to the bar view in general.
public class FBLoafBarStyle {
    
    /// The parent style is used to get the property value if the object is missing one.
    var parent: FBLoafBarStyle?
    
    init(parentStyle: FBLoafBarStyle? = nil) {
        self.parent = parentStyle
    }
    
    /// Clears the styles for all properties for this style object. The styles will be taken from parent and default properties.
    public func clear() {
        _animationHide = nil
        _animationHideDuration = nil
        _animationShow = nil
        _animationShowDuration = nil
        _backgroundColor = nil
        _borderColor = nil
        _borderWidth = nil
        _cornerRadius = nil
        _debugMode = nil
        _hideAfterDelaySeconds = nil
        _hideOnTap = nil
        _locationTop = nil
        _marginToSuperview = nil
        _onTap = nil
    }
    
    // -----------------------------
    
    private var _animationHide: FBLoafAnimation?
    
    /// Specify a function for animating the bar when it is hidden.
    public var animationHide: FBLoafAnimation {
        get {
            return (_animationHide ?? parent?.animationHide) ?? FBLoafBarDefaultStyles.animationHide
        }
        
        set {
            _animationHide = newValue
        }
    }
    
    // ---------------------------
    
    private var _animationHideDuration: TimeInterval?
    
    /// Duration of hide animation. When nil it uses default duration for selected animation function.
    public var animationHideDuration: TimeInterval? {
        get {
            return (_animationHideDuration ?? parent?.animationHideDuration) ??
                FBLoafBarDefaultStyles.animationHideDuration
        }
        
        set {
            _animationHideDuration = newValue
        }
    }
    
    // ---------------------------
    
    private var _animationShow: FBLoafAnimation?
    
    /// Specify a function for animating the bar when it is shown.
    public var animationShow: FBLoafAnimation {
        get {
            return (_animationShow ?? parent?.animationShow) ?? FBLoafBarDefaultStyles.animationShow
        }
        
        set {
            _animationShow = newValue
        }
    }
    
    // ---------------------------
    
    private var _animationShowDuration: TimeInterval?
    
    /// Duration of show animation. When nil it uses default duration for selected animation function.
    public var animationShowDuration: TimeInterval? {
        get {
            return (_animationShowDuration ?? parent?.animationShowDuration) ??
                FBLoafBarDefaultStyles.animationShowDuration
        }
        
        set {
            _animationShowDuration = newValue
        }
    }
    
    // ---------------------------
    
    private var _backgroundColor: UIColor?
    
    /// Background color of the bar.
    public var backgroundColor: UIColor? {
        get {
            return _backgroundColor ?? parent?.backgroundColor ?? FBLoafBarDefaultStyles.backgroundColor
        }
        
        set {
            _backgroundColor = newValue
        }
    }
    
    // -----------------------------
    
    private var _borderColor: UIColor?
    
    /// Color of the bar's border.
    public var borderColor: UIColor? {
        get {
            return _borderColor ?? parent?.borderColor ?? FBLoafBarDefaultStyles.borderColor
        }
        
        set {
            _borderColor = newValue
        }
    }
    
    // -----------------------------
    
    private var _borderWidth: CGFloat?
    
    /// Border width of the bar.
    public var borderWidth: CGFloat {
        get {
            return _borderWidth ?? parent?.borderWidth ?? FBLoafBarDefaultStyles.borderWidth
        }
        
        set {
            _borderWidth = newValue
        }
    }
    
    // -----------------------------
    
    private var _cornerRadius: CGFloat?
    
    /// Corner radius of the bar view.
    public var cornerRadius: CGFloat {
        get {
            return _cornerRadius ?? parent?.cornerRadius ?? FBLoafBarDefaultStyles.cornerRadius
        }
        
        set {
            _cornerRadius = newValue
        }
    }
    
    // -----------------------------
    
    private var _debugMode: Bool?
    
    /// When true it highlights the view background for spotting layout issues.
    public var debugMode: Bool {
        get {
            return _debugMode ?? parent?.debugMode ?? FBLoafBarDefaultStyles.debugMode
        }
        
        set {
            _debugMode = newValue
        }
    }
    
    // ---------------------------
    
    private var _hideAfterDelaySeconds: TimeInterval?
    
    /**
     
     Hides the bar automatically after the specified number of seconds.
     If nil the bar is kept on screen.
     
     */
    public var hideAfterDelaySeconds: TimeInterval {
        get {
            return _hideAfterDelaySeconds ?? parent?.hideAfterDelaySeconds ??
                FBLoafBarDefaultStyles.hideAfterDelaySeconds
        }
        
        set {
            _hideAfterDelaySeconds = newValue
        }
    }
    private var _hideOnTap: Bool?
    
    /// When true the bar is hidden when user taps on it.
    public var hideOnTap: Bool {
        get {
            return _hideOnTap ?? parent?.hideOnTap ??
                FBLoafBarDefaultStyles.hideOnTap
        }
        
        set {
            _hideOnTap = newValue
        }
    }
    
    private var _locationTop: Bool?
    
    /// Position of the bar. When true the bar is shown on top of the screen.
    public var locationTop: Bool {
        get {
            return _locationTop ?? parent?.locationTop ?? FBLoafBarDefaultStyles.locationTop
        }
        
        set {
            _locationTop = newValue
        }
    }
    
    private var _marginToSuperview: CGSize?
    
    /// Margin between the bar edge and its superview.
    public var marginToSuperview: CGSize {
        get {
            return _marginToSuperview ?? parent?.marginToSuperview ??
                FBLoafBarDefaultStyles.marginToSuperview
        }
        
        set {
            _marginToSuperview = newValue
        }
    }
    private var _onTap: FBLoafBarOnTap?
    
    /// Supply a function that will be called when user taps the bar.
    public var onTap: FBLoafBarOnTap? {
        get {
            return _onTap ?? parent?.onTap ?? FBLoafBarDefaultStyles.onTap
        }
        
        set {
            _onTap = newValue
        }
    }
}
/**
 
 Defines the style presets for the bar.
 
 */
public enum FBPresets {
    /// A styling preset used for indicating successful completion of an operation. Usually styled with green color.
    case success
    
    /// A styling preset for showing information messages, neutral in color.
    case info
    
    /// A styling preset for showing warning messages. Can be styled with yellow/orange colors.
    case warning
    
    /// A styling preset for showing critical error messages. Usually styled with red color.
    case error
    
    /// The preset is used by default for the bar if it's not set by the user.
    static let defaultPreset = FBPresets.success
    
    /// The preset cache.
    private static var styles = [FBPresets: FBLoafStyle]()
    
    /// Returns the style for the preset
    public var style: FBLoafStyle {
        var style = FBPresets.styles[self]
        
        if style == nil {
            style = FBPresets.makeStyle(forPreset: self)
            FBPresets.styles[self] = style
        }
        
        precondition(style != nil, "Failed to create style")
        
        return style ?? FBLoafStyle()
    }
    
    /// Reset alls preset styles to their initial states.
    public static func resetAll() {
        styles = [:]
    }
    
    /// Reset the preset style to its initial state.
    public func reset() {
        FBPresets.styles.removeValue(forKey: self)
    }
    
    private static func makeStyle(forPreset preset: FBPresets) -> FBLoafStyle {
        
        let style = FBLoafStyle()
        
        switch preset {
        case .success:
            style.bar.backgroundColor = FBLoafColor.fromHexString("#00CC03C9")
            
        case .info:
            style.bar.backgroundColor = FBLoafColor.fromHexString("#0057FF96")
            
        case .warning:
            style.bar.backgroundColor = FBLoafColor.fromHexString("#CEC411DD")
            
        case .error:
            style.bar.backgroundColor = FBLoafColor.fromHexString("#FF0B0BCC")
        }
        
        return style
    }
}

/**
 
 Default styles for the bar button.
 Default styles are used when individual element styles are not set.
 
 */
public struct FBLoafButtonDefaultStyles {
    
    /// Revert the property values to their defaults
    public static func resetToDefaults() {
        accessibilityLabel = _accessibilityLabel
        hideOnTap = _hideOnTap
        horizontalMarginToBar = _horizontalMarginToBar
        icon = _icon
        image = _image
        onTap = _onTap
        size = _size
        tintColor = _tintColor
    }
    
    private static let _accessibilityLabel: String? = nil
    
    /**
     
     This text is spoken by the device when it is in accessibility mode. It is recommended to always set the accessibility label for your button. The text can be a short localized description of the button function, for example: "Close the message", "Reload" etc.
     
     */
    public static var accessibilityLabel = _accessibilityLabel
    private static let _hideOnTap = false
    
    /// When true it hides the bar when the button is tapped.
    public static var hideOnTap = _hideOnTap
    private static let _horizontalMarginToBar: CGFloat = 10
    
    /// Margin between the bar edge and the button
    public static var horizontalMarginToBar = _horizontalMarginToBar
    private static let _icon: FBLoafIcons? = nil
    
    /// When set it shows one of the default FBLoaf icons. Use `image` property to supply a custom image. The color of the image can be changed with `tintColor` property.
    public static var icon = _icon
    private static let _image: UIImage? = nil
    /// Custom image for the button. One can also use the `icon` property to show one of the default FBLoaf icons. The color of the image can be changed with `tintColor` property.
    public static var image = _image
    private static let _onTap: FBButtonOnTap? = nil
    /// Supply a function that will be called when user taps the button.
    public static var onTap = _onTap
    private static let _size = CGSize(width: 25, height: 25)
    /// Size of the button.
    public static var size = _size
    private static let _tintColor: UIColor? = nil
    /// Replaces the color of the image or icon. The original colors are used when nil.
    public static var tintColor = _tintColor
}

/// Defines styles for the bar button.
public class FBButtonStyle {
    
    /// The parent style is used to get the property value if the object is missing one.
    var parent: FBButtonStyle?
    
    init(parentStyle: FBButtonStyle? = nil) {
        self.parent = parentStyle
    }
    
    /// Clears the styles for all properties for this style object. The styles will be taken from parent and default properties.
    public func clear() {
        _accessibilityLabel = nil
        _hideOnTap = nil
        _horizontalMarginToBar = nil
        _icon = nil
        _image = nil
        _onTap = nil
        _size = nil
        _tintColor = nil
    }
    
    // -----------------------------
    
    private var _accessibilityLabel: String?
    
    /**
     
     This text is spoken by the device when it is in accessibility mode. It is recommended to always set the accessibility label for your button. The text can be a short localized description of the button function, for example: "Close the message", "Reload" etc.
     
     */
    public var accessibilityLabel: String? {
        get {
            return _accessibilityLabel ?? parent?.accessibilityLabel ?? FBLoafButtonDefaultStyles.accessibilityLabel
        }
        
        set {
            _accessibilityLabel = newValue
        }
    }
    
    // -----------------------------
    
    private var _hideOnTap: Bool?
    
    /// When true it hides the bar when the button is tapped.
    public var hideOnTap: Bool {
        get {
            return _hideOnTap ?? parent?.hideOnTap ?? FBLoafButtonDefaultStyles.hideOnTap
        }
        
        set {
            _hideOnTap = newValue
        }
    }
    private var _horizontalMarginToBar: CGFloat?
    
    /// Horizontal margin between the bar edge and the button.
    public var horizontalMarginToBar: CGFloat {
        get {
            return _horizontalMarginToBar ?? parent?.horizontalMarginToBar ??
                FBLoafButtonDefaultStyles.horizontalMarginToBar
        }
        
        set {
            _horizontalMarginToBar = newValue
        }
    }
    private var _icon: FBLoafIcons?
    
    /// When set it shows one of the default FBLoaf icons. Use `image` property to supply a custom image. The color of the image can be changed with `tintColor` property.
    public var icon: FBLoafIcons? {
        get {
            return _icon ?? parent?.icon ?? FBLoafButtonDefaultStyles.icon
        }
        
        set {
            _icon = newValue
        }
    }
    
    private var _image: UIImage?
    
    /// Custom image for the button. One can also use the `icon` property to show one of the default FBLoaf icons. The color of the image can be changed with `tintColor` property.
    public var image: UIImage? {
        get {
            return _image ?? parent?.image ?? FBLoafButtonDefaultStyles.image
        }
        
        set {
            _image = newValue
        }
    }
    private var _onTap: FBButtonOnTap?
    /// Supply a function that will be called when user taps the button.
    public var onTap: FBButtonOnTap? {
        get {
            return _onTap ?? parent?.onTap ?? FBLoafButtonDefaultStyles.onTap
        }
        
        set {
            _onTap = newValue
        }
    }
    private var _size: CGSize?
    
    /// Size of the button.
    public var size: CGSize {
        get {
            return _size ?? parent?.size ?? FBLoafButtonDefaultStyles.size
        }
        
        set {
            _size = newValue
        }
    }
    private var _tintColor: UIColor?
    
    /// Replaces the color of the image or icon. The original colors are used when nil.
    public var tintColor: UIColor? {
        get {
            return _tintColor ?? parent?.tintColor ?? FBLoafButtonDefaultStyles.tintColor
        }
        
        set {
            _tintColor = newValue
        }
    }
}
/// Combines various styles for the toolbar element.
public class FBLoafStyle {
    
    /// The parent style is used to get the property value if the object is missing one.
    var parent: FBLoafStyle? {
        didSet {
            changeParent()
        }
    }
    
    init(parentStyle: FBLoafStyle? = nil) {
        self.parent = parentStyle
    }
    
    private func changeParent() {
        bar.parent = parent?.bar
        label.parent = parent?.label
        leftButton.parent = parent?.leftButton
        rightButton.parent = parent?.rightButton
    }
    
    /**
     
     Reverts all the default styles to their initial values. Usually used in setUp() function in the unit tests.
     
     */
    public static func resetDefaultStyles() {
        FBLoafBarDefaultStyles.resetToDefaults()
        FBLoafLabelDefaultStyles.resetToDefaults()
        FBLoafButtonDefaultStyles.resetToDefaults()
    }
    
    /// Clears the styles for all properties for this style object. The styles will be taken from parent and default properties.
    public func clear() {
        bar.clear()
        label.clear()
        leftButton.clear()
        rightButton.clear()
    }
    
    /**
     
     Styles for the bar view.
     
     */
    public lazy var bar: FBLoafBarStyle = self.initBarStyle()
    
    private func initBarStyle() -> FBLoafBarStyle {
        return FBLoafBarStyle(parentStyle: parent?.bar)
    }
    
    /**
     
     Styles for the text label.
     
     */
    public lazy var label: FBLoafLabelStyle = self.initLabelStyle()
    
    private func initLabelStyle() -> FBLoafLabelStyle {
        return FBLoafLabelStyle(parentStyle: parent?.label)
    }
    
    /**
     
     Styles for the left button.
     
     */
    public lazy var leftButton: FBButtonStyle = self.initLeftButtonStyle()
    
    private func initLeftButtonStyle() -> FBButtonStyle {
        return FBButtonStyle(parentStyle: parent?.leftButton)
    }
    
    /**
     
     Styles for the right button.
     
     */
    public lazy var rightButton: FBButtonStyle = self.initRightButtonStyle()
    
    private func initRightButtonStyle() -> FBButtonStyle {
        return FBButtonStyle(parentStyle: parent?.rightButton)
    }
}

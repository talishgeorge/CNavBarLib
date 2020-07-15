import UIKit

/// Defines styles related to the text label.
public class FBLoafLabelStyle {
    
    /// The parent style is used to get the property value if the object is missing one.
    var parent: FBLoafLabelStyle?
    
    init(parentStyle: FBLoafLabelStyle? = nil) {
        self.parent = parentStyle
    }
    
    /// Clears the styles for all properties for this style object. The styles will be taken from parent and default properties.
    public func clear() {
        _color = nil
        _font = nil
        _horizontalMargin = nil
        _numberOfLines = nil
        _shadowColor = nil
        _shadowOffset = nil
    }
    
    // -----------------------------
    
    private var _color: UIColor?
    
    /// Color of the label text.
    public var color: UIColor {
        get {
            return _color ?? parent?.color ?? FBLoafLabelDefaultStyles.color
        }
        
        set {
            _color = newValue
        }
    }
    
    // -----------------------------
    
    private var _font: UIFont?
    
    /// Color of the label text.
    public var font: UIFont {
        get {
            return _font ?? parent?.font ?? FBLoafLabelDefaultStyles.font
        }
        
        set {
            _font = newValue
        }
    }
    
    // -----------------------------
    
    private var _horizontalMargin: CGFloat?
    
    /// Margin between the bar/button edge and the label.
    public var horizontalMargin: CGFloat {
        get {
            return _horizontalMargin ?? parent?.horizontalMargin ??
                FBLoafLabelDefaultStyles.horizontalMargin
        }
        
        set {
            _horizontalMargin = newValue
        }
    }
    
    // -----------------------------
    
    private var _numberOfLines: Int?
    
    /// The maximum number of lines in the label.
    public var numberOfLines: Int {
        get {
            return _numberOfLines ?? parent?.numberOfLines ??
                FBLoafLabelDefaultStyles.numberOfLines
        }
        
        set {
            _numberOfLines = newValue
        }
    }
    
    // -----------------------------
    
    private var _shadowColor: UIColor?
    
    /// Color of text shadow.
    public var shadowColor: UIColor? {
        get {
            return _shadowColor ?? parent?.shadowColor ?? FBLoafLabelDefaultStyles.shadowColor
        }
        
        set {
            _shadowColor = newValue
        }
    }
    
    private var _shadowOffset: CGSize?
    
    /// Text shadow offset.
    public var shadowOffset: CGSize {
        get {
            return _shadowOffset ?? parent?.shadowOffset ?? FBLoafLabelDefaultStyles.shadowOffset
        }
        
        set {
            _shadowOffset = newValue
        }
    }
}

/**
 
 Default styles for the text label.
 Default styles are used when individual element styles are not set.
 
 */
public struct FBLoafLabelDefaultStyles {
    
    /// Revert the property values to their defaults
    public static func resetToDefaults() {
        color = _color
        font = _font
        horizontalMargin = _horizontalMargin
        numberOfLines = _numberOfLines
        shadowColor = _shadowColor
        shadowOffset = _shadowOffset
    }
    private static let _color = UIColor.white
    /// Color of the label text.
    public static var color = _color
    
    private static let _font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
    
    /// Font of the label text.
    public static var font = _font
    
    private static let _horizontalMargin: CGFloat = 10
    
    /// Margin between the bar/button edge and the label.
    public static var horizontalMargin = _horizontalMargin
    
    private static let _numberOfLines: Int = 3
    
    /// The maximum number of lines in the label.
    public static var numberOfLines = _numberOfLines
    
    private static let _shadowColor: UIColor? = nil
    
    /// Color of text shadow.
    public static var shadowColor = _shadowColor
    
    private static let _shadowOffset = CGSize(width: 0, height: 1)
    
    /// Text shadow offset.
    public static var shadowOffset = _shadowOffset
}

/**
 
 Default styles for the bar view.
 Default styles are used when individual element styles are not set.
 
 */
public struct FBLoafBarDefaultStyles {
    
    /// Revert the property values to their defaults
    public static func resetToDefaults() {
        animationHide = _animationHide
        animationHideDuration = _animationHideDuration
        animationShow = _animationShow
        animationShowDuration = _animationShowDuration
        backgroundColor = _backgroundColor
        borderColor = _borderColor
        borderWidth = _borderWidth
        cornerRadius = _cornerRadius
        debugMode = _debugMode
        hideAfterDelaySeconds = _hideAfterDelaySeconds
        hideOnTap = _hideOnTap
        locationTop = _locationTop
        marginToSuperview = _marginToSuperview
        onTap = _onTap
    }
    
    private static let _animationHide: FBLoafAnimation = FBLoafAnimationsHide.rotate
    
    /// Specify a function for animating the bar when it is hidden.
    public static var animationHide: FBLoafAnimation = _animationHide
    
    private static let _animationHideDuration: TimeInterval? = nil
    
    /// Duration of hide animation. When nil it uses default duration for selected animation function.
    public static var animationHideDuration: TimeInterval? = _animationHideDuration
    
    private static let _animationShow: FBLoafAnimation = FBLoafAnimationsShow.rotate
    
    /// Specify a function for animating the bar when it is shown.
    public static var animationShow: FBLoafAnimation = _animationShow
    
    private static let _animationShowDuration: TimeInterval? = nil
    
    /// Duration of show animation. When nil it uses default duration for selected animation function.
    public static var animationShowDuration: TimeInterval? = _animationShowDuration
    
    private static let _backgroundColor: UIColor? = nil
    
    /// Background color of the bar.
    public static var backgroundColor = _backgroundColor
    
    private static let _borderColor: UIColor? = nil
    
    /// Color of the bar's border.
    public static var borderColor = _borderColor
    
    private static let _borderWidth: CGFloat  = 1 / UIScreen.main.scale
    
    /// Border width of the bar.
    public static var borderWidth = _borderWidth
    
    private static let _cornerRadius: CGFloat = 20
    
    /// Corner radius of the bar view.
    public static var cornerRadius = _cornerRadius
    
    private static let _debugMode = false
    
    /// When true it highlights the view background for spotting layout issues.
    public static var debugMode = _debugMode
    
    private static let _hideAfterDelaySeconds: TimeInterval = 0
    
    /**
     
     Hides the bar automatically after the specified number of seconds.
     The bar is kept on screen indefinitely if the value is zero.
     
     */
    public static var hideAfterDelaySeconds = _hideAfterDelaySeconds
    
    private static let _hideOnTap = false
    
    /// When true the bar is hidden when user taps on it.
    public static var hideOnTap = _hideOnTap
    
    private static let _locationTop = true
    
    /// Position of the bar. When true the bar is shown on top of the screen.
    public static var locationTop = _locationTop
    
    private static let _marginToSuperview = CGSize(width: 5, height: 5)
    
    /// Margin between the bar edge and its superview.
    public static var marginToSuperview = _marginToSuperview
    private static let _onTap: FBLoafBarOnTap? = nil
    /// Supply a function that will be called when user taps the bar.
    public static var onTap = _onTap
    
}

class SBToolbar: UIView {
    var anchor: NSLayoutYAxisAnchor?
    var style: FBLoafStyle
    weak var buttonViewDelegate: FBButtonViewDelegate?
    private var didCallHide = false
    
    convenience init(witStyle style: FBLoafStyle) {
        self.init(frame: CGRect())
        
        self.style = style
    }
    
    override init(frame: CGRect) {
        style = FBLoafStyle()
        
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(inSuperview parentView: UIView, withMessage message: String) {
        
        if superview != nil { return } // already being shown
        
        parentView.addSubview(self)
        applyStyle()
        layoutBarInSuperview()
        
        let buttons = createButtons()
        
        createLabel(message, withButtons: buttons)
        
        style.bar.animationShow(self, style.bar.animationShowDuration, style.bar.locationTop, {})
    }
    
    func hide(_ onAnimationCompleted: @escaping () -> Void ) {
        // Respond only to the first hide() call
        if didCallHide { return }
        didCallHide = true
        
        style.bar.animationHide(self, style.bar.animationHideDuration,
                                style.bar.locationTop, { [weak self] in
                                    
                                    self?.removeFromSuperview()
                                    onAnimationCompleted()
        })
    }
    
    // MARK: - Label
    
    private func createLabel(_ message: String, withButtons buttons: [UIView]) {
        let label = UILabel()
        
        label.font = style.label.font
        label.text = message
        label.textColor = style.label.color
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = style.label.numberOfLines
        
        if style.bar.debugMode {
            label.backgroundColor = UIColor.red
        }
        
        if let shadowColor = style.label.shadowColor {
            label.shadowColor = shadowColor
            label.shadowOffset = style.label.shadowOffset
        }
        
        addSubview(label)
        layoutLabel(label, withButtons: buttons)
    }
    
    private func layoutLabel(_ label: UILabel, withButtons buttons: [UIView]) {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Stretch the label vertically
        TegAutolayoutConstraints.fillParent(label,
                                            parentView: self,
                                            margin: style.label.horizontalMargin,
                                            vertically: true)
        
        if buttons.isEmpty {
            if let superview = superview {
                // If there are no buttons - stretch the label to the entire width of the view
                TegAutolayoutConstraints.fillParent(label,
                                                    parentView: superview,
                                                    margin: style.label.horizontalMargin,
                                                    vertically: false)
            }
        } else {
            layoutLabelWithButtons(label, withButtons: buttons)
        }
    }
    
    private func layoutLabelWithButtons(_ label: UILabel, withButtons buttons: [UIView]) {
        if buttons.count != 2 { return }
        
        let views = [buttons[0], label, buttons[1]]
        
        if let superview = superview {
            TegAutolayoutConstraints.viewsNextToEachOther(views,
                                                          constraintContainer: superview,
                                                          margin: style.label.horizontalMargin,
                                                          vertically: false)
        }
    }
    
    // MARK: - Buttons
    
    private func createButtons() -> [FBButtonView] {
        precondition(buttonViewDelegate != nil, "Button view delegate can not be nil")
        let buttonStyles = [style.leftButton, style.rightButton]
        
        let buttonViews = FBButtonView.createMany(buttonStyles)
        
        for (index, button) in buttonViews.enumerated() {
            addSubview(button)
            button.delegate = buttonViewDelegate
            button.doLayout(onLeftSide: index == 0)
            
            if style.bar.debugMode {
                button.backgroundColor = UIColor.yellow
            }
        }
        
        return buttonViews
    }
    
    // MARK: - Style the bar
    
    private func applyStyle() {
        backgroundColor = style.bar.backgroundColor
        layer.cornerRadius = style.bar.cornerRadius
        layer.masksToBounds = true
        
        if let borderColor = style.bar.borderColor, style.bar.borderWidth > 0 {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = style.bar.borderWidth
        }
    }
    
    private func layoutBarInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superview = superview {
            // Stretch the toobar horizontally to the width if its superview
            TegAutolayoutConstraints.fillParent(self,
                                                parentView: superview,
                                                margin: style.bar.marginToSuperview.width,
                                                vertically: false)
            var verticalMargin = style.bar.marginToSuperview.height
            verticalMargin = style.bar.locationTop ? -verticalMargin : verticalMargin
            var verticalConstraints = [NSLayoutConstraint]()
            
            if let anchor = anchor {
                // Align the top/bottom edge of the toolbar with the top/bottom anchor
                // (a tab bar, for example)
                verticalConstraints = TegAutolayoutConstraints.alignVerticallyToAnchor(self,
                                                                                       onTop: style.bar.locationTop,
                                                                                       anchor: anchor,
                                                                                       margin: verticalMargin)
            } else {
                // Align the top/bottom of the toolbar with the top/bottom of its superview
                verticalConstraints = TegAutolayoutConstraints.alignSameAttributes(superview,
                                                                                   toItem: self,
                                                                                   constraintContainer: superview,
                                                                                   attribute: style.bar.locationTop ? NSLayoutConstraint.Attribute.top : NSLayoutConstraint.Attribute.bottom,
                                                                                   margin: verticalMargin)
            }
            setupKeyboardEvader(verticalConstraints)
        }
    }
    
    // Moves the message bar from under the keyboard
    private func setupKeyboardEvader(_ verticalConstraints: [NSLayoutConstraint]) {
        if let bottomConstraint = verticalConstraints.first,
            let superview = superview,
            !style.bar.locationTop {
            FBLoafKeyboardListener.underKeyboardLayoutConstraint.setup(bottomConstraint, view: superview)
        }
    }
}

/**
 
 Collection of icons included with FBLoaf library.
 
 */
public enum FBLoafIcons: String {
    /// Icon for closing the bar.
    case close = "Close"
    
    /// Icon for reloading.
    case reload = "Reload"
}
private var sabAssociationKey: UInt8 = 0

/**
 
 UIView extension for showing a notification widget.
 
 let view = UIView()
 view.FBLoaf.show("Hello World!")
 
 */
public extension UIView {
    /**
     
     Message bar extension.
     Call `FBLoaf.show`, `FBLoaf.success`, FBLoaf.error` functions to show a notification widget in the view.
     
     let view = UIView()
     view.FBLoaf.show("Hello World!")
     
     */
    var popup: FBLoafInterface {
        get {
            if let value = objc_getAssociatedObject(self, &sabAssociationKey) as? FBLoafInterface {
                return value
            } else {
                let popup = FBLoaf(superview: self)
                
                objc_setAssociatedObject(self,
                                         &sabAssociationKey, popup,
                                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                
                return popup
            }
        }
        
        set {
            objc_setAssociatedObject(self, &sabAssociationKey,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

/**
 
 Start listening for keyboard events. Used for moving the message bar from under the keyboard when the bar is shown at the bottom of the screen.
 
 */
struct FBLoafKeyboardListener {
    static let underKeyboardLayoutConstraint = UnderKeyboardLayoutConstraint()
    
    static func startListening() {
        // Just access the static property to make it initialize itself lazily if it hasn't been already.
        underKeyboardLayoutConstraint.isAccessibilityElement = false
    }
}
/**
 
 Helper function to make sure bounds are big enought to be used as touch target.
 The function is used in pointInside(point: CGPoint, withEvent event: UIEvent?) of UIImageView.
 
 */
struct FBTouchTarget {
    static func optimize(_ bounds: CGRect) -> CGRect {
        let recommendedHitSize: CGFloat = 44
        
        var hitWidthIncrease: CGFloat = recommendedHitSize - bounds.width
        var hitHeightIncrease: CGFloat = recommendedHitSize - bounds.height
        
        if hitWidthIncrease < 0 { hitWidthIncrease = 0 }
        if hitHeightIncrease < 0 { hitHeightIncrease = 0 }
        
        let extendedBounds: CGRect = bounds.insetBy(dx: -hitWidthIncrease / 2,
                                                    dy: -hitHeightIncrease / 2)
        return extendedBounds
    }
}

/// A closure that is called when a bar is tapped
public typealias FBLoafBarOnTap = () -> Void

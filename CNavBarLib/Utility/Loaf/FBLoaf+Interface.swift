//
//  Created by TCS.
//  Copyright © 2020 TCS. All rights reserved.
//  

import Foundation
import UIKit

class FBButtonView: UIImageView {
    private let style: FBButtonStyle
    weak var delegate: FBButtonViewDelegate?
    var onTap: OnTap?
    
    init(style: FBButtonStyle) {
        self.style = style
        
        super.init(frame: CGRect())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Create button views for given button styles.
    static func createMany(_ styles: [FBButtonStyle]) -> [FBButtonView] {
        
        if !haveButtons(styles) { return [] }
        
        return styles.map { style in
            let view = FBButtonView(style: style)
            view.setup()
            return view
        }
    }
    
    static func haveButtons(_ styles: [FBButtonStyle]) -> Bool {
        let hasImages = !styles.filter({ $0.image != nil }).isEmpty
        let hasIcons = !styles.filter({ $0.icon != nil }).isEmpty
        
        return hasImages || hasIcons
    }
    
    func doLayout(onLeftSide: Bool) {
        precondition(delegate != nil, "Button view delegate can not be nil")
        translatesAutoresizingMaskIntoConstraints = false
        
        // Set button's size
        TegAutolayoutConstraints.width(self, value: style.size.width)
        TegAutolayoutConstraints.height(self, value: style.size.height)
        
        if let superview = superview {
            let alignAttribute = onLeftSide ? NSLayoutConstraint.Attribute.left : NSLayoutConstraint.Attribute.right
            
            let marginHorizontal = onLeftSide ? style.horizontalMarginToBar : -style.horizontalMarginToBar
            
            // Align the button to the left/right of the view
            TegAutolayoutConstraints.alignSameAttributes(self,
                                                         toItem: superview,
                                                         constraintContainer: superview,
                                                         attribute: alignAttribute,
                                                         margin: marginHorizontal)
            
            // Center the button verticaly
            TegAutolayoutConstraints.centerY(self, viewTwo: superview, constraintContainer: superview)
        }
    }
    
    func setup() {
        if let image = FBButtonView.image(style) { applyStyle(image) }
        setupTap()
    }
    
    /// Increase the hitsize of the image view if it's less than 44px for easier tapping.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let oprimizedBounds = FBTouchTarget.optimize(bounds)
        return oprimizedBounds.contains(point)
    }
    
    /// Returns the image supplied by user or create one from the icon
    class func image(_ style: FBButtonStyle) -> UIImage? {
        if style.image != nil {
            return style.image
        }
        
        if let icon = style.icon {
            let bundle = Bundle(for: self)
            let imageName = icon.rawValue
            
            return UIImage(named: imageName, in: bundle, compatibleWith: nil)
        }
        
        return nil
    }
    
    private func applyStyle(_ imageIn: UIImage) {
        var imageToShow = imageIn
        if let tintColorToShow = style.tintColor {
            // Replace image colors with the specified tint color
            imageToShow = imageToShow.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            tintColor = tintColorToShow
        }
        
        layer.minificationFilter = CALayerContentsFilter.trilinear // make the image crisp
        image = imageToShow
        contentMode = UIView.ContentMode.scaleAspectFit
        
        // Make button accessible
        if let accessibilityLabelToShow = style.accessibilityLabel {
            isAccessibilityElement = true
            accessibilityLabel = accessibilityLabelToShow
            accessibilityTraits = UIAccessibilityTraits.button
        }
    }
    
    private func setupTap() {
        onTap = OnTap(view: self, gesture: UITapGestureRecognizer()) { [weak self] in
            self?.didTap()
        }
    }
    
    private func didTap() {
        self.delegate?.buttonDelegateDidTap(self.style)
        style.onTap?()
    }
}

protocol FBButtonViewDelegate: class {
    func buttonDelegateDidTap(_ buttonStyle: FBButtonStyle)
}

/// A closure that is called when a bar button is tapped
public typealias FBButtonOnTap = () -> Void

/**
 
 Coordinates the process of showing and hiding of the message bar.
 
 The instance is created automatically in the `FBLoaf` property of any UIView instance.
 It is not expected to be instantiated manually anywhere except unit tests.
 
 For example:
 
 let view = UIView()
 view.FBLoaf.info("Horses are blue?")
 
 */
public protocol FBLoafInterface: class {
    /**
     Specify optional anchor for positioning the bar view.
     This can be an anchor from the safe area.
     */
    var topAnchor: NSLayoutYAxisAnchor? { get set }
    
    /**
     Specify optional anchor for positioning the bar view.
     This can be an anchor from the safe area.
     */
    var bottomAnchor: NSLayoutYAxisAnchor? { get set }
    
    /// Specify optional layout guide for positioning the bar view.
    @available(*, deprecated, message: "use topAnchor instead")
    var topLayoutGuide: UILayoutSupport? { get set }
    
    /// Specify optional layout guide for positioning the bar view.
    @available(*, deprecated, message: "use bottomAnchor instead")
    var bottomLayoutGuide: UILayoutSupport? { get set }
    
    /// Defines styles for the bar.
    var style: FBLoafStyle { get set }
    
    /// Changes the style preset for the bar widget.
    var preset: FBPresets { get set }
    
    /**
     
     Shows the message bar with *.success* preset. It can be used to indicate successful completion of an operation.
     
     - parameter message: The text message to be shown.
     
     */
    func success(_ message: String)
    
    /**
     
     Shows the message bar with *.Info* preset. It can be used for showing information messages that have neutral emotional value.
     
     - parameter message: The text message to be shown.
     
     */
    func info(_ message: String)
    
    /**
     
     Shows the message bar with *.warning* preset. It can be used for for showing warning messages.
     
     - parameter message: The text message to be shown.
     
     */
    func warning(_ message: String)
    
    /**
     
     Shows the message bar with *.warning* preset. It can be used for showing critical error messages
     
     - parameter message: The text message to be shown.
     
     */
    func error(_ message: String)
    
    /**
     
     Shows the message bar. Set `preset` property to change the appearance of the message bar, or use the shortcut methods: `success`, `info`, `warning` and `error`.
     
     - parameter message: The text message to be shown.
     
     */
    func show(_ message: String)
    
    /// Hide the message bar if it's currently shown.
    func hide()
}

/**
 
 Main class that coordinates the process of showing and hiding of the message bar.
 
 Instance of this class is created automatically in the `FBLoaf` property of any UIView instance.
 It is not expected to be instantiated manually anywhere except unit tests.
 
 For example:
 
 let view = UIView()
 view.FBLoaf.info("Horses are blue?")
 
 */
final class FBLoaf: FBLoafInterface, FBButtonViewDelegate {
    private weak var superview: UIView!
    private var hideTimer: MoaTimer?
    
    // Gesture handler that hides the bar when it is tapped
    var onTap: OnTap?
    
    /**
     Specify optional anchor for positioning the bar view.
     This can be an anchor from the safe area.
     */
    var topAnchor: NSLayoutYAxisAnchor?
    
    /**
     Specify optional anchor for positioning the bar view.
     This can be an anchor from the safe area.
     */
    var bottomAnchor: NSLayoutYAxisAnchor?
    
    /// Specify optional layout guide for positioning the bar view. Deprecated, use bottomAnchor instead.
    @available(*, deprecated, message: "use topAnchor instead")
    var topLayoutGuide: UILayoutSupport? {
        set { self.topAnchor = newValue?.bottomAnchor }
        get { return nil }
    }
    
    /// Specify optional layout guide for positioning the bar view. Deprecated, use bottomAnchor instead.
    @available(*, deprecated, message: "use bottomAnchor instead")
    var bottomLayoutGuide: UILayoutSupport? {
        set { self.bottomAnchor = newValue?.topAnchor }
        get { return nil }
    }
    
    /// Defines styles for the bar.
    var style = FBLoafStyle(parentStyle: FBPresets.defaultPreset.style)
    
    /// Creates an instance of FBLoaf class
    init(superview: UIView) {
        self.superview = superview
        
        FBLoafKeyboardListener.startListening()
    }
    
    /// Changes the style preset for the bar widget.
    var preset: FBPresets = FBPresets.defaultPreset {
        didSet {
            if preset != oldValue {
                style.parent = preset.style
            }
        }
    }
    
    /**
     
     Shows the message bar with *.success* preset. It can be used to indicate successful completion of an operation.
     
     - parameter message: The text message to be shown.
     
     */
    func success(_ message: String) {
        preset = .success
        show(message)
    }
    
    /**
     
     Shows the message bar with *.Info* preset. It can be used for showing information messages that have neutral emotional value.
     
     - parameter message: The text message to be shown.
     
     */
    func info(_ message: String) {
        preset = .info
        show(message)
    }
    
    /**
     
     Shows the message bar with *.warning* preset. It can be used for for showing warning messages.
     
     - parameter message: The text message to be shown.
     
     */
    func warning(_ message: String) {
        preset = .warning
        show(message)
    }
    
    /**
     
     Shows the message bar with *.warning* preset. It can be used for showing critical error messages
     
     - parameter message: The text message to be shown.
     
     */
    func error(_ message: String) {
        preset = .error
        show(message)
    }
    
    /**
     
     Shows the message bar. Set `preset` property to change the appearance of the message bar, or use the shortcut methods: `success`, `info`, `warning` and `error`.
     
     - parameter message: The text message to be shown.
     
     */
    func show(_ message: String) {
        removeExistingBars()
        setupHideTimer()
        
        let bar = SBToolbar(witStyle: style)
        setupHideOnTap(bar)
        bar.anchor = style.bar.locationTop ? topAnchor: bottomAnchor
        bar.buttonViewDelegate = self
        bar.show(inSuperview: superview, withMessage: message)
    }
    
    /// Hide the message bar if it's currently shown.
    func hide() {
        hideTimer?.cancel()
        
        toolbar?.hide({})
    }
    
    func listenForKeyboard() {
        
    }
    
    private var toolbar: SBToolbar? {
        superview.subviews.filter { $0 is SBToolbar }.map { ($0 as? SBToolbar)! }.first
    }
    
    private func removeExistingBars() {
        for view in superview.subviews {
            if let existingToolbar = view as? SBToolbar {
                existingToolbar.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Hiding after delay
    
    private func setupHideTimer() {
        hideTimer?.cancel()
        
        if style.bar.hideAfterDelaySeconds > 0 {
            hideTimer = MoaTimer.runAfter(style.bar.hideAfterDelaySeconds) { [weak self] _ in
                
                DispatchQueue.main.async {
                    self?.hide()
                }
            }
        }
    }
    
    // MARK: - Reacting to tap
    
    private func setupHideOnTap(_ toolbar: UIView) {
        onTap = OnTap(view: toolbar, gesture: UITapGestureRecognizer()) { [weak self] in
            self?.didTapTheBar()
        }
    }
    
    /// The bar has been tapped
    private func didTapTheBar() {
        style.bar.onTap?()
        
        if style.bar.hideOnTap {
            hide()
        }
    }
    
    // MARK: - FBLoafButtonViewDelegate
    
    func buttonDelegateDidTap(_ buttonStyle: FBButtonStyle) {
        if buttonStyle.hideOnTap {
            hide()
        }
    }
}
/**
 
 Contains information about the message that was displayed in message bar. Used in unit tests.
 
 */
struct FBLoafMockMessage {
    let preset: FBPresets
    let message: String
}

public class FBLoafMock: FBLoafInterface {
    /// This property is used in unit tests to verify which messages were displayed in the message bar.
    public var results = FBLoafMockResults()
    
    /**
     Specify optional anchor for positioning the bar view.
     This can be an anchor from the safe area.
     */
    public var topAnchor: NSLayoutYAxisAnchor?
    
    /**
     Specify optional anchor for positioning the bar view.
     This can be an anchor from the safe area.
     */
    public var bottomAnchor: NSLayoutYAxisAnchor?
    
    /// Specify optional layout guide for positioning the bar view. Deprecated, use bottomAnchor instead.
    @available(*, deprecated, message: "Use topAnchor instead")
    public var topLayoutGuide: UILayoutSupport? {
        set { self.topAnchor = newValue?.bottomAnchor }
        get { return nil }
    }
    
    /// Specify optional layout guide for positioning the bar view. Deprecated, use bottomAnchor instead.
    @available(*, deprecated, message: "Use bottomAnchor instead")
    public var bottomLayoutGuide: UILayoutSupport? {
        set { self.topAnchor = newValue?.bottomAnchor }
        get { return nil }
    }
    
    /// Defines styles for the bar.
    public var style = FBLoafStyle(parentStyle: FBPresets.defaultPreset.style)
    
    /// Creates an instance of FBLoafMock class
    public init() { }
    
    /// Changes the style preset for the bar widget.
    public var preset: FBPresets = FBPresets.defaultPreset {
        didSet {
            if preset != oldValue {
                style.parent = preset.style
            }
        }
    }
    
    /**
     
     Shows the message bar with *.success* preset. It can be used to indicate successful completion of an operation.
     
     - parameter message: The text message to be shown.
     
     */
    public func success(_ message: String) {
        preset = .success
        show(message)
    }
    
    /**
     
     Shows the message bar with *.Info* preset. It can be used for showing information messages that have neutral emotional value.
     
     - parameter message: The text message to be shown.
     
     */
    public func info(_ message: String) {
        preset = .info
        show(message)
    }
    
    /**
     
     Shows the message bar with *.warning* preset. It can be used for for showing warning messages.
     
     - parameter message: The text message to be shown.
     
     */
    public func warning(_ message: String) {
        preset = .warning
        show(message)
    }
    
    /**
     
     Shows the message bar with *.warning* preset. It can be used for showing critical error messages
     
     - parameter message: The text message to be shown.
     
     */
    public func error(_ message: String) {
        preset = .error
        show(message)
    }
    
    /**
     
     Shows the message bar. Set `preset` property to change the appearance of the message bar, or use the shortcut methods: `success`, `info`, `warning` and `error`.
     
     - parameter message: The text message to be shown.
     
     */
    public func show(_ message: String) {
        let mockMessage = FBLoafMockMessage(preset: preset, message: message)
        results.messages.append(mockMessage)
        results.visible = true
    }
    
    /// Hide the message bar if it's currently shown.
    public func hide() {
        results.visible = false
    }
}

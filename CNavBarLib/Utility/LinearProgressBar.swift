import Foundation
import UIKit

class LinearProgressBar: UIView {

    // MARK: - Private Stored Properties

    private var progressBarIndicator: UIView!
    var isAnimationRunning = false
    var intialWidth: CGFloat = 10

    // MARK: - Public Stored Properties

    public var yPos: CGFloat = 0
    public var backgroundProgressBarColor: UIColor = Color.background
    public var progressBarColor: UIColor = Color.progressBar
    public var heightForLinearBar: CGFloat = Size.height
    public var widthForLinearBar: CGFloat = Size.width

    /// Init
    public init() {
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 20), size: CGSize(width: UIScreen.main.bounds.width,
                                                                            height: 0)))
        self.progressBarIndicator = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                                                         size: CGSize(width: 0, height: heightForLinearBar)))
    }

    /// Required Init
    /// - Parameter aDecoder: NSCoder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        if widthForLinearBar == 0 {
            widthForLinearBar = UIScreen.main.bounds.width
        }
        setupViewForLandscapeMode()
        setupViewForPortraitMode()
    }

    // MARK: - Public Methods

    /// Start Animating
    public func startAnimating() {
        self.heightForLinearBar = NavBarConstants.heightForLinearBar
        self.backgroundProgressBarColor = NavBarConstants.backgroundProgressBarColor
        self.progressBarColor = NavBarConstants.progressBarColor
        self.yPos = AppConstants.yPos
        self.configureColors()
        self.show()
        if !isAnimationRunning {
            self.isAnimationRunning = true
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar,
                                    height: self.heightForLinearBar)
            }, completion: { _ in
                self.addSubview(self.progressBarIndicator)
                self.configureAnimation()
            })
        }
    }

    /// Stop Animation
    public func stopAnimation() {
        self.isAnimationRunning = false
        UIView.animate(withDuration: 0.5, animations: {
            self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar, height: 0)
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar, height: 0)
        })
    }
}

private extension LinearProgressBar {

    struct Color {
        static let background: UIColor = UIColor(red: 0.73, green: 0.87, blue: 0.98, alpha: 1.0)
        static let progressBar: UIColor = UIColor(red: 0.12, green: 0.53, blue: 0.90, alpha: 1.0)
    }

    struct Size {
        static let height: CGFloat = 5
        static let width: CGFloat = 0
    }

    // MARK: - Private Methods

    /// Setup View For Landscape
    private func setupViewForLandscapeMode() {
        if UIDevice.current.orientation.isLandscape {
            self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: yPos
            ), size: CGSize(width: widthForLinearBar, height: self.frame.height))
        }
    }

    /// Setup View for Portrait mode
    private func setupViewForPortraitMode() {
        if UIDevice.current.orientation.isPortrait {
            self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: yPos),
                                size: CGSize(width: widthForLinearBar, height: self.frame.height))
        }
    }

    /// Show
    private func show() {
        guard self.superview == nil else {
            return
        }
        /// Find current top viewcontroller
        if let topController = UIApplication.shared.keyWindow?.rootViewController?.getTopViewController() {
            let superView: UIView = topController.view
            superView.addSubview(self)
        }
    }

    /// Configure Colors
    private func configureColors() {
        self.backgroundColor = self.backgroundProgressBarColor
        self.progressBarIndicator.backgroundColor = self.progressBarColor
        self.layoutIfNeeded()
    }

    /// Configure Animation
    private func configureAnimation() {
        guard let superview = self.superview else {
            stopAnimation()
            return
        }
        self.progressBarIndicator.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0,
                                                                                           height: heightForLinearBar))
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: 0, y: 0,
                                                         width: self.widthForLinearBar*0.7,
                                                         height: self.heightForLinearBar)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: superview.frame.width, y: 0, width: 0,
                                                         height: self.heightForLinearBar)
            })
        }, completion: { _ in
            if self.isAnimationRunning {
                self.configureAnimation()
            }
        })
    }
}

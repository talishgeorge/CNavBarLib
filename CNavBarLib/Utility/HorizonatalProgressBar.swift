import UIKit

class HorizontalProgressBar: UIView {
    // MARK: - Public Stored Properties
    /// To generate dymanic Chunks under progressbar
    internal var arrProgressChunks = [UIView]()
    /// Progressbar Tint color
    public var progressTintColor: UIColor!
    /// Progressbar track color
    public var trackTintColor: UIColor!
    var hideWhenStopped: Bool!
    var isAnimating: Bool!
    /// Progressbar Chunk width
    public var kChunkWdith = 50.0
    /// Number of Chunks to animate
    public var noOfChunks = 3
    /// Type of progress bar (Determine or Indetermine)
    public var loadingStyle: ProgressType?
    public var yPos: CGFloat = 0
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.trackTintColor = UIColor.darkGray
        self.progressTintColor = UIColor.white
        self.hideWhenStopped = true
        self.isHidden = true
        self.isAnimating = false
        if loadingStyle == nil {
            loadingStyle = .indetermine
        }
    }
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // MARK: - Private Methods
    /// Set tint color for track animation
    private func trackTintColor (tintColor: UIColor) {
        trackTintColor = tintColor
    }
    /// Set background color for track
    private func progressTintColor (tintColor: UIColor) {
        progressTintColor = tintColor
    }
    /// To begin animation
    private func configureDetermineMode() {
        setupChunckAnimation()
    }
    private func configureFillMode() {
        setupChunckAnimation()
    }
    private func configureIndetermineMode() {
        setupChunckAnimaitionForIndetermine()
    }
    private func setupChunckAnimation() {
        noOfChunks = 1
        let chunk = UIView.init(frame: CGRect(x: Double(-kChunkWdith),
                                              y: Double(0.0), width: Double(kChunkWdith),
                                              height: Double(self.frame.size.height)))
        arrProgressChunks.append(chunk)
        var delay: TimeInterval = 0.0
        for chunk in arrProgressChunks {
            chunk.backgroundColor = self.progressTintColor
            self.addSubview(chunk)
            delay += 0.25
            self.doChunkAnimation(chunk: chunk, delay: (delay))
        }
    }
    private func setupChunckAnimaitionForIndetermine() {
        for _ in 0..<noOfChunks {
            let chunk = UIView.init(frame: CGRect(x: Double(-kChunkWdith),
                                                  y: Double(0.0), width: Double(kChunkWdith),
                                                  height: Double(self.frame.size.height)))
            arrProgressChunks.append(chunk)
        }
        var delay: TimeInterval = 0.0
        for chunk in arrProgressChunks {
            chunk.backgroundColor = self.progressTintColor
            self.addSubview(chunk)
            delay += 0.25
            self.doChunkAnimation(chunk: chunk, delay: (delay))
        }
    }
    private func strartAnimationForDetermineMode(_ delay: TimeInterval, _ chunk: UIView) {
        _ =  [UIView .animate(withDuration: 1.00, delay: delay, options: .autoreverse, animations: {
            var chunkFrame = chunk.frame
            chunkFrame.origin.x = self.frame.size.width - CGFloat(self.kChunkWdith)
            chunk.frame = chunkFrame
        }, completion: { (finished) in
            var chunkFrame = chunk.frame
            chunkFrame.origin.x = CGFloat(-self.kChunkWdith)
            chunk.frame = chunkFrame
            if finished {
                self.doChunkAnimation(chunk: chunk, delay: 0.4)
            }
        })]
    }
    private func startAnimationForFillMode(_ delay: TimeInterval, _ chunk: UIView) {
        _ =  [UIView .animate(withDuration: 3.00, delay: delay, options: .curveEaseInOut, animations: {
            var chunkFrame = chunk.frame
            chunkFrame.size.width = self.frame.size.width + CGFloat(self.kChunkWdith)
            chunk.frame = chunkFrame
        }, completion: { (finished) in
            var chunkFrame = chunk.frame
            chunkFrame.size.width = CGFloat(self.kChunkWdith)
            chunk.frame = chunkFrame
            if finished {
                self.doChunkAnimation(chunk: chunk, delay: 0.1)
            }
        })]
    }
    private func startAnimaitonForIndetermineMode(_ delay: TimeInterval, _ chunk: UIView) {
        _ =  [UIView .animate(withDuration: 1.00, delay: delay, options: .curveEaseInOut, animations: {
            var chunkFrame = chunk.frame
            chunkFrame.origin.x = self.frame.size.width
            chunk.frame = chunkFrame
        }, completion: { (finished) in
            var chunkFrame = chunk.frame
            chunkFrame.origin.x = CGFloat(-self.kChunkWdith)
            chunk.frame = chunkFrame
            if finished {
                self.doChunkAnimation(chunk: chunk, delay: 0.4)
            }
        })]
    }
    /// Chunk animation logic
    private func doChunkAnimation (chunk: UIView, delay: TimeInterval) {
        switch loadingStyle {
        case .determine?:
            strartAnimationForDetermineMode(delay, chunk)
        case .fill?:
            startAnimationForFillMode(delay, chunk)
        case .indetermine?:
            startAnimaitonForIndetermineMode(delay, chunk)
        default:
            break
        }
    }
    // MARK: - Public Methods
    public func startAnimating() {
        self.noOfChunks = 1
        self.progressTintColor = NavBarConstants.progressBarColor
        self.trackTintColor = NavBarConstants.backgroundProgressBarColor
        self.loadingStyle = NavBarConstants.animaitonType
        if isAnimating {
            return
        } else {
            isAnimating = true
            self.isHidden = false
            arrProgressChunks.removeAll()
            switch loadingStyle {
            case .determine?:
                configureDetermineMode()
            case .fill?:
                self.backgroundColor = trackTintColor
                configureFillMode()
            case .indetermine? :
                configureIndetermineMode()
            case .none:
                break
            }
        }
    }
    /// To stop animation
    public func stopAnimating() {
        if !isAnimating {
            return
        } else {
            self.isHidden = self.hideWhenStopped
            for  view: UIView in arrProgressChunks {
                view.removeFromSuperview()
            }
            self.arrProgressChunks.removeAll()
        }
    }
}

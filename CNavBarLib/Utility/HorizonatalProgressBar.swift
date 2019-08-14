import UIKit

class HorizontalProgressBar: UIView {
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
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /// Set tint color for track animation
    func trackTintColor (tintColor: UIColor) {
        trackTintColor = tintColor
    }
    /// Set background color for track
    func progressTintColor (tintColor: UIColor) {
        progressTintColor = tintColor
    }
    /// To begin animation
    fileprivate func configureDetermineMode() {
        noOfChunks = 1
        let chunk = UIView.init(frame: CGRect(x: Double(-kChunkWdith),
                                              y: Double(0.0), width: Double(kChunkWdith),
                                              height: Double(self.frame.size.height)))
        arrProgressChunks.append(chunk)
        var delay: TimeInterval = 0.0
        for chunk in arrProgressChunks {
            chunk.backgroundColor = self.progressTintColor
            self.addSubview(chunk)
            delay +=  0.25
            self.doChunkAnimation(chunk: chunk, delay: (delay))
        }
    }
    fileprivate func configureFillMode() {
        self.backgroundColor = trackTintColor
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
    fileprivate func configureIndetermineMode() {
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
    public func startAnimating() {
        self.noOfChunks = 1
        self.progressTintColor = NavBarConstants.progressBarColor
        self.trackTintColor = NavBarConstants.backgroundProgressBarColor
        self.loadingStyle = .fill
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
    /// Chunk animation logic
    func doChunkAnimation (chunk: UIView, delay: TimeInterval) {
        switch loadingStyle {
        case .determine?:
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
        case .fill?:
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
        case .indetermine?:
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
        default:
            break
        }
    }
}

extension HorizontalProgressBar {
    public enum ProgressType: Int {
        case determine = 11
        case indetermine = 22
        case fill = 33
    }
}

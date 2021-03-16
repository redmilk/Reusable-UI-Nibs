//
//  HeartLevelProgress.swift
//  ClaweeUI
//
//  Created by Danyl Timofeyev on 14.03.2021.
//

import UIKit

fileprivate let progressAnimationDuration: TimeInterval = 1.0

@IBDesignable final class HeartLevelProgress: UIView {
    
    struct State {
        let progress: CGFloat
        var heartsCount: Int
    }
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var progressBar: ClaweeProgressBar!
    @IBOutlet private weak var heartCounterLabel: GradientButtonLabel!
    @IBOutlet private weak var heartImageView: UIImageView!
    
    @IBInspectable private var heartLabelText: String = "99" { didSet { self.configureView() } }
    @IBInspectable private var heartLabelTextColor: UIColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.999872148, alpha: 1) { didSet { self.configureView() } }
    @IBInspectable private var heartLabelTextOutlineColor: UIColor = #colorLiteral(red: 0.002456023358, green: 0.1475411057, blue: 0.1803093255, alpha: 1) { didSet { self.configureView() } }
    @IBInspectable private var heartLabelTextOutlineWidth: CGFloat = 1.0 { didSet { self.configureView() } }
    @IBInspectable private var progressBackgroundImageName: String = "heartBar" { didSet { self.configureView() } }
    @IBInspectable private var progressFillImageName: String = "fill" { didSet { self.configureView() } }
    
    private var currentState: State!
    
    public func setInitialState(with state: State) {
        /// for no animated setting of initial state
        currentState = state
        heartCounterLabel.text = state.heartsCount.description
        progressBar.set(progres: state.progress, text: nil, animationDuration: 0.0)
    }
    
    public func updateHeartProgress(with newHeartProgressState: State) {
        /// must have initial state, for comparing level and progress diff
        let currentHeartLevel = currentState.heartsCount
        let newProgress = newHeartProgressState.progress
        let newHeartLevel = newHeartProgressState.heartsCount
        let levelDifference = newHeartLevel - currentHeartLevel
        currentState = newHeartProgressState

        /// if new level is higher than current and more than one
        if levelDifference >= 1 {
            progressBar.set(progres: 1.0, text: nil, animationDuration: progressAnimationDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + progressAnimationDuration) {
                self.progressBar.set(progres: 0.0, text: nil, animationDuration: 0.0)
                self.incrementHeartLevel(to: currentHeartLevel + levelDifference, isAnimateHeartLevel: true)
                self.progressBar.set(progres: newProgress, text: nil, animationDuration: progressAnimationDuration)
            }
        /// if new level is equal to current, just update progress
        } else {
            progressBar.set(progres: newProgress, text: nil, animationDuration: progressAnimationDuration)
        }
    }

    private func incrementHeartLevel(to level: Int, isAnimateHeartLevel: Bool) {
        progressBar.set(progres: 0, text: nil, animationDuration: 0.0)
        currentState.heartsCount = level
        heartCounterLabel.text = currentState.heartsCount.description
        if isAnimateHeartLevel {
            animateNewHeartValue()
        }
    }
    
    private func animateNewHeartValue() {
        heartCounterLabel.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        heartImageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       animations: {
                        self.heartCounterLabel.transform = .identity
                        self.heartImageView.transform = .identity
                       },
                       completion: nil)
    }
    
    private func configureView() {
        heartCounterLabel.text = heartLabelText
        heartCounterLabel.textColor = heartLabelTextColor
        heartCounterLabel.outlineWidth = heartLabelTextOutlineWidth
        heartCounterLabel.outlineColor = heartLabelTextOutlineColor
        let progressBarModel = ClaweeProgressBarEntity(backgroundImage: progressBackgroundImageName,
                                                       fillImage: progressFillImageName,
                                                       text: nil,
                                                       progressFromZeroToOne: 0)
        progressBar.configure(with: progressBarModel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
        configureView()
    }
    
    private func customInit() {
        let bundle = Bundle(for: Self.self)
        bundle.loadNibNamed(String(describing: Self.self), owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}


extension HeartLevelProgress {
    #warning("Heart level progress test demo")
    public func dummyXibDemo() {
        let heartProgressState = State(progress: 0.2, heartsCount: 3)
        setInitialState(with: heartProgressState)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let heartProgressState = State(progress: 0.7, heartsCount: 6)
            self.updateHeartProgress(with: heartProgressState)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            let heartProgressState = State(progress: 0.2, heartsCount: 7)
            self.updateHeartProgress(with: heartProgressState)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            let heartProgressState = State(progress: 0.5, heartsCount: 8)
            self.updateHeartProgress(with: heartProgressState)
        }
    }
}

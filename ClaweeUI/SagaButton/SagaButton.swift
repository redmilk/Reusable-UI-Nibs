//
//  SagaButton.swift
//  ClaweeUI
//
//  Created by Danyl Timofeyev on 11.03.2021.
//

import UIKit

fileprivate let topTitleLabelTextColor: UIColor = #colorLiteral(red: 0.9464059472, green: 0.1310599148, blue: 0.3974712491, alpha: 1)
fileprivate let topTitleLabelTextOutlineColor: UIColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.999872148, alpha: 1)
fileprivate let topTitleLabelTextOutlineWidth: CGFloat = 3.0
fileprivate let topTitleLabelText: String = "PLAY SAGA"
fileprivate let timerLabelTextColor: UIColor = #colorLiteral(red: 0.9510774016, green: 0.9408319592, blue: 0.02456314303, alpha: 1)
fileprivate let heartLabelTextColor: UIColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.999872148, alpha: 1)
fileprivate let heartLabelTextOutlineColor: UIColor = #colorLiteral(red: 0.002456023358, green: 0.1475411057, blue: 0.1803093255, alpha: 1)
fileprivate let heartLabelTextOutlineWidth: CGFloat = 1.0
fileprivate let progressBackgroundImageName: String = "heartBar"
fileprivate let progressFillImageName: String = "fill"

extension SagaButton {
    
    /// States of the xib's components
    enum States {
        case initial(Initial)
        case common(Common)
        case timer(Timer)
        case progress(Progress)
        case heart(Heart)
        
        /// this state we use once during initial setup of this xib
        /// other states we use for separated updates of xib's components during lifecycle
        struct Initial {
            var commonState: Common
            var timerState: Timer
            var progressState: Progress
            var heartState: Heart
        }
        
        struct Common {
            let isTopTitleHidden: Bool = false
        }
        
        struct Timer {
            let timerExpirationDate: Date?
            let onTimerDidExpire: (() -> Void)?
        }
        
        struct Progress {
            let progress: CGFloat
            let progressAnimationDuration: TimeInterval = 1.0
            //let progressBlockAnimationDidFinished: (() -> Void)?
            let text: String? = nil
        }
        
        struct Heart {
            let heartsCount: Int
            let isAnimateHeartValue: Bool = false
        }
    }
}

final class SagaButton: TouchScaleButton {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var topTitleLabel: GradientButtonLabel!
    @IBOutlet private weak var progressContainerView: UIView!
    @IBOutlet private weak var progressBar: ClaweeProgressBar!
    @IBOutlet private weak var timerContainerView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var heartCounterLabel: GradientButtonLabel!
    @IBOutlet private weak var heartImageView: UIImageView!
    
    private var currentState: States.Initial!
    private let timer: ClaweeTimer = ClaweeTimer()
    
    // MARK: - The only public API
    public func updateState(_ state: States) {
        switch state {
        
        /// entry point for xib usage
        case .initial(let initial):
            currentState = initial
            updateCommonState(with: initial.commonState)
            updateTimer(with: initial.timerState)
            updateProgress(with: initial.progressState)
            updateHearts(with: initial.heartState)
            
        /// updates during lifecycle
        case .timer(let timerState): updateTimer(with: timerState)
        case .progress(let progressState): updateProgress(with: progressState)
        case .heart(let heartState): updateHearts(with: heartState)
        case .common(let commonState): updateCommonState(with: commonState)
        }
    }
    
    
    // MARK: - System
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
    
    deinit {
        timer.stopTimer()
    }
}


private extension SagaButton {
    // MARK: - Specific state updates
    
    /// promotion duration timer updates
    private func updateTimer(with timerState: States.Timer) {
        currentState.timerState = timerState
        guard let timerExpirationDate = currentState.timerState.timerExpirationDate,
              let onTimerDidExpire = currentState.timerState.onTimerDidExpire else { return }
        startTimer(expirationDate: timerExpirationDate,
                   timerDidEnd: onTimerDidExpire)
    }
    
    /// progress updates
    private func updateProgress(with progressState: States.Progress) {
        currentState.progressState = progressState
        guard currentState.progressState.progress <= progressState.progress else { return }
        progressBar.set(progres: progressState.progress, text: progressState.text, animationDuration: progressState.progressAnimationDuration)
    }
    
    /// for managing hearts counter and it's animation, it also depends on progress animation duration
    private func updateHearts(with heartState: States.Heart) {
        currentState.heartState = heartState
        /// for waiting progress bar animation, before setting new value to hearts label
        DispatchQueue.main.asyncAfter(deadline: .now() + currentState.progressState.progressAnimationDuration) {
            self.heartCounterLabel.text = heartState.heartsCount.description
            if heartState.isAnimateHeartValue {
                self.animateNewHeartValue()
            }
        }
    }
    
    /// hiding/showing top label with "PLAY SAGA", also for other future flags or properties
    private func updateCommonState(with commonState: States.Common) {
        currentState.commonState = commonState
        topTitleLabel.isHidden = currentState.commonState.isTopTitleHidden
    }
    
    // MARK: - Internal
    private func startTimer(expirationDate: Date, timerDidEnd: (() -> Void)?) {
        timerLabel.text = String.timeStringForExpirationTime(using: expirationDate.timeIntervalSince1970, isShortFormat: false)
        timer.run(tillExpirationDateInMillisecondsSince1970: expirationDate.timeIntervalSince1970 * 1000,
                  timeInterval: 1,
                  shortTimerFormat: false,
                  onTimeChange: { [weak self] text, isExpired in
                    guard isExpired == nil else {
                        self?.timerLabel.text = text
                        timerDidEnd?()
                        return
                    }
                    
                    self?.timerLabel.text = text
                  })
    }
    
    private func configureView() {
        topTitleLabel.fontColor = topTitleLabelTextColor
        topTitleLabel.outlineColor = topTitleLabelTextOutlineColor
        topTitleLabel.outlineWidth = topTitleLabelTextOutlineWidth
        topTitleLabel.text = topTitleLabelText
        timerLabel.textColor = timerLabelTextColor
        heartCounterLabel.outlineWidth = heartLabelTextOutlineWidth
        heartCounterLabel.outlineColor = heartLabelTextOutlineColor
        let progressBarModel = ClaweeProgressBarEntity(backgroundImage: progressBackgroundImageName,
                                                       fillImage: progressFillImageName,
                                                       text: nil,
                                                       progressFromZeroToOne: 0)
        progressBar.configure(with: progressBarModel)
    }
    
    private func customInit() {
        Bundle.main.loadNibNamed(String(describing: Self.self), owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
}

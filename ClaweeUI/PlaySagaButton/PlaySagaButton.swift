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
fileprivate let progressAnimationDuration: TimeInterval = 1.0

extension PlaySagaButton {
    
    /// States of the xib's components
    enum State {
        case initial(InitialState)
        case timer(TimerState)
        case heartProgress(HeartProgressState)
    }
    
    /// this state we use once during initial setup of this xib
    /// other states we use for separated updates of xib's components during lifecycle
    struct InitialState {
        var isTopTitleHidden: Bool
        var timerState: TimerState
        var heartProgressState: HeartProgressState
    }
    
    struct TimerState {
        let timerExpirationDate: Date
        let onTimerDidExpire: (() -> Void)?
    }
    
    struct HeartProgressState {
        let progress: CGFloat
        var heartsCount: Int
    }
}

final class PlaySagaButton: TouchScaleButton {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var topTitleLabel: GradientButtonLabel!
    @IBOutlet private weak var progressContainerView: UIView!
    @IBOutlet private weak var progressBar: ClaweeProgressBar!
    @IBOutlet private weak var timerContainerView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var heartCounterLabel: GradientButtonLabel!
    @IBOutlet private weak var heartImageView: UIImageView!
    
    private var currentState: InitialState!
    private let timer: ClaweeTimer = ClaweeTimer()
    
    // MARK: - The only public API
    public func update(with state: State) {
        switch state {
        
        /// entry point for xib usage, here we configure xib's initial state
        case .initial(let initial):
            currentState = initial
            topTitleLabel.isHidden = initial.isTopTitleHidden
            updateTimer(with: initial.timerState)
            updateHeartProgress(with: initial.heartProgressState)

        /// updates during lifecycle
        case .timer(let timerState): updateTimer(with: timerState)
        case .heartProgress(let heartProgressState): updateHeartProgress(with: heartProgressState)
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
    
    #warning("This is for presentation purpose. Delete it later")
    public func dummyCurrentXibDemo() {
        let today: Date = Date()
        let nextDate: Date = Calendar.current.date(byAdding: .day, value: 3, to: today)!
        
        let heartProgressState = PlaySagaButton.HeartProgressState(progress: 0.2, heartsCount: 3)
        let timerState = PlaySagaButton.TimerState(timerExpirationDate: nextDate) {
            Logger.log("Timer time has gone", type: .all)
        }
        
        let initialState = PlaySagaButton.InitialState(isTopTitleHidden: false,
                                                       timerState: timerState,
                                                       heartProgressState: heartProgressState)
        
        self.update(with: PlaySagaButton.State.initial(initialState))
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let heartProgressState = PlaySagaButton.HeartProgressState(progress: 0.7, heartsCount: 6)
            self.update(with: PlaySagaButton.State.heartProgress(heartProgressState))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            let heartProgressState = PlaySagaButton.HeartProgressState(progress: 0.2, heartsCount: 7)
            self.update(with: PlaySagaButton.State.heartProgress(heartProgressState))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            let heartProgressState = PlaySagaButton.HeartProgressState(progress: 0.5, heartsCount: 8)
            self.update(with: PlaySagaButton.State.heartProgress(heartProgressState))
        }
    }
}


private extension PlaySagaButton {
    // MARK: - Specific state updates
    
    /// promotion duration timer updates
    private func updateTimer(with timerState: TimerState) {
        currentState.timerState = timerState
        startTimer(expirationDate: timerState.timerExpirationDate,
                   timerDidEnd: timerState.onTimerDidExpire)
    }
    
    /// heart level and progress updates
    private func updateHeartProgress(with newHeartProgressState: HeartProgressState) {
        let currentHeartLevel = currentState.heartProgressState.heartsCount
        let newProgress = newHeartProgressState.progress
        let newHeartLevel = newHeartProgressState.heartsCount
        let levelDifference = newHeartLevel - currentHeartLevel
        currentState.heartProgressState = newHeartProgressState

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
    
    // MARK: - Internal helpers
    private func incrementHeartLevel(to level: Int, isAnimateHeartLevel: Bool) {
        progressBar.set(progres: 0, text: nil, animationDuration: 0.0)
        currentState.heartProgressState.heartsCount = level
        heartCounterLabel.text = currentState.heartProgressState.heartsCount.description
        if isAnimateHeartLevel {
            animateNewHeartValue()
        }
    }
    
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

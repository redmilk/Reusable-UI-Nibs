//
//  SagaButton.swift
//  ClaweeUI
//
//  Created by Danyl Timofeyev on 11.03.2021.
//

import UIKit

extension PlaySagaButton {
    
    /// States of the xib's components
    enum State {
        case initial(InitialState)
        case timer(TimerState)
        case heartProgress(HeartLevelProgress.State)
    }
    
    /// this state we use once during initial setup of this xib
    /// other states we use for separated updates of xib's components during lifecycle
    struct InitialState {
        var timerState: TimerState
        var heartProgressState: HeartLevelProgress.State
        
        let isTopTitleHidden: Bool
        let buttonAction: (() -> Void)!
    }
    
    struct TimerState {
        let timerExpirationDate: Date
        let onTimerDidExpire: (() -> Void)?
    }
}


@IBDesignable final class PlaySagaButton: TouchScaleButton {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var topTitleLabel: GradientButtonLabel!
    @IBOutlet private weak var timerContainerView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var heartLevelProgress: HeartLevelProgress!
    
    @IBInspectable private var topTitleLabelTextColor: UIColor = #colorLiteral(red: 0.9464059472, green: 0.1310599148, blue: 0.3974712491, alpha: 1)  { didSet { configureView() } }
    @IBInspectable private var topTitleLabelTextOutlineColor: UIColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.999872148, alpha: 1)  { didSet { configureView() } }
    @IBInspectable private var topTitleLabelTextOutlineWidth: CGFloat = 3.0  { didSet { configureView() } }
    @IBInspectable private var topTitleLabelText: String = "PLAY SAGA" { didSet { configureView() } }
    @IBInspectable private var timerLabelTextColor: UIColor = #colorLiteral(red: 0.9510774016, green: 0.9408319592, blue: 0.02456314303, alpha: 1)  { didSet { configureView() } }
    
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
            heartLevelProgress.setInitialState(with: initial.heartProgressState)

        /// updates during lifecycle
        case .timer(let timerState):
            updateTimer(with: timerState)
        case .heartProgress(let heartProgressState):
            heartLevelProgress.updateHeartProgress(with: heartProgressState)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        currentState.buttonAction()
    }
    
    #warning("This is for presentation purpose. Delete it later")
    public func dummyXibDemo(action: @escaping () -> Void) {
        let today: Date = Date()
        let nextDate: Date = Calendar.current.date(byAdding: .day, value: 3, to: today)!
        
        let heartProgressState = HeartLevelProgress.State(progress: 0.2, heartsCount: 3)
        let timerState = PlaySagaButton.TimerState(timerExpirationDate: nextDate) {
            Logger.log("Timer time has gone", type: .all)
        }
                
        let initialState = InitialState(timerState: timerState,
                                        heartProgressState: heartProgressState,
                                        isTopTitleHidden: false,
                                        buttonAction: action)
        
        update(with: PlaySagaButton.State.initial(initialState))
        heartLevelProgress.dummyXibDemo()
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
    
    // MARK: - Internal helpers
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
    }
    
    private func customInit() {
        let bundle = Bundle(for: Self.self)
        bundle.loadNibNamed(String(describing: Self.self), owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}

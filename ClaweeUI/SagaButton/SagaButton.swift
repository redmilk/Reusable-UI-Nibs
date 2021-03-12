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

final class SagaButton: TouchScaleButton {
    
    struct State {
        let progress: CGFloat
        let heartsCount: Int
        let timerExpirationDate: Date
        let onTimerDidExpire: (() -> Void)?
    }

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var topTitleLabel: GradientButtonLabel!
    @IBOutlet private weak var progressContainerView: UIView!
    @IBOutlet private weak var progressBar: ClaweeProgressBar!
    @IBOutlet private weak var timerContainerView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var heartCounterLabel: GradientButtonLabel!
    
    private let timer: ClaweeTimer = ClaweeTimer()
    
    public func configure(with state: SagaButton.State) {
        let progressBarModel = ClaweeProgressBarEntity(backgroundImage: progressBackgroundImageName,
                                            fillImage: progressFillImageName,
                                            text: nil,
                                            progressFromZeroToOne: state.progress)

        startTimer(expirationDate: state.timerExpirationDate,
                   timerDidEnd: state.onTimerDidExpire)
        
        progressBar.configure(with: progressBarModel)
    }
    
    public func setHeartProgressState(with progress: CGFloat, animationDuration: TimeInterval, heartsCount: Int? = nil) {
        progressBar.set(progres: progress, text: nil, animationDuration: animationDuration)
        if let heartsCount = heartsCount {
            /// for waiting progress bar animation, before setting new value to hearts label
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                self.heartCounterLabel.text = heartsCount.description
            }
        }
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
    
    deinit {
        timer.stopTimer()
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
    }
    
    private func customInit() {
        Bundle.main.loadNibNamed(String(describing: Self.self), owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

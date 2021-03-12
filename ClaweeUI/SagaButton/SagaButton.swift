//
//  SagaButton.swift
//  ClaweeUI
//
//  Created by Danyl Timofeyev on 11.03.2021.
//

import UIKit

final class SagaButton: TouchScaleButton {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var progressBar: ClaweeProgressBar!
    
    public func configure(with model: ClaweeProgressBarEntity) {
        progressBar.configure(with: model)
    }
    
    public func setProgress(with progress: CGFloat) {
        progressBar.set(progres: progress, text: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customInit()
    }

    private func customInit() {
        Bundle.main.loadNibNamed(String(describing: Self.self), owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}

//
//  ButtonWithOutlinedLabel.swift
//  Clawee
//
//  Created by Roma Bozhenko on 20.10.2020.
//  Copyright © 2020 Noisy Miner. All rights reserved.
//

import UIKit

class ButtonWithOutlinedLabel: UIButton {
    private var outlinedTitleLabel: GradientButtonLabel = {
        let l = GradientButtonLabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.lineBreakMode = .byClipping
        l.textAlignment = .center
        l.outlineColor = #colorLiteral(red: 0, green: 0.4412737191, blue: 0.07167697698, alpha: 1)
        l.outlineWidth = 2
        return l
        }() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private let imageViewContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setButtonImageView()
        setOutlinedTitleLabelConstraints()
    }
    
    override var isHighlighted: Bool {
        didSet {
            outlinedTitleLabel.transform = isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
            outlinedTitleLabel.outlineColor = isHighlighted ? #colorLiteral(red: 0, green: 0.3511271775, blue: 0.1799696088, alpha: 1) : #colorLiteral(red: 0, green: 0.4412745237, blue: 0.1851399243, alpha: 1)
            outlinedTitleLabel.fontColor = isHighlighted ? #colorLiteral(red: 0.5762143731, green: 0.7855450511, blue: 0.7894429564, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    private func setButtonImageView() {
        addSubview(imageViewContainer)
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        imageViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        guard image(for: .normal) != nil else { return }
        NSLayoutConstraint.activate([
            imageViewContainer.topAnchor.constraint(equalTo: topAnchor),
            imageViewContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageViewContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
        ])
        
        imageView?.trailingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor).isActive = true
    }
    
    private func setOutlinedTitleLabelConstraints() {
        addSubview(outlinedTitleLabel)
        
        if image(for: .normal) == nil {
            outlinedTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            layoutIfNeeded()
        } else {
            outlinedTitleLabel.leadingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            outlinedTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            outlinedTitleLabel.centerYAnchor.constraint(equalTo: titleLabel!.centerYAnchor),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        outlinedTitleLabel.font = titleLabel!.font
        outlinedTitleLabel.text = titleLabel?.text
        titleLabel?.alpha = 0
    }
}

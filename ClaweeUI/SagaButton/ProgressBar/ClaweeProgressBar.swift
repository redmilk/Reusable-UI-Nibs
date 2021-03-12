//
//  ClaweeProgressBar.swift
//  Clawee
//
//  Created by Roman Bozhenko on 19.01.2021.
//  Copyright © 2021 Noisy Miner. All rights reserved.
//

import UIKit 

struct ClaweeProgressBarEntity {
    let backgroundImage: String
    let fillImage: String
    let text: String?
    let progressFromZeroToOne: CGFloat
    let animationDuration: TimeInterval = 0
}

//In order for the ClaweeProgressBar to work (look) correctly, use the assets with NO PADDINGS only - ask your designer to help


final class ClaweeProgressBar: NibView {
    @IBOutlet private weak var fillImagePlaceholder: UIView!
    @IBOutlet private weak var background: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    
    private var fillImage: UIImageView?
    private var widthMultiplier: CGFloat = 0
    
    private var progressAnimationDuration: TimeInterval = 0
    private var fillImagePlaceholderHeight: NSLayoutConstraint!
    private var fillImagePlaceholderWidth: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let newRect = CGRect(
            x: 0,
            y: 0,
            width: widthMultiplier * fillImagePlaceholder.frame.width,
            height: fillImagePlaceholder.frame.height)
        
        UIView.animate(withDuration: progressAnimationDuration) {
            self.fillImage?.frame = newRect
        }
    }
    
    //Public Methods
    func configure(with entity: ClaweeProgressBarEntity) {
        if let bgImage = UIImage(named: entity.backgroundImage),
           let fImage = UIImage(named: entity.fillImage) {
            
            let bgInsets = UIEdgeInsets(
                top: 0,
                left: bgImage.size.height / 2,
                bottom: 0,
                right: bgImage.size.height / 2)
            
            background.image = bgImage.resizableImage(withCapInsets: bgInsets, resizingMode: .stretch)
            
            set(fillImage: fImage)
            setFillImagePlaceholderSize(
                bgSize: bgImage.size,
                fillImageSize: fImage.size)
        }
        
        set(progres: entity.progressFromZeroToOne, text: entity.text)
    }
    
    func set(progres multiplier: CGFloat = 0, text: String? = nil, animationDuration: TimeInterval = 0.0) {
        progressAnimationDuration = animationDuration
        self.widthMultiplier = multiplier
        textLabel.text = text
        setNeedsLayout()
        layoutIfNeeded()
    }
}

//MARK: - Private Methods Extension
private extension ClaweeProgressBar {
    func set(fillImage image: UIImage) {
        let fillInsets = UIEdgeInsets(
            top: 0,
            left: image.size.height / 2,
            bottom: 0,
            right: image.size.height / 2)
        
        fillImage?.removeFromSuperview()
        fillImage = UIImageView(
            image: image.resizableImage(withCapInsets: fillInsets, resizingMode: .stretch))
        
        if let image = fillImage {
            fillImagePlaceholder.addSubview(image)
        }
    }
    
    func setFillImagePlaceholderSize(bgSize: CGSize, fillImageSize: CGSize) {
        guard let placeholder = fillImagePlaceholder else { return }
        
        if let wConstraint = fillImagePlaceholderWidth,
           let hConstraint = fillImagePlaceholderHeight {
            placeholder.removeConstraint(wConstraint)
            placeholder.removeConstraint(hConstraint)
        }
        
        let hMultiplier = fillImageSize.height / bgSize.height
        let wMultiplier = fillImageSize.width / bgSize.width
        
        fillImagePlaceholderHeight = NSLayoutConstraint(
            item: placeholder,
            attribute: .height,
            relatedBy: .equal,
            toItem: background,
            attribute: .height,
            multiplier: hMultiplier,
            constant: 0)
        
        fillImagePlaceholderWidth = NSLayoutConstraint(
            item: placeholder,
            attribute: .width,
            relatedBy: .equal,
            toItem: background,
            attribute: .width,
            multiplier: wMultiplier,
            constant: 0)
        
        fillImagePlaceholderHeight.isActive = true
        fillImagePlaceholderWidth.isActive = true
        
        layoutIfNeeded()
    }
}

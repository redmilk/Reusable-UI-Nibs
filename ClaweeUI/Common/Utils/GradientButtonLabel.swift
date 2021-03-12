//
//  GradientButtonLabel.swift
//  Clawee
//
//  Created by roman.b on 22.05.2020.
//  Copyright © 2020 Noisy Miner. All rights reserved.
//

import UIKit

final class GradientButtonLabel: Label {
    @IBInspectable var outlineWidth: CGFloat = 0
    @IBInspectable var outlineColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var fontColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = sizeThatFits(.zero)
        size.width += outlineWidth * 2
        
        return size
    }
    
    override public func drawText(in rect: CGRect) {
        let shadowOffset = self.shadowOffset
        let rect = CGRect(x: outlineWidth, y: rect.minY, width: rect.width - outlineWidth * 2, height: rect.height)
        
        let c = UIGraphicsGetCurrentContext()
        c?.setLineWidth(outlineWidth)
        c?.setLineJoin(.round)
        c?.setTextDrawingMode(.stroke)
        self.textColor = outlineColor
        super.drawText(in:rect)
        
        c?.setTextDrawingMode(.fill)
        self.textColor = fontColor
        self.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in:rect)
        
        self.shadowOffset = shadowOffset
    }
    
    convenience init(outlineWidth: CGFloat = 3.5, outlineColor: UIColor = #colorLiteral(red: 0, green: 0.4412734509, blue: 0, alpha: 1)) {
        self.init(frame: CGRect())
        
        self.outlineWidth = outlineWidth
        self.outlineColor = outlineColor
    }
}

class Label: UILabel {
    @IBInspectable var lineHeightMultiple: CGFloat = 1 {
        didSet {
            setNeedsDisplay()
            setLineSpacing(lineHeightMultiple: lineHeightMultiple)
        }
    }
    
    @IBInspectable var baselineOffset: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
            fixAttributedStringByBaseline(offset: baselineOffset)
        }
    }
}

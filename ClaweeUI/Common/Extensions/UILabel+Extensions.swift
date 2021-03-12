//
//  UILabel+Extensions.swift
//  ClaweeUI
//
//  Created by Danyl Timofeyev on 12.03.2021.
//

import UIKit

extension UILabel {
    
    func setLineSpacing(
        lineSpacing: CGFloat = 0.0,
        lineHeightMultiple: CGFloat = 0.0,
        letterSpacing: CGFloat = 0.0,
        minimumLineHeight: CGFloat? = nil
    ) {
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        if let minimumLineHeight = minimumLineHeight { paragraphStyle.minimumLineHeight = minimumLineHeight }
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = self.lineBreakMode
        
        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedString.length))
        // Letter spacing attribute
        attributedString.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
    
    
    func fixAttributedStringByBaseline(offset: CGFloat? = nil) {
        guard let text = text, !text.isEmpty else { return }
        let symbolHeight: CGFloat? = {
            let firstLetter = String(Array(text)[0])
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = firstLetter.size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
            
            return size.height
        }()
        
        let baselineOffset = offset != nil ? -offset! : -((symbolHeight! - font.pointSize) / 2)
        
        let newAttributedText: NSMutableAttributedString = {
            let n = NSMutableAttributedString(attributedString: attributedText!)
            n.addAttributes([.baselineOffset: baselineOffset],
                            range: NSRange(location: 0, length: n.length))
            return n
        }()
        
        self.attributedText = newAttributedText
    }
    
}



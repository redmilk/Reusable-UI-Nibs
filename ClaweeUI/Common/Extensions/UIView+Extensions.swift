//
//  UIView+Extensions.swift
//  ClaweeUI
//
//  Created by Danyl Timofeyev on 11.03.2021.
//

import UIKit 


extension UIView {
    
    // MARK: - Nib
    
    func loadViewFromNib(nibName: String) -> UIView {
        let bundle = Bundle(for: Self.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    var className: String {
        String(describing: Self.self)
    }
    
    func addAndFill(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
        self.addConstraints([
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: subview, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: subview, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        ])
    }
    
    // MARK: - Styling
    
    func setShadow(withCornerRadius corner: CGFloat, color: UIColor, radius: CGFloat? = 3, opacity: Float? = 0.4) {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: corner, cornerHeight: corner, transform: nil)
        self.layer.shadowRadius = radius ?? 3
        self.layer.shadowOpacity = opacity ?? 0.4
        self.layer.bounds = self.bounds
    }
    
    func add(radius: CGFloat, toCorners corners: UIRectCorner) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            clipsToBounds = true
            let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            
            maskLayer.path = path.cgPath
            layer.mask = maskLayer
        }
    }
}

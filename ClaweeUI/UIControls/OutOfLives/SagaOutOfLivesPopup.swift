//
//  PurchaseOptionsView.swift
//  ClaweeUI
//
//  Created by Danyl Timofeyev on 16.03.2021.
//

import UIKit

//MARK: - File constants

fileprivate let outlineColor: UIColor = #colorLiteral(red: 0.1198733225, green: 0.1295102835, blue: 0.1509302557, alpha: 1)
fileprivate let outlineWidth: CGFloat = 1
fileprivate let tabsCornerRadius: CGFloat = 4

//MARK: - SagaOutOfLivesPopup

@IBDesignable final class SagaOutOfLivesPopup: NibView {
    
    struct State {
        let purchaseOptionsPrices: [Int]
        
        static var dummy: State {
            return State(purchaseOptionsPrices: [50, 100, 1000])
        }
    }
    
    private enum PurchaseButtonIndex: Int {
        case first, second, third
    }
    
    //MARK: - Outlets
   
    @IBOutlet private weak var titleLabel: GradientButtonLabel!
    @IBOutlet private weak var subtitleLabel: GradientButtonLabel!
    @IBOutlet private weak var bottomDescriptionLabel: UILabel!
    @IBOutlet private var purchaseTabContainerViews: [UIView]!
    @IBOutlet private var heartCountLabels: [GradientButtonLabel]!
    @IBOutlet private var purchaseButtons: [ButtonWithOutlinedLabel]!
    /// here we can use private(set) due to value type of property
    /// nothing inside can be accidentally or unexcpectedly changed
    private(set) var currentState: State!
    
    //MARK: - CustomPopupProtocol Implementation
    
    var size: CGSize { return CGSize(width: 300, height: 200) }
    func set<T>(entity: T) {
        guard let currentState = entity as? State else { return }
        self.currentState = currentState
        styling()
        configureView(with: self.currentState)
    }
    
    @IBAction func purchasePressed(_ sender: UIButton) {
        switch PurchaseButtonIndex(rawValue: sender.tag)! {
        case .first: break
        case .second: break
        case .third: break
        }
    }
}

// MARK: - Private methods

private extension SagaOutOfLivesPopup {
    func styling() {
        purchaseTabContainerViews.forEach {
            $0.add(radius: tabsCornerRadius,
                   toCorners: .allCorners)
        }
        heartCountLabels.forEach {
            $0.outlineColor = outlineColor
            $0.outlineWidth = outlineWidth
        }
    }
    
    func configureView(with state: State) {
        titleLabel.text = "Out of lives"
        subtitleLabel.text = "Add more lives"
        for (index, button) in purchaseButtons.enumerated() {
            button.setTitle(state.purchaseOptionsPrices[index].description, for: .normal)
        }
    }
}

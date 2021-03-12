//
//  ViewController.swift
//  ClaweeUI
//
//  Created by Danyl Timofeyev on 11.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sagaButton: SagaButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let model = ClaweeProgressBarEntity(backgroundImage: "heartBar", fillImage: "fill", text: nil, progressFromZeroToOne: 0.3)
        
        sagaButton.configure(with: model)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.sagaButton.setProgress(with: 0.8)
        }
        
        
    }
    
    
    
}


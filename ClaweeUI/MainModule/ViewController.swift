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
        let today: Date = Date()
        let nextDate: Date = Calendar.current.date(byAdding: .second, value: 10, to: today)!

        let sagaButtonState = SagaButton.State(progress: 0.1, heartsCount: 3, timerExpirationDate: nextDate) {
            Logger.log("Timer did finished")
        }
        sagaButton.configure(with: sagaButtonState)
   
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.sagaButton.setHeartProgressState(with: 0.7, animationDuration: 1.0, heartsCount: 4)
        }
        
        
    }
    
    
    
}


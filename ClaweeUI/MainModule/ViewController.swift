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
        let nextDate: Date = Calendar.current.date(byAdding: .day, value: 3, to: today)!

        let timerState = SagaButton.TimerState(timerExpirationDate: nextDate) {
            Logger.log("Timer time has gone", type: .all)
        }
        
        let heartProgressState = SagaButton.HeartProgressState(progress: 0.2, heartsCount: 3)
                
        let initialState = SagaButton.InitialState(isTopTitleHidden: false,
                                                   timerState: timerState,
                                                   heartProgressState: heartProgressState)
        
        sagaButton.update(with: SagaButton.State.initial(initialState))
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let heartProgressState = SagaButton.HeartProgressState(progress: 0.7, heartsCount: 6)
            self.sagaButton.update(with: SagaButton.State.heartProgress(heartProgressState))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            let heartProgressState = SagaButton.HeartProgressState(progress: 0.2, heartsCount: 7)
            self.sagaButton.update(with: SagaButton.State.heartProgress(heartProgressState))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            let heartProgressState = SagaButton.HeartProgressState(progress: 0.5, heartsCount: 8)
            self.sagaButton.update(with: SagaButton.State.heartProgress(heartProgressState))
        }
    }

}


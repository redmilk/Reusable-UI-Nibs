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

        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
        }
        
    }
    
    
    
}


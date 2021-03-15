//
//  ViewController.swift
//  ClaweeUI
//
//  Created by Danyl Timofeyev on 11.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sagaButton: PlaySagaButton!
    @IBOutlet weak var heartLevelProgress: HeartLevelProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        sagaButton.dummyXibDemo() {
            Logger.log("Play button pressed")
        }
        heartLevelProgress.dummyXibDemo()
        
    }
  

}


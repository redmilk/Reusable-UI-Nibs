//
//  ClaweeTimer.swift
//  Clawee
//
//  Created by Roma Bozhenko on 06.10.2020.
//  Copyright © 2020 Noisy Miner. All rights reserved.
//

import Foundation


struct Constants {
    static let currentSagaVersion = 1
    static let timerExpiredLong = "00m:00s"
    static let timerExpiredShort = "00:00"
}

final class ClaweeTimer {
    private var completion: ((String, Bool?) -> Void)? //(timerLabelText, isExpired?)
    private var isShortFormat = false // "0m:10s" OR "0:10"
    private(set) var expireTime = Date()
    private var loopPeriod: Double = 0 // seconds to add to expireTime
    private var currentTime: Date { Date() }
    private var timer: Timer?

    private var timeDiff: Double {
        let diff = expireTime.timeIntervalSince1970 - Date().timeIntervalSince1970
        return Double(diff).rounded()
    }
    
    private var timerText: String {
        .timeStringForExpirationTime(using: timeDiff, isShortFormat: isShortFormat)
    }
    
    //MARK: - Public API
    func run(tillExpirationDateInMillisecondsSince1970 date: TimeInterval,
             timeInterval: Double = 1,
             shortTimerFormat: Bool = false,
             onTimeChange completion: @escaping ((String, Bool?) -> Void)) {
        expireTime = Date(timeIntervalSince1970: date / 1000)
        isShortFormat = shortTimerFormat
        self.completion = completion
        checkExpirationTime()
        
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(checkExpirationTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func countDown(seconds: Double,
                   timeInterval: Double = 1,
                   completion: @escaping ((String, Bool?) -> Void)) {
        expireTime = Date().addingTimeInterval(seconds)
        self.completion = completion
        checkCountdownTime()
        
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(checkCountdownTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func loop(expirationTime date: TimeInterval,
              loopPeriod: Double,
              timeInterval: Double = 1,
              shortTimerFormat: Bool = false,
              onTimeChange completion: @escaping ((String, Bool?) -> Void)) {
        expireTime = Date(timeIntervalSince1970: date / 1000)
        isShortFormat = shortTimerFormat
        self.completion = completion
        self.loopPeriod = loopPeriod
        loopTimer()
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(loopTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        completion = nil
        timer = nil
    }
    
    //MARK: - Private API
    @objc private func loopTimer() {
        guard expireTime >= currentTime else {
            expireTime = expireTime.addingTimeInterval(loopPeriod)
            completion?(timerText, true)
            return
        }
        
        completion?(timerText, nil)
    }
    
    @objc private func checkExpirationTime() {
        guard expireTime > currentTime else {
            completion?(isShortFormat ? Constants.timerExpiredShort : Constants.timerExpiredLong, true)
            stopTimer()
            return
        }
        completion?(timerText, nil)
    }
    
    @objc private func checkCountdownTime() {
        guard expireTime >= currentTime else {
            completion?("0", true)
            stopTimer()
            return
        }
        
        completion?(timerText, nil)
    }
}

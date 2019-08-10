//
//  TimerController.swift
//  Toast
//
//  Created by ParkSungJoon on 14/07/2019.
//  Copyright © 2019 DDD. All rights reserved.
//

import Foundation

class TimerController {
    
    private var count: Double = 0.0
    
    var timer: Timer
    
    init(timer: Timer = Timer()) {
        self.timer = timer
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(counter),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func pause() {
        timer.invalidate()
    }
    
    func reset() {
        timer.invalidate()
        count = 0.0
    }
    
    func getCount() -> String {
        return String(describing: count)
    }
}

private extension TimerController {
    
    @objc func counter() {
        count += 1
    }
}

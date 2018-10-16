//
//  Stopwatch.swift
//  Voice Changer Libre
//
//  Created by Luis on 10/15/18.
//  Copyright © 2018 Bushki. All rights reserved.
//

import Foundation

class Stopwatch {
    
    private var startTime : Date?
    
    var elapsedTime: TimeInterval {
        if let startTime = self.startTime {
            return -startTime.timeIntervalSinceNow
        } else {
            return 0
        }
    }
    var isRunning: Bool {
        return startTime != nil
    }
    
    func start() {
        startTime = Date()
    }
    
    func stop() {
        startTime = nil
    }
}

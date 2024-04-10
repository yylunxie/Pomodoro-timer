//
//  pomodoroModel.swift
//  pomodoro
//
//  Created by 謝宇倫 on 2024/4/10.
//

import SwiftUI

class PomodoroModel: NSObject, ObservableObject {
    @Published var focusTime: Int?
    @Published var date = Date()
    @Published var goal = ""
    @Published var timeRemaining: TimeInterval = 60 * 25
    @Published var setTime: Int?
    @Published var timer: Timer?
    @Published var isRunning: Bool = false
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
            }
        }
    }
    
    func stopTimer() {
        self.isRunning = false
        self.timer?.invalidate()
        self.timeRemaining = 60 * 25
    }
    
    func pauseTimer() {
        // To do
    }
}

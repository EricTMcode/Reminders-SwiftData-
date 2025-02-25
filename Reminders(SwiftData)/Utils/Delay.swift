//
//  Delay.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 25/02/2025.
//

import Foundation

class Delay {

    private var seconds: Double
    var workItem: DispatchWorkItem?

    init(seconds: Double = 2.0) {
        self.seconds = seconds
    }

    func performWork(_ work: @escaping () -> Void) {
        workItem = DispatchWorkItem {
            work()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: workItem!)
    }

    func canel() {
        workItem?.cancel()
    }
}

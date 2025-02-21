//
//  Reminder.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 21/02/2025.
//

import Foundation
import SwiftData

@Model
class Reminder {
    
    var title: String
    var notes: String?
    var isCompleted: Bool
    var reminderDate: Date?
    var remminderTime: Date?

    var list: MyList?

    init(title: String, notes: String? = nil, isCompleted: Bool, reminderDate: Date? = nil, remminderTime: Date? = nil, list: MyList? = nil) {
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.reminderDate = reminderDate
        self.remminderTime = remminderTime
        self.list = list
    }
}

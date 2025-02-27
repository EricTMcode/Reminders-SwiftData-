//
//  Reminders_SwiftData_App.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 20/02/2025.
//

import SwiftUI
import UserNotifications

@main
struct Reminders_SwiftData_App: App {

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MyListsScreen()
            }
            .modelContainer(for: [MyList.self, Reminder.self])
        }
    }
}

//
//  Reminders_SwiftData_App.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 20/02/2025.
//

import SwiftData
import SwiftUI

@main
struct Reminders_SwiftData_App: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MyListsScreen()
                    .modelContainer(for: MyList.self)
            }

        }
    }
}

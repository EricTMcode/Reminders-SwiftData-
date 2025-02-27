//
//  ReminderListView.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 26/02/2025.
//

import SwiftUI
import SwiftData

struct ReminderListView: View {
    let reminders: [Reminder]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedReminder: Reminder? = nil
    @State private var showReminderEditScreen = false

    @State private var reminderIdAndDelay: [PersistentIdentifier: Delay] = [ : ]

    private func deleteReminder(offsets: IndexSet) {
        withAnimation {
            offsets.map { reminders[$0] }.forEach(modelContext.delete)
            try? modelContext.save()
        }
    }

    var body: some View {
        List {
            ForEach(reminders) { reminder in
                RemindersCellView(reminder: reminder) { event in
                    switch event {
                    case .onChecked(let reminder, let checked):

                        // get the delay from the dictionary
                        var delay = reminderIdAndDelay[reminder.persistentModelID]
                        if let delay {
                            // cancel
                            delay.cancel()
                            reminderIdAndDelay.removeValue(forKey: reminder.persistentModelID)
                        } else {
                            // create a new delay and add to the dictionary
                            delay = Delay()
                            reminderIdAndDelay[reminder.persistentModelID] = delay
                            delay?.performWork {
                                reminder.isCompleted = checked
                            }
                        }
                    case .onSelect(let reminder):
                        selectedReminder = reminder
                    }
                }
            }
            .onDelete(perform: deleteReminder)
        }
        .sheet(item: $selectedReminder) { selectedReminder in
            NavigationStack {
                ReminderEditScreen(reminder: selectedReminder)
            }
        }
    }
}

//#Preview {
//    ReminderListView()
//}

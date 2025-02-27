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

    private let delay = Delay()

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
                        delay.cancel()
                        delay.performWork {
                            reminder.isCompleted = checked
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

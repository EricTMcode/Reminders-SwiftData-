//
//  ReminderEditScreen.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 24/02/2025.
//

import SwiftUI
import SwiftData

struct ReminderEditScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let reminder: Reminder

    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var reminderDate: Date = .now
    @State private var reminderTime: Date = .now

    @State private var showCalendar = false
    @State private var showTime = false

    private func updateReminder() {
        reminder.title = title
        reminder.notes = notes.isEmpty ? nil : notes
        reminder.reminderDate = showCalendar ? reminderDate : nil
        reminder.reminderTime = showTime ? reminderTime : nil
        try?modelContext.save()

        // Schedule a local notification
        NotificationManager.scheduleNotification(userData: UserData(title: reminder.title, body: reminder.notes, date: reminder.reminderDate, time: reminder.reminderTime))
    }

    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title)
                TextField("Notes", text: $notes)
            }

            Section {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.red)
                        .font(.title2)

                    Toggle(isOn: $showCalendar) {
                        EmptyView()
                    }
                }

                if showCalendar {
                    DatePicker("Select Date", selection: $reminderDate, in: .now..., displayedComponents: .date)
                }

                HStack {
                    Image(systemName: "clock")
                        .foregroundStyle(.blue)
                        .font(.title2)

                    Toggle(isOn: $showTime) {
                        EmptyView()
                    }
                }
                .onChange(of: showTime) {
                    if showTime {
                        showCalendar = true
                    }
                }

                if showTime {
                    DatePicker("Select Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                }

            }

        }
        .onAppear {
            title = reminder.title
            notes = reminder.notes ?? ""
            reminderDate = reminder.reminderDate ?? Date()
            reminderTime = reminder.reminderTime ?? Date()
            showCalendar = reminder.reminderDate != nil
            showTime = reminder.reminderTime != nil
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    updateReminder()
                    dismiss()
                }
                .disabled(!isFormValid)
            }
        }
    }
}

//struct ReminderEditScreenContainer: View {
//
//    @Query(sort: \Reminder.title) private var reminders: [Reminder]
//
//    var body: some View {
//        ReminderEditScreen(reminder: reminders[0])
//    }
//}
//
//#Preview { @MainActor in
//    NavigationStack {
//        ReminderEditScreenContainer()
//    }
//    .modelContainer(previewContainer)
//}

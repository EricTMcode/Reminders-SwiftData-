//
//  RemindersCellView.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 24/02/2025.
//

import SwiftUI
import SwiftData

struct RemindersCellView: View {

    let reminder: Reminder

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "circle")
                .font(.title2)
                .padding(.trailing, 5)
                .onTapGesture {

                }

            VStack(alignment: .leading) {
                Text(reminder.title)
//                    .frame(maxWidth: .infinity, alignment: .leading)

                if let notes = reminder.notes {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }

                HStack {
                    if let reminderDate = reminder.reminderDate {
                        Text(reminderDate.formatted())
                    }

                    if let reminderTime = reminder.remminderTime {
                        Text(reminderTime.formatted())
                    }
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct ReminderCelleViewContainer: View {

    @Query(sort: \Reminder.title) private var reminders: [Reminder]

    var body: some View {
        RemindersCellView(reminder: reminders[0])
    }
}

#Preview { @MainActor in
    ReminderCelleViewContainer()
        .modelContainer(previewContainer)
}

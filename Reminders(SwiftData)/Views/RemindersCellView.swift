//
//  RemindersCellView.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 24/02/2025.
//

import SwiftUI
import SwiftData

enum ReminderCellEvents {
    case onChecked(Reminder, Bool)
    case onSelect(Reminder)
}

struct RemindersCellView: View {


    let reminder: Reminder
    let onEvent: (ReminderCellEvents) -> Void

    @State private var checked = false

    private func formatReminderDate(_ date: Date) -> String {
        if date.isToday {
            return "Today"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else {
            return date.formatted(date: .numeric, time: .omitted)
        }
    }

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: checked ? "circle.inset.filled" : "circle")
                .font(.title2)
                .padding(.trailing, 5)
                .onTapGesture {
                    checked.toggle()
                    onEvent(.onChecked(reminder, checked))
                }

            VStack(alignment: .leading) {
                Text(reminder.title)

                if let notes = reminder.notes {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }

                HStack {
                    if let reminderDate = reminder.reminderDate {
                        Text(formatReminderDate(reminderDate))
                    }

                    if let reminderTime = reminder.reminderTime {
                        Text(reminderTime, style: .time)
                    }
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onEvent(.onSelect(reminder))
        }
    }
}

struct ReminderCelleViewContainer: View {

    @Query(sort: \Reminder.title) private var reminders: [Reminder]

    var body: some View {
        RemindersCellView(reminder: reminders[0]) { _ in }
    }
}

#Preview { @MainActor in
    ReminderCelleViewContainer()
        .modelContainer(previewContainer)
}

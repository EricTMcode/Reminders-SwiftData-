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
    case onInfoSelected(Reminder)
}

struct RemindersCellView: View {

    let reminder: Reminder
    let isSelected: Bool
    let onEvent: (ReminderCellEvents) -> Void

    @State private var checked = false

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
                        Text(reminderDate.formatted())
                    }

                    if let reminderTime = reminder.reminderTime {
                        Text(reminderTime.formatted())
                    }
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
            Image(systemName: "info.circle.fill")
                .opacity(isSelected ? 1 : 0 )
                .onTapGesture {
                    onEvent(.onInfoSelected(reminder))
                }
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
        RemindersCellView(reminder: reminders[0], isSelected: false) { _ in }
    }
}

#Preview { @MainActor in
    ReminderCelleViewContainer()
        .modelContainer(previewContainer)
}

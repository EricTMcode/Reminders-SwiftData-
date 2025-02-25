//
//  MyListDetailScreen.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 21/02/2025.
//

import SwiftUI
import SwiftData

struct MyListDetailScreen: View {
    @Environment(\.modelContext) private var modelContext
    let myList: MyList
    
    @State private var reminderTitle = ""
    @State private var isNewReminderPresented = false
    @State private var selectedReminder: Reminder?
    @State private var showReminderEditScreen = false

    private var isFormValid: Bool {
        !reminderTitle.isEmptyOrWhitespace
    }

    private func saveReminder() {
        let reminder = Reminder(title: reminderTitle)
        myList.reminders.append(reminder)
        try?modelContext.save()
        reminderTitle = ""
    }

    private func isReminderSelectect(_ reminder: Reminder) -> Bool {
        reminder.persistentModelID == selectedReminder?.persistentModelID
    }

    var body: some View {
        VStack {
            List {
                ForEach(myList.reminders.filter { !$0.isCompleted }) { reminder in
                    RemindersCellView(reminder: reminder, isSelected: isReminderSelectect(reminder)) { event in
                        switch event {
                        case .onChecked(let reminder, let checked):
                            reminder.isCompleted = checked
                        case .onSelect(let reminder):
                            selectedReminder = reminder
                        case .onInfoSelected(let reminder):
                            showReminderEditScreen = true
                            selectedReminder = reminder
                        }
                    }
                }
                .onDelete(perform: deleteReminder)
            }

            Spacer()

            Button {
                isNewReminderPresented = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("New Reminder")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle(myList.name)
        .sheet(isPresented: $showReminderEditScreen) {
            if let selectedReminder {
                NavigationStack {
                    ReminderEditScreen(reminder: selectedReminder)
                }
            }
        }
        .alert("New Reminder", isPresented: $isNewReminderPresented) {
            TextField("", text: $reminderTitle)
            Button("Cancel", role: .cancel) { }
            Button("Done") {
                saveReminder()
            }
            .disabled(!isFormValid)
        }
    }

    private func deleteReminder(offsets: IndexSet) {
        withAnimation {
            offsets.map { myList.reminders[$0] }.forEach(modelContext.delete)
            try? modelContext.save()
        }
    }
}

struct MyListDetailScreenContainer: View {

    @Query private var myLists: [MyList]

    var body: some View {
        MyListDetailScreen(myList: myLists[0])
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListDetailScreenContainer()
    }
    .modelContainer(previewContainer)
}

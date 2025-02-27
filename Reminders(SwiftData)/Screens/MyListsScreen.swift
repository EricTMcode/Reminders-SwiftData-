//
//  MyListsScreen.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 20/02/2025.
//

import SwiftUI
import SwiftData

enum ReminderStatsType: Int, Identifiable {
    case today
    case scheduled
    case all
    case completed

    var id: Int {
        self.rawValue
    }

    var title: String {
        switch self {
        case .today:
            return "Today"
        case .scheduled:
            return "Scheduled"
        case .all:
            return "All"
        case .completed:
            return "Completed"
        }
    }
}

struct MyListsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var myLists: [MyList]
    
    @State private var isPresented = false
    @State private var selectedList: MyList?

    @State private var actionSheet: MyListScreenSheets?
    @State private var reminderStatsType: ReminderStatsType?

    @Query private var reminders: [Reminder]

    enum MyListScreenSheets: Identifiable {
        case newList
        case editList(MyList)

        var id: Int {
            switch self {
            case .newList:
                return 1
            case .editList(let myList):
                return myList.hashValue
            }
        }
    }

    private var inCompleteReminders: [Reminder] {
        reminders.filter { !$0.isCompleted }
    }

    private var todaysReminders: [Reminder] {
        reminders.filter {
            guard let reminderDate = $0.reminderDate else {
                return false
            }

            return reminderDate.isToday && !$0.isCompleted
        }
    }

    private var scheduleReminders: [Reminder] {
        reminders.filter {
            $0.reminderDate != nil && !$0.isCompleted
        }
    }

    private var completedReminders: [Reminder] {
        reminders.filter { $0.isCompleted }
    }

    private func reminders(for type: ReminderStatsType) -> [Reminder] {
        switch type {
        case .today:
            return todaysReminders
        case .scheduled:
            return scheduleReminders
        case .all:
            return inCompleteReminders
        case .completed:
            return completedReminders
        }
    }

    var body: some View {
        List {
            VStack {
                HStack {
                    ReminderStatsView(
                        icon: "calendar",
                        title: "Today",
                        count: todaysReminders.count)
                    .onTapGesture {
                        reminderStatsType = .today
                    }
                    ReminderStatsView(
                        icon: "calendar.circle.fill",
                        title: "Scheduled",
                        count: scheduleReminders.count)
                    .onTapGesture {
                        reminderStatsType = .scheduled
                    }
                }
                HStack {
                    ReminderStatsView(
                        icon: "tray.circle.fill",
                        title: "All",
                        count: inCompleteReminders.count
                    )
                    .onTapGesture {
                        reminderStatsType = .all
                    }
                    ReminderStatsView(
                        icon: "checkmark.circle.fill",
                        title: "Completed",
                        count: completedReminders.count
                    )
                    .onTapGesture {
                        reminderStatsType = .completed
                    }
                }
            }

            ForEach(myLists) { myList in
                NavigationLink(value: myList) {
                    MyListCellView(myList: myList)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedList = myList
                        }
                        .onLongPressGesture(minimumDuration: 0.5) {
                            actionSheet = .editList(myList)
                        }
                }
            }
            .onDelete(perform: deleteCategories)
            
            Button {
                actionSheet = .newList
            } label: {
                Text("Add List")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .listRowSeparator(.hidden)
        }
        .navigationTitle("My Lists")
        .navigationDestination(item: $selectedList) { myList in
            MyListDetailScreen(myList: myList)
        }
        .navigationDestination(item: $reminderStatsType) { reminderStatsType in
            NavigationStack {
                ReminderListView(reminders: reminders(for: reminderStatsType))
                .navigationTitle(reminderStatsType.title)
            }
        }
        .listStyle(.plain)
        .sheet(item: $actionSheet) { actionSheet in
            switch actionSheet {
            case .newList:
                NavigationStack {
                    AddMyListScreen()
                }
            case .editList(let myList):
                NavigationStack {
                    AddMyListScreen(myList: myList)
                }
            }
        }
    }
    
    private func deleteCategories(offsets: IndexSet) {
        withAnimation {
            offsets.map { myLists[$0] }.forEach(modelContext.delete)
            try? modelContext.save()
        }
    }
}

#Preview("Light Mode") { @MainActor in
    NavigationStack {
        MyListsScreen()
    }
    .modelContainer(previewContainer)
}

#Preview("Dark Mode") { @MainActor in
    NavigationStack {
        MyListsScreen()
    }
    .modelContainer(previewContainer)
    .environment(\.colorScheme, .dark)
}



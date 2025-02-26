//
//  PreviewContainer.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 20/02/2025.
//

import Foundation
import SwiftData

@MainActor
var previewContainer: ModelContainer = {

    let container = try! ModelContainer(for: MyList.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    for myList in SampleData.myLists {
        container.mainContext.insert(myList)
        myList.reminders = SampleData.reminders
    }

    return container

}()


struct SampleData {
    static var myLists: [MyList] {
        return [MyList(name: "Reminders", colorCode: "#34C759"), MyList(name: "Backlog", colorCode: "#AF52DE")]
    }

    static var reminders: [Reminder] {
        return [Reminder(title: "Reminder 1", notes: "This is a note for reminder 1", reminderDate: Date(), remminderTime: Date()), Reminder(title: "Reminder 2", notes: "This is a note for reminder 2", reminderDate: Date(), remminderTime: Date())]
    }
}

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
    }

    return container

}()


struct SampleData {
    static var myLists: [MyList] {
        return [MyList(name: "Reminders", colorCode: "#2ecc71"), MyList(name: "Backlog", colorCode: "#9b59b6")]
    }
}

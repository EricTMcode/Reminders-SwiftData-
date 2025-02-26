//
//  MyListCellView.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 26/02/2025.
//

import SwiftUI
import SwiftData

struct MyListCellView: View {

    let myList: MyList

    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(Color(hex: myList.colorCode))
            Text(myList.name)
        }
    }
}

struct MyListCellViewContainer: View {

    @Query() private var myList: [MyList]

    var body: some View {
        MyListCellView(myList: myList[0])
    }
}

#Preview { @MainActor in
    MyListCellViewContainer()
        .modelContainer(previewContainer)
}

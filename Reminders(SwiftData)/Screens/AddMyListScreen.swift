//
//  AddMyListScreen.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 20/02/2025.
//

import SwiftUI

struct AddMyListScreen: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var color: Color = .blue
    @State private var listName = ""

    var myList: MyList? = nil


    var body: some View {
        VStack {
            Image(systemName: "line.3.horizontal.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(color)

            TextField("List Name", text: $listName)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing], 44)

            ColorPickerView(selectedColor: $color)

        }
        .onAppear {
            if let myList {
                listName = myList.name
                color = Color(hex: myList.colorCode)
            }
        }
        .navigationTitle("New List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    if let myList {
                        myList.name = listName
                        myList.colorCode = color.toHex() ?? ""
                    } else {
                        guard let hex = color.toHex() else { return }
                        let myList = MyList(name: listName, colorCode: hex)
                        modelContext.insert(myList)
                        try? modelContext.save()
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        AddMyListScreen()
    }
    .modelContainer(previewContainer)
}

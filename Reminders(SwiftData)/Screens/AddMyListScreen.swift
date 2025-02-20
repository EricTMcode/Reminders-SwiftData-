//
//  AddMyListScreen.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 20/02/2025.
//

import SwiftUI

struct AddMyListScreen: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var color: Color = .blue
    @State private var listName = ""


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

                    guard let hex = color.toHex() else { return }

                    let myList = MyList(name: listName, colorCode: hex)
                    modelContext.insert(myList)

                    do {
                        try modelContext.save()
                    } catch {
                        print("Failed to save model context: \(error)")
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

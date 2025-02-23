//
//  MyListsScreen.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 20/02/2025.
//

import SwiftUI
import SwiftData

struct MyListsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var myLists: [MyList]

    @State private var isPresented = false

    var body: some View {
        List {
            Text("My Lists")
                .font(.largeTitle)
                .bold()

            ForEach(myLists) { myList in
                NavigationLink {
                    MyListDetailScreen(myList: myList)
                } label: {
                    HStack {
                        Image(systemName: "line.3.horizontal.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(Color(hex: myList.colorCode))
                        Text(myList.name)
                    }
                }
            }
            .onDelete(perform: deleteCategories)

            Button {
                isPresented = true
            } label: {
                Text("Add List")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                AddMyListScreen()
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

#Preview { @MainActor in
    NavigationStack {
        MyListsScreen()
    }
    .modelContainer(previewContainer)
}

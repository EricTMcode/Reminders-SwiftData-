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
    @State private var selectedList: MyList?

    @State private var actionSheet: MyListScreenSheets?

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

    var body: some View {
        List {
            Text("My Lists")
                .font(.largeTitle)
                .bold()
            
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
        .navigationDestination(item: $selectedList) { myList in
            MyListDetailScreen(myList: myList)
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

#Preview { @MainActor in
    NavigationStack {
        MyListsScreen()
    }
    .modelContainer(previewContainer)
}



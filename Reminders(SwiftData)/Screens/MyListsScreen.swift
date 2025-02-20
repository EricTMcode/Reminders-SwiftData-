//
//  MyListsScreen.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 20/02/2025.
//

import SwiftUI

struct MyListsScreen: View {

    @State private var isPresented = false

    let myLists = ["Reminders", "Groceries", "Entertainment"]

    var body: some View {
        List {
            Text("My Lists")
                .font(.largeTitle)
                .bold()

            ForEach(myLists, id: \.self) { myList in
                HStack {
                    Image(systemName: "line.3.horizontal.circle.fill")
                        .font(.system(size: 32))
                    Text(myList)
                }
            }

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
}

#Preview {
    NavigationStack {
        MyListsScreen()
    }
}

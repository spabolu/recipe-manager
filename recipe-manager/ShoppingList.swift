//
//  ShoppingList.swift
//  recipe-manager
//
//  Created by Saketh Pabolu on 4/20/23.
//

import SwiftUI

struct ShoppingList: View {
    @State private var shoppingItem = ""
    @FetchRequest(sortDescriptors: [], animation: .default) var shoppingList:
        FetchedResults<ShoppingItem>
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Add Item:")
                            .foregroundColor(.blue)
                        TextField(
                            "Enter product name", text: $shoppingItem,
                            onCommit: {
                                addItem()
                                self.shoppingItem = ""
                            }
                        )
                        .padding(.all, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                        )
                    }
                    .padding(.horizontal)

                    Divider()

                    List {
                        ForEach(shoppingList) { item in
                            Button(action: {
                                let index = shoppingList.firstIndex(of: item)!
                                let shoppingItem = shoppingList[index]
                                shoppingItem.isPurchased.toggle()
                                do {
                                    try viewContext.save()
                                    print("Shopping Item \(shoppingItem.name ?? "") Updated!")
                                } catch {
                                    let error = error as NSError
                                    fatalError("Unresolved error: \(error)")
                                }
                            }) {
                                HStack {
                                    Text(item.name ?? "Unknown")
                                        .strikethrough(item.isPurchased)
                                    Spacer()
                                    Image(
                                        systemName: item.isPurchased
                                            ? "checkmark.circle.fill" : "circle"
                                    )
                                    .foregroundColor(item.isPurchased ? .blue : .secondary)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(InsetListStyle())
                }
                .padding(.vertical)

                VStack(alignment: .center) {
                    NavigationLink(
                        destination:
                            MapView()
                            .navigationTitle("Grocery Stores")
                            .navigationBarTitleDisplayMode(.automatic)
                    ) {
                        Label("Search for Grocery Stores Nearby", systemImage: "building.2.fill")
                            .foregroundColor(Color.blue)
                            .padding(.vertical, 4)
                    }
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { shoppingList[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
                print("Shopping Item Deleted!")
            } catch {
                let error = error as NSError
                fatalError("Unresolved error: \(error)")
            }
        }
    }

    private func addItem() {
        if !shoppingItem.trimmingCharacters(in: .whitespaces).isEmpty {
            let newItem = ShoppingItem(context: viewContext)
            newItem.name = "\(shoppingItem)"
            newItem.id = UUID()
            newItem.isPurchased = false

            do {
                try viewContext.save()

                print("Shopping Item \(newItem.name ?? "") Added!")
            } catch {
                let error = error as NSError
                fatalError("Unresolved error: \(error)")
            }

            shoppingItem = ""
        }
    }

}

struct ShoppingList_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingList()
    }
}

//
//  ContentView.swift
//  recipe-manager
//
//  Created by Saketh Pabolu on 4/20/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @State private var activeView = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack {
                    Label {
                        Text("Recipe Manager")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(Color.blue)
                            .padding(.bottom, 42)
                    } icon: {
                        Image(systemName: "frying.pan.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 48, weight: .bold))
                    }
                }

                Button(action: {
                    activeView = true
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(width: 150, height: 45)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .bold()
                }.padding(.top, 4)

                Text("Created by Saketh Pabolu")
                    .foregroundColor(.gray)
                    .padding(.top, 24)
                    .font(.footnote)
                    .bold()

                Spacer()

            }
            .padding(.horizontal, 22)
            .navigationDestination(isPresented: $activeView) {
                RecipeListView()
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(
            \.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

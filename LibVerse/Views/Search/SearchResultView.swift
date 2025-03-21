//
//  SearchResultView.swift
//  LibVerse
//
//  Created by Shahma Ansari on 20/03/25.
//

import SwiftUI

struct SearchResultView: View {
    let books = Array(0..<10)
    
    var body: some View {
        NavigationView {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack {
                        ForEach(books.reversed(), id: \.self) { index in
                            BookCard(
                                title: "The Great Gatsby",
                                author: "F. Scott Fitzgerald",
                                description: "Nick Carraway, a young man from Minnesota, moves to New York in the summer of the 1922 to learn about the bond business. He rents house in the West Egg district of Long Island, a wealthy but unfashionable area populated by the new rich, a group who ..."
                            )
                            .padding()
                        }
                    }
                    .background(Color(red: 252/255, green: 240/255, blue: 218/255))
                }
                .navigationTitle("Book List")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarHidden(true)
                .onAppear {
                }
            }
        }
        .background(Color(red: 252/255, green: 240/255, blue: 218/255)) // Background color for the whole page
    }
}

#Preview {
    SearchResultView()
}

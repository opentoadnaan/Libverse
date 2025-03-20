//
//  SearchView.swift
//  LibVerse
//
//  Created by Astha Arora on 20/03/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    
    var categories = [
        ("Career & Growth", "chart.bar.fill"),
        ("Business", "building.2.fill"),
        ("Finance & Money Management", "dollarsign.circle.fill"),
        ("Contemporary Fiction", "book.fill"),
        ("Romance", "heart.fill"),
        ("Politics", "building.columns.fill"),
        ("Mystery & Crime Fiction", "questionmark.circle.fill"),
        ("Sport & Recreation", "sportscourt.fill"),
        ("Social Science", "person.2.fill")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cream colored background
                Color(red: 255/255, green: 243/255, blue: 230/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 10)
                        
                    // Orange section with search at top
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Search")
                            .font(.custom("Monaco", size: 35))
//                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        HStack(spacing: 0) {
                            TextField("Title, author, host, or topic", text: $searchText)
                                .padding()
                                .frame(height: 44)
                                .background(Color(.systemBackground))
                                .cornerRadius(0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                            
                            Button(action: {
                                // Action for search button
                            }) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                }
                                .frame(height: 44)
                                .padding(.horizontal, 16)
                                .background(Color(red: 255/255, green: 111/255, blue: 45/255))
                                .foregroundColor(.white)
                                .cornerRadius(0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color(red: 255/255, green: 111/255, blue: 45/255))
                    
                    // Categories List
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(categories, id: \.0) { category, icon in
                                VStack(spacing: 0) {
                                    HStack {
                                        Image(systemName: icon)
                                            .foregroundColor(.black)
                                            .frame(width: 24, height: 24)
                                        Text(category)
                                            .font(.body)
                                        Spacer()
                                    }
                                    .padding(.vertical, 16)
                                    .padding(.horizontal)
                                    
                                    Divider()
                                        .background(Color.black.opacity(0.2))
                                }
                                .background(Color(red: 255/255, green: 243/255, blue: 230/255))
                            }
                        }
                    }
                    .background(Color(red: 255/255, green: 243/255, blue: 230/255))
                }
            }
            .navigationBarHidden(true)
        }
    }
}


#Preview {
    SearchView()
}

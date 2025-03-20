//
//  HomeView.swift
//  LibVerse
//
//  Created by Shahma Ansari on 19/03/25.
//

import SwiftUI


import SwiftUI

// MARK: - Model for Popular Books
struct PopularBook: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let author: String
    let rating: Int
    let isBookmarked: Bool
}

// MARK: - Main ContentView with TabView
struct TabBarView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
            
            MyShelfView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("MyShelf")
                }
                .tag(2)
            
            AlertView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Alert")
                }
                .tag(3)
        }
        .tint(.orange)
    }
}

// MARK: - HomeView with Announcements and Popular Section
struct HomeView: View {
    let popularBooks: [PopularBook] = [
        PopularBook(imageName: "mvc", title: "MVC", author: "R.S. Salaria", rating: 4, isBookmarked: true),
        PopularBook(imageName: "warandpeace", title: "War and Peace", author: "Leo Tolstoy", rating: 5, isBookmarked: false),
        PopularBook(imageName: "harrypotter", title: "Harry Potter", author: "J.K. Rowling", rating: 5, isBookmarked: true)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    // Profile Section
                    HStack {
                        Spacer()
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal)
                    
                    // Title
                    Text("Member")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                    
                    // Announcements Section
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Announcements")
                                .font(.title2)
                                .bold()
                            Spacer()
                            Button("See All") {
                                // Action
                            }
                            .foregroundColor(.orange)
                            .font(.system(size: 16, weight: .medium))
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0..<3) { _ in
                                    AnnouncementCard()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Popular Section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Popular")
                                .font(.title2)
                                .bold()
                            Spacer()
                            Button("See All") {
                            }
                            .foregroundColor(.orange)
                            .font(.system(size: 16, weight: .medium))
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: -35) {
                                ForEach(popularBooks) { book in
                                    PopularCard(book: book)
                                }
                            }
                            .padding(.leading)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(red: 255/255, green: 239/255, blue: 210/255).edgesIgnoringSafeArea(.all))
                        .navigationBarHidden(true)
            .navigationBarHidden(true)
        }
        
    }
}

// MARK: - Announcement Card
struct AnnouncementCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Announcement Title")
                .font(.headline)
            Text("This is a sample announcement text that describes the important information.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
        }
        .padding()
        .frame(width: 250)
        .frame(height: 200)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Popular Book Card with Black Square Border and Increased Width
struct PopularCard: View {
    let book: PopularBook
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Book Cover with Black Square Border
            ZStack {
                Rectangle()
                    .stroke(Color.black, lineWidth: 1.5)
                    .frame(width: 120, height: 150)
                
                Image(book.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 115, height: 145)
                    .clipped()
                    .background(Color.white)
            }
            .padding(.bottom, 2)
            
            // Book Title
            Text(book.title)
                .font(.custom("Charter", size: 14))
                .lineLimit(2)
                .frame(width: 160, alignment: .leading)
            // Author
            Text(book.author)
                .font(.custom("Charter", size: 13))
                .foregroundColor(.gray)
                .lineLimit(1)
            
        }
        .frame(width: 180)
    }
}
// MARK: - Other Views
struct SearchView: View {
    var body: some View {
        Text("Search View")
    }
}

struct MyShelfView: View {
    var body: some View {
        Text("MyShelf View")
    }
}

struct AlertView: View {
    var body: some View {
        Text("Alert View")
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}



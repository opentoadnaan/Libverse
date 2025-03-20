//
//  BookCard.swift
//  LibVerse
//
//  Created by Shahma Ansari on 20/03/25.
//

import SwiftUI

import SwiftUI

struct BookCard: View {
    let BookImage: String
    let title: String
    let author: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 16) {
                
                ZStack {
                    Rectangle()
                        .stroke(Color.black, lineWidth: 1.5)
                        .frame(width: 85, height: 110)
                    
                    Image("mvc")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 105)
                        .clipped()
                        .background(Color.white)
                }
                
                
                // Book details
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("Menlo", size: 13))
                        .fontWeight(.medium)
                    
                    Text("By \(author)")
                        .font(.custom("Menlo", size: 10))
                        .foregroundColor(.black)
                        .underline()
                    
                    Text(description)
                        .font(.custom("Menlo", size: 10))
                        .foregroundColor(.black)
                        .lineLimit(7)
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical, 8)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            HStack {
                Spacer()
                Button(action: {
                    // Add reserve action here
                    print("Reserve button tapped")
                }) {
                    Text("Reserve")
                        .frame(width: 345, height: 49, alignment: .center)
                        .background(Color(red: 255/255, green: 111/255, blue: 49/255))
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.black, lineWidth: 1.25)
                        )
                }
                Spacer()
            }
            .padding(.top, 16)
            
        }
        .frame(width: 384, height: 250, alignment: .center)
        .background(Color(red: 255/255, green: 239/255, blue: 210/255))
        .cornerRadius(0)
        .shadow(color: .black.opacity(0.5), radius: 0, x: 0, y: 1)
    }
        
}

// Preview
struct BookCard_Previews: PreviewProvider {
    static var previews: some View {
        BookCard(
            BookImage: "",
            title: "The Great Gatsby",
            author: "F. Scott Fitzgerald",
            description: "Nick Carraway, a young man from Minnesota, moves to New York in the summer of the 1922 to learn about the bond business. He rents house in the West Egg district of Long Island, a wealthy but unfashionable area populated by the new rich, a group who ..."
        )
        .padding()
    }
}

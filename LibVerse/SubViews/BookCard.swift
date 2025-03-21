//
//  BookCard.swift
//  LibVerse
//
//  Created by Shahma Ansari on 20/03/25.
//

import SwiftUI

struct BookCard: View {
    let title: String
    let author: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 16) {
                // Blue square thumbnail
                Rectangle()
                    .fill(Color(red: 66/255, green: 153/255, blue: 244/255))
                    .frame(width: 100, height: 100)
                
                // Book details
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("By \(author)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    Text(description)
                        .font(.body)
                        .foregroundColor(.black)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical, 8)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            // Reserve button
            Button(action: {
                // Add reserve action here
            }) {
                Text("Reserve")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 217/255, green: 115/255, blue: 77/255))
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding(.top, 16)
        }
        .background(Color(white: 0.98))
        .cornerRadius(8)
    }
}

// Preview
struct BookCard_Previews: PreviewProvider {
    static var previews: some View {
        BookCard(
            title: "The Great Gatsby",
            author: "F. Scott Fitzgerald",
            description: "Nick Carraway, a young man from Minnesota, moves to New York in the summer of the 1922 to learn about the bond business. He rents house in the West Egg district of Long Island, a wealthy but unfashionable area populated by the new rich, a group who ..."
        )
        .padding()
    }
}

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
                        .frame(width: 88, height: 135)

                    Image(BookImage.isEmpty ? "mvc" : BookImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 87, height: 135)
                        .clipped()
                        .background(Color.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("Menlo", size: 16))

                    Text("By \(author)")
                        .font(.custom("Menlo", size: 12))
                        .italic()
                        .foregroundColor(.black)

                    Spacer().frame(height: 8)

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
                    print("Reserve button tapped")
                }) {
                    Text("Reserve")
                        .frame(width: 345, height: 49)
                        .background(Color(red: 255/255, green: 111/255, blue: 49/255))
                        .foregroundColor(.white)
                        .font(.headline)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.black, lineWidth: 1.25)
                        )
                }
                Spacer()
            }
            .padding(.top, 16)
        }
        .frame(width: 404, height: 250)
        .background(Color(red: 255/255, green: 239/255, blue: 210/255))
        .cornerRadius(0)
        .shadow(color: .black.opacity(0.5), radius: 0, x: 0, y: 1)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookCard_Previews: View {
    let books = Array(0..<10) // Example book array
    
    var body: some View {
        NavigationView {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(books.reversed(), id: \.self) { index in
                            BookCard(
                                BookImage: "",
                                title: "MVC Book \(index + 1)",
                                author: "R.S. Salaria",
                                description: "This is book number \(index + 1) explaining the MVC pattern."
                            )
                        }
                    }
                    .background(Color(red: 0.999, green: 0.935, blue: 0.823))
                    .padding()
                    .rotationEffect(.degrees(180)) // Flip content
                }
                .rotationEffect(.degrees(180)) // Flip scroll back
                .navigationTitle("Book List")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    // Optional: Auto-scroll to bottom if needed
                }
            }
        }
    }
//    .background(Color(red: 0.999, green: 0.935, blue: 0.823))
}

#Preview {
    BookCard_Previews()
}

//
//  MediaCarouselView.swift
//  CineStream
//
//  Created by Akash Ingawale on 24/05/25.
//

import SwiftUI

struct MediaCarouselView<T: Identifiable, Content: View>: View {

    // MARK: Properties

    let title: String
    let items: [T]
    let content: (T) -> Content

    // MARK: Inits

    init(title: String, items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.title = title
        self.items = items
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 16) {
                    ForEach(items) { item in
                        content(item)
                            .frame(width: 150)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
    }
}

struct PosterCard: View {

    // MARK: Properties

    let imageURL: URL?
    let title: String
    let rating: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: imageURL) { image in
                if let image = image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
            }
            .frame(width: 150, height: 225)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 4)

            Text(title)
                .font(.headline)
                .lineLimit(2)
                .padding(.top, 4)

            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(rating)
                    .font(.subheadline)
            }
        }
        .frame(width: 150)
    }
}

// Create a sample identifiable item for preview
private struct PreviewItem: Identifiable {
    let id = UUID()
}

// MARK: - Preview

#Preview {
    MediaCarouselView(title: "Now Playing", items: [PreviewItem()]) { _ in
        PosterCard(imageURL: nil, title: "Sample Movie Sample Movie  Sample Movie Sample Movie Sample Movie ", rating: "8.5")
        PosterCard(imageURL: nil, title: "Sample Movie", rating: "8.5")
    }
}

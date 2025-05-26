//
//  MovieDetailView.swift
//  CineStream
//
//  Created by Akash Ingawale on 24/05/25.
//

import SwiftUI

struct MovieDetailView: View {

    // MARK: - Properties

    let movie: Movie

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Backdrop image
                CachedAsyncImage(url: movie.backdropURL) { image in
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
                .frame(height: 220)
                .clipped()
                
                HStack(alignment: .top, spacing: 16) {
                    // Poster image
                    CachedAsyncImage(url: movie.posterURL) { image in
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
                    .frame(width: 120, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 4)
                    
                    // Movie info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(movie.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(movie.formattedRating)
                            Text("(\(movie.voteCount ?? 0) votes)")
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Release Date: \(movie.formattedReleaseDate)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // Overview
                VStack(alignment: .leading, spacing: 8) {
                    Text("Overview")
                        .font(.headline)
                    
                    Text(movie.overview)
                        .lineLimit(nil)
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        MovieDetailView(movie: Movie(
            id: 1,
            title: "Sample Movie",
            overview: "This is a sample movie overview that describes the plot of the movie. It's a long text that should wrap to multiple lines.",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2023-05-15",
            voteAverage: 8.5,
            voteCount: 1234,
            popularity: 123.4,
            genreIds: [28, 12, 14],
            adult: false,
            originalLanguage: "en",
            originalTitle: "Sample Movie",
            video: false
        ))
    }
}

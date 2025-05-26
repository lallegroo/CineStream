//
//  TVShowDetailView.swift
//  CineStream
//
//  Created by Akash Ingawale on 24/05/25.
//

import SwiftUI

struct TVShowDetailView: View {

    // MARK: - Properties

    let tvShow: TVShow

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedAsyncImage(url: tvShow.backdropURL) { image in
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
                    CachedAsyncImage(url: tvShow.posterURL) { image in
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
                    
                    // TV Show info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(tvShow.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(tvShow.formattedRating)
                            Text("(\(tvShow.voteCount ?? 0) votes)")
                                .foregroundColor(.secondary)
                        }
                        
                        Text("First Air Date: \(tvShow.formattedFirstAirDate)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // Overview
                VStack(alignment: .leading, spacing: 8) {
                    Text("Overview")
                        .font(.headline)
                    
                    Text(tvShow.overview)
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
                Text(tvShow.name)
                    .font(.headline)
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        TVShowDetailView(tvShow: TVShow(
            id: 1,
            name: "Sample TV Show",
            overview: "This is a sample TV show overview that describes the plot of the show. It's a long text that should wrap to multiple lines.",
            posterPath: nil,
            backdropPath: nil,
            firstAirDate: "2023-05-15",
            voteAverage: 8.5,
            voteCount: 1234,
            popularity: 123.4,
            genreIds: [28, 12, 14],
            adult: false,
            originalLanguage: "en",
            originalName: "Sample TV Show"
        ))
    }
}

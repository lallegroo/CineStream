//
//  MoviesView.swift
//  CineStream
//
//  Created by Akash Ingawale on 24/05/25.
//

import SwiftUI

struct MoviesView: View {

    // MARK: - Properties

    @StateObject private var viewModel = MoviesViewModel()

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading movies...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("Error loading movies")
                            .font(.headline)

                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button("Retry") {
                            viewModel.retryLoading()
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            MediaCarouselView(title: "Now Playing", items: viewModel.nowPlayingMovies) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    PosterCard(
                                        imageURL: movie.posterURL,
                                        title: movie.title,
                                        rating: movie.formattedRating
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }

                            MediaCarouselView(title: "Top Rated", items: viewModel.topRatedMovies) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    PosterCard(
                                        imageURL: movie.posterURL,
                                        title: movie.title,
                                        rating: movie.formattedRating
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }

                            MediaCarouselView(title: "Upcoming", items: viewModel.upcomingMovies) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    PosterCard(
                                        imageURL: movie.posterURL,
                                        title: movie.title,
                                        rating: movie.formattedRating
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Movies")
            .onAppear {
                if viewModel.nowPlayingMovies.isEmpty {
                    viewModel.loadAllMovies()
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MoviesView()
}

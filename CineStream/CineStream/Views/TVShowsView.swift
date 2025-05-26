//
//  TVShowsView.swift
//  CineStream
//
//  Created by Akash Ingawale on 24/05/25.
//

import SwiftUI

struct TVShowsView: View {

    // MARK: - Properties

    @StateObject private var viewModel = TVShowsViewModel()

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading TV shows...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("Error loading TV shows")
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
                            MediaCarouselView(title: "Airing Today", items: viewModel.airingTodayShows) { show in
                                NavigationLink(destination: TVShowDetailView(tvShow: show)) {
                                    PosterCard(
                                        imageURL: show.posterURL,
                                        title: show.name,
                                        rating: show.formattedRating
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            MediaCarouselView(title: "Popular", items: viewModel.popularShows) { show in
                                NavigationLink(destination: TVShowDetailView(tvShow: show)) {
                                    PosterCard(
                                        imageURL: show.posterURL,
                                        title: show.name,
                                        rating: show.formattedRating
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            MediaCarouselView(title: "Top Rated", items: viewModel.topRatedShows) { show in
                                NavigationLink(destination: TVShowDetailView(tvShow: show)) {
                                    PosterCard(
                                        imageURL: show.posterURL,
                                        title: show.name,
                                        rating: show.formattedRating
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("TV Shows")
            .onAppear {
                if viewModel.airingTodayShows.isEmpty {
                    viewModel.loadAllTVShows()
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TVShowsView()
}

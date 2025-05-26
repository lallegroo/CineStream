//
//  MoviesViewModel.swift
//  CineStream
//
//  Created by Akash Ingawale on 23/05/25.
//

import Foundation
import Combine

class MoviesViewModel: ObservableObject {

    // MARK: Properties

    @Published var nowPlayingMovies: [Movie] = []
    @Published var topRatedMovies: [Movie] = []
    @Published var upcomingMovies: [Movie] = []

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()

    // MARK: Public methods

    func loadAllMovies() {
        isLoading = true
        errorMessage = nil

        Publishers.Zip3(
            apiService.fetchNowPlayingMovies(),
            apiService.fetchTopRatedMovies(),
            apiService.fetchUpcomingMovies()
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.errorMessage = error.errorDescription
            }
        }, receiveValue: { [weak self] nowPlaying, topRated, upcoming in
            self?.nowPlayingMovies = nowPlaying.results
            self?.topRatedMovies = topRated.results
            self?.upcomingMovies = upcoming.results
        })
        .store(in: &cancellables)
    }

    func retryLoading() {
        loadAllMovies()
    }
}

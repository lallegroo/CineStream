//
//  TVShowsViewModel.swift
//  CineStream
//
//  Created by Akash Ingawale on 23/05/25.
//

import Foundation
import Combine

class TVShowsViewModel: ObservableObject {

    // MARK: Properties

    @Published var airingTodayShows: [TVShow] = []
    @Published var popularShows: [TVShow] = []
    @Published var topRatedShows: [TVShow] = []

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()

    // MARK: Public methods

    func loadAllTVShows() {
        isLoading = true
        errorMessage = nil

        Publishers.Zip3(
            apiService.fetchAiringTodayTVShows(),
            apiService.fetchPopularTVShows(),
            apiService.fetchTopRatedTVShows()
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.errorMessage = error.errorDescription
            }
        }, receiveValue: { [weak self] airingToday, popular, topRated in
            self?.airingTodayShows = airingToday.results
            self?.popularShows = popular.results
            self?.topRatedShows = topRated.results
        })
        .store(in: &cancellables)
    }

    func retryLoading() {
        loadAllTVShows()
    }
}

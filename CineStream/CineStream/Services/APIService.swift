//
//  APIService.swift
//  CineStream
//
//  Created by Akash Ingawale on 23/05/25.
//

import Foundation
import Combine

// MARK: - APIError

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        }
    }
}

// MARK: - Endpoint

enum Endpoint {
    // Movie endpoints
    case nowPlayingMovies
    case topRatedMovies
    case upcomingMovies

    // TV Show endpoints
    case airingTodayTVShows
    case popularTVShows
    case topRatedTVShows

    var path: String {
        switch self {
        case .nowPlayingMovies:
            return "/movie/now_playing"
        case .topRatedMovies:
            return "/movie/top_rated"
        case .upcomingMovies:
            return "/movie/upcoming"
        case .airingTodayTVShows:
            return "/tv/airing_today"
        case .popularTVShows:
            return "/tv/popular"
        case .topRatedTVShows:
            return "/tv/top_rated"
        }
    }
}

// MARK: - APIService

class APIService {

    // MARK: Properties

    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "64f4b379f9e39d07d22f544182381b89"

    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }

    // MARK: Public methods

    func fetch<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        guard var urlComponents = URLComponents(string: baseURL + endpoint.path) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US")
        ]

        guard let url = urlComponents.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { APIError.networkError($0) }
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return APIError.decodingError(decodingError)
                } else {
                    return error as? APIError ?? APIError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Movie Endpoints

extension APIService {
    func fetchNowPlayingMovies() -> AnyPublisher<MovieResponse, APIError> {
        return fetch(endpoint: .nowPlayingMovies)
    }

    func fetchTopRatedMovies() -> AnyPublisher<MovieResponse, APIError> {
        return fetch(endpoint: .topRatedMovies)
    }

    func fetchUpcomingMovies() -> AnyPublisher<MovieResponse, APIError> {
        return fetch(endpoint: .upcomingMovies)
    }
}

// MARK: - TV Show Endpoints

extension APIService {
    func fetchAiringTodayTVShows() -> AnyPublisher<TVShowResponse, APIError> {
        return fetch(endpoint: .airingTodayTVShows)
    }

    func fetchPopularTVShows() -> AnyPublisher<TVShowResponse, APIError> {
        return fetch(endpoint: .popularTVShows)
    }

    func fetchTopRatedTVShows() -> AnyPublisher<TVShowResponse, APIError> {
        return fetch(endpoint: .topRatedTVShows)
    }
}

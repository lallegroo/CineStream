//
//  TvShow.swift
//  CineStream
//
//  Created by Akash Ingawale on 23/05/25.
//

import Foundation

// MARK: - TVShowResponse

struct TVShowResponse: Codable {
    let page: Int
    let results: [TVShow]
    let totalPages: Int?
    let totalResults: Int?
    let dates: [String: String]?

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case dates
    }
}

// MARK: - TVShow

struct TVShow: Identifiable, Codable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double
    let genreIds: [Int]?
    let adult: Bool?
    let originalLanguage: String?
    let originalName: String?

    enum CodingKeys: String, CodingKey {
        case id, name, overview, popularity, adult
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalName = "original_name"
    }

    // MARK: - Computed Properties

    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath)")
    }

    var formattedFirstAirDate: String {
        guard let firstAirDate = firstAirDate else { return "Unknown" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: firstAirDate) else { return "Unknown" }

        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }

    var formattedRating: String {
        guard let voteAverage = voteAverage else { return "N/A" }
        return String(format: "%.1f", voteAverage)
    }
}

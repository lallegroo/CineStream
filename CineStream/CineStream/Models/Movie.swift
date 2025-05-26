//
//  Movie.swift
//  CineStream
//
//  Created by Akash Ingawale on 23/05/25.
//

import Foundation

// MARK: - MovieResponse

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
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

// MARK: - Movie

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double
    let genreIds: [Int]?
    let adult: Bool?
    let originalLanguage: String?
    let originalTitle: String?
    let video: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity, adult, video
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
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

    var formattedReleaseDate: String {
        guard let releaseDate = releaseDate else { return "Unknown" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate) else { return "Unknown" }

        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }

    var formattedRating: String {
        guard let voteAverage = voteAverage else { return "N/A" }
        return String(format: "%.1f", voteAverage)
    }
}

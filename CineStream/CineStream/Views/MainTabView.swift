//
//  MainTabView.swift
//  CineStream
//
//  Created by Akash Ingawale on 24/05/25.
//

import SwiftUI

struct MainTabView: View {

    // MARK: - Properties

    @State private var selectedTab = 0

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {
            MoviesView()
                .tabItem {
                    Label("Movies", systemImage: "film")
                }
                .tag(0)

            TVShowsView()
                .tabItem {
                    Label("TV Shows", systemImage: "tv")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
}

//
//struct MainTabView: View {
//
//    enum Tab: Int, CaseIterable {
//        case movies = 0
//        case tvShows
//        case settings
//
//        var title: String {
//            switch self {
//            case .movies: return "Movies"
//            case .tvShows: return "TV Shows"
//            case .settings: return "Settings"
//            }
//        }
//    }
//
//    @State private var selectedTab: Tab = .movies
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // Tab Bar
//            HStack {
//                ForEach(Tab.allCases, id: \.self) { tab in
//                    Button(action: {
//                        withAnimation {
//                            selectedTab = tab
//                        }
//                    }) {
//                        VStack(spacing: 4) {
//                            Text(tab.title)
//                                .fontWeight(selectedTab == tab ? .bold : .regular)
//                                .foregroundColor(.black)
//
//                            Rectangle()
//                                .frame(height: 2)
//                                .foregroundColor(selectedTab == tab ? .black : .clear)
//                                .padding(.horizontal, 10)
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//            }
//            .padding(.top)
//            .background(Color.white)
//
//            Divider()
//
//            Group {
//                switch selectedTab {
//                case .movies:
//                    MoviesView()
//                case .tvShows:
//                    TVShowsView()
//                case .settings:
//                    SettingsView()
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//    }
//}
//
//#Preview {
//    MainTabView()
//}


//struct MainTabView: View {
//    @State private var selectedTab = 0
//
//    var body: some View {
//        VStack {
//            Picker("Select Tab", selection: $selectedTab) {
//                Text("Movies").tag(0)
//                Text("TV Shows").tag(1)
//                Text("Settings").tag(2)
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//
//            Group {
//                switch selectedTab {
//                case 0:
//                    MoviesView()
//                case 1:
//                    TVShowsView()
//                case 2:
//                    SettingsView()
//                default:
//                    Text("Invalid Tab")
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//    }
//}
//
//#Preview {
//    MainTabView()
//}
//

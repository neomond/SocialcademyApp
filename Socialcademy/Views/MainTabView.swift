//
//  MainTabView.swift
//  Socialcademy
//
//  Created by Nazrin Atayeva on 09.10.24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PostsList()
                .tabItem {
                    Label("Posts", systemImage: "list.dash")
                }
            PostsList(viewModel: PostsViewModel(filter: .favorites))
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}

#Preview {
    MainTabView()
}

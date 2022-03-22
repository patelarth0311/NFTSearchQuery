//
//  Navigation.swift
//  NFTSearchQuery
//
//  Created by Arth Patel on 3/6/22.
//

import SwiftUI

struct Navigation: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SearchNft(selectedFilter: "") 
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        } // tab view
        .accentColor(.mint)
        
        
        
    }
}

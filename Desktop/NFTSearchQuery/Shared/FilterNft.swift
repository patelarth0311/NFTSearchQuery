//
//  FilterNft.swift
//  NFTSearchQuery
//
//  Created by Arth Patel on 3/13/22.
//

import SwiftUI

// Calls SearchNFT
struct FilterNft: View {
    var selectedFilter  : String
    var body: some View {
        VStack {
            SearchNft(selectedFilter : selectedFilter)
        }
    }
}





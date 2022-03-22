//
//  StoreFavoritedNFTs.swift
//  NFTSearchQuery
//
//  Created by Arth Patel on 3/14/22.
//

import Foundation



class FavoritedNFTs : ObservableObject {
    
    @Published var favorites: [Favorites] = [] // stores NFT the user has favorited by toggling on the star
    @Published var collection: [Favorites] = [] // stores NFT fetched from the API- handled by NFTAPICollectionHandler.swift

    static  let shared = FavoritedNFTs() // static object
    
    
    
}

        

struct Favorites : Identifiable, Codable {
    
    let id = UUID()
    var url: String
    var attributes: [Attribute]
    var contractAddress: String
    var tokenID: String
    var creatorName: String
    var tokenStandard: String
    var blockchain: String
    var symbol: String
    var toggle : Bool
    var transaction : [Transaction]? // Stores array of struct Transaction- see NFTTransactions.swift
  
    
}




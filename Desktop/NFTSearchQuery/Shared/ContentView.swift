//
//  ContentView.swift
//  Shared
//
//  Created by Arth Patel on 3/3/22.
//

import SwiftUI

struct ContentView: View {
    @State private var url = ""
    @State private var attributes = [Attribute]()
    @State private var  creatorName = ""
    @State private var  contractAddress = ""
    @State private var   tokenId = ""
    @State private var tokenStandard = ""
    @State private var blockchain = ""
    @State private var show = false
    @State private var ownerAddress = ""
    @State private var transaction = [Transaction]()
    @State private var  index = 0
    
    @ObservedObject   var nftCollections = GetCollectionNFT()
    @ObservedObject   var nftTransaction = GetNFTTransaction()
    @ObservedObject var nftDetails = NFTDetailRetriever()
    @ObservedObject var favoritedNFT = FavoritedNFTs.shared
    @ObservedObject var collection = FavoritedNFTs.shared
    
    @State private var toggled = false;
    
    
    struct Filter : Identifiable {
        var  id = UUID()
        var name: String
        var image : String
    }
    
    
    
    var filters = [Filter(name: "Contract Address", image: "point.3.connected.trianglepath.dotted"),
                   Filter(name: "Token ID", image: "wallet.pass"),
                   Filter(name: "Blockchain", image: "cube"),
                   Filter(name: "Creator", image: "paintpalette")] 
    
    
    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    ScrollView ( showsIndicators: false) {
                        VStack (alignment: .center, spacing: 10){
                            VStack  (alignment: .center , spacing: 13) {
                                ForEach(filters) { item in
                                    Filters(image:item.image, name: item.name )
                                        .background(.mint.opacity(0.06))
                                        .cornerRadius(30)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(Color.mint, lineWidth: 1)
                                        )
                                }
                            }
                            .padding()
                            LazyVGrid(columns: threeColumnGrid) {
                                if let info = favoritedNFT.favorites {
                                    ForEach(Array(info.enumerated()), id: \.offset) { index, item in
                                        VStack (alignment: .center){
                                            Button { // Toggling on a button will initalized declared variables to values stored in item, or favoritedNFT.favorites[index],
                                                // and will trigger fullScreenCover
                                                show.toggle()
                                                url = item.url
                                                attributes = item.attributes
                                                contractAddress = item.contractAddress
                                                tokenId = item.tokenID
                                                nftTransaction.load(tokenID: tokenId, contractAddress: contractAddress)
                                                nftDetails.load(tokenID: tokenId, contractAddress: contractAddress)
                                                toggled = item.toggle
                                                transaction  = nftTransaction.nftTransaction?.transactions ?? []
                                                ownerAddress = nftDetails.NFTdetails?.owner ?? ""
                                                creatorName = item.creatorName
                                                tokenStandard = item.tokenStandard
                                                blockchain = item.blockchain
                                                self.index = index
                                            } label: {
                                                VStack (alignment: .center){
                                                    GeometryReader { geometry in
                                                        
                                                        VStack (alignment: .center, spacing: 5) {
                                                            AsyncImage(url: URL(string: "\(item.url)"),
                                                                       content: { image in
                                                                image
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fill)
                                                                
                                                                
                                                                
                                                            }, placeholder: {
                                                                Color.gray
                                                            }
                                                            )
                                                            
                                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                                            .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 0)
                                                            
                                                            HStack (alignment: .center){
                                                                Text(item.symbol)
                                                                
                                                                    .foregroundColor(Color("Gray"))
                                                                    .font(.system(size: 14))
                                                                
                                                                Text(item.tokenID)
                                                                    .bold()
                                                                    .font(.system(size: 14))
                                                                    .foregroundColor(.mint)
                                                                Button {
                                                                    
                                                                    favoritedNFT.favorites.remove(at: index)
                                                                    contractAddress = item.contractAddress
                                                                    tokenId = item.tokenID
                                                                    
                                                                    if let toToggle =    collection.collection.firstIndex(where: {$0.tokenID == tokenId && $0.contractAddress == contractAddress }) {
                                                                        collection.collection[toToggle].toggle.toggle()
                                                                    } // Updates the value of toggle of the respective element that meets the where condition
                                                                    //in collection (var declared in StoreFavoritedNFTs)
                                                                    
                                                                } label : {
                                                                    Image(systemName:    "heart.fill" )
                                                                        .foregroundColor(.mint)
                                                                        .font(.system(size: 14))
                                                                }
                                                            }
                                                            
                                                        }
                                                        .padding()
                                                        
                                                    }
                                                }
                                                
                                                .frame(minWidth: geometry.size.width / 3 , maxWidth: .infinity, minHeight: geometry.size.width / 3   )
                                                
                                                
                                            }
                                            .fullScreenCover(isPresented: $show) {// if true
                                                VStack {
                                                    SpecificNftView(close: $show, nftImageUrl: url, creatorName: creatorName, attributes: attributes, contractAddress: contractAddress, tokenId: tokenId, tokenStandard: tokenStandard, blockchain: blockchain, transaction: transaction,ownerAddress: ownerAddress)
                                                }
                                            }
                                        }
                                        
                                        
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Watchlist")
        }
    }
    
    
    
    
    
    
    
}

// Creates the four navigation links that appear at the top of this view
// Toggling on a link will trigger a call to FilterNFT and value of the argument passed
// is used to determine how to fliter favorites (var declared in StoreFavoritedNFTs)
struct Filters : View {
    
    var image : String
    var name : String
    
    var body: some View {
        NavigationLink(destination:  FilterNft(selectedFilter: name)) {
            VStack (alignment: .center){
                HStack (alignment: .center) {
                    Image(systemName: image)
                        .foregroundColor(.mint)
                        .font(.system(size: 30))
                    Text(name)
                        .font(.system(size: 15, weight: .medium, design: .default))
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.mint)
                        .font(.system(size: 30))
                }
                .padding()
                
            }
        }
    }
    
    
}


//
//  SearchNft.swift
//  NFTSearchQuery
//
//  Created by Arth Patel on 3/7/22.
//

import SwiftUI

struct SearchNft: View {
    
    
    @State var searchText = ""
    @State  var show = false
    @State  var toggleStar = false
    @State  var url = ""
    @State  var attributes = [Attribute]()
    @State var transaction = [Transaction]()
    @ObservedObject var nftDetails = NFTDetailRetriever()
    
    @State  var  creatorName = ""
    @State  var ownerAddress = ""
    @State var  contractAddress = ""
    @State  var   tokenId = ""
    @State  var tokenStandard = ""
    @State var blockchain = ""
    
    @State var toggled = false
    @State var showSheet = false;
    
    @ObservedObject var collection = FavoritedNFTs.shared // Stores the reference to FavoritedNFTs and is used to call collection (declared in StoreFavoritedNFTS)
    
    @ObservedObject var favoritedNFT = FavoritedNFTs.shared  // Stores the reference to FavoritedNFTs and is used to call variable (declared in StoreFavoritedNFTS)
    
    var selectedFilter : String
    
    @State var index = 0;
    @ObservedObject  var nftTransaction = GetNFTTransaction()
    
    var gridItemLayout = [GridItem(.adaptive(minimum:  198.0, maximum: 340)), GridItem(.adaptive(minimum:  198.0, maximum: 360))]
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ScrollView ( showsIndicators: false){
                    LazyVGrid(columns:  geo.size.width  > 1180 ? gridItemLayout : [GridItem(.adaptive(minimum:  198.0, maximum: 360))],spacing: 20) {
                        
                        
                        
                        if let info = collection.collection
                        {
                            
                            ForEach(Array((selectedFilter == "" ? collection.collection : favoritedNFT.favorites).filter({searchText.isEmpty ? true :  selectedFilter == "Contract Address" ?
                                $0.contractAddress.contains(searchText) : selectedFilter == "Token ID" ? $0.tokenID.contains(searchText) : selectedFilter == "Blockchain" ? $0.blockchain.lowercased().contains(searchText.lowercased()) : selectedFilter == "Creator" ? $0.creatorName.lowercased().contains(searchText.lowercased()) :
                                ( $0.contractAddress.contains(searchText)  || $0.tokenID.contains(searchText)  || $0.blockchain.lowercased().contains(searchText.lowercased())
                                  || $0.creatorName.lowercased().contains(searchText.lowercased()))
                                
                                
                                
                            }).enumerated()), id: \.offset) { index, item in
                                
                                VStack {
                                    ZStack {
                                        Button { // On toggled, the variables are initialized to the values of the variables under the Favorites struct at the associative
                                            //index (same index as the button appears on the grid)
                                            
                                            
                                            show.toggle()
                                            url = item.url
                                            attributes = item.attributes
                                            contractAddress = item.contractAddress
                                            tokenId = item.tokenID
                                            
                                            nftTransaction.load(tokenID: tokenId, contractAddress: contractAddress)
                                            nftDetails.load(tokenID: tokenId, contractAddress: contractAddress)
                                            transaction = nftTransaction.nftTransaction?.transactions ?? []
                                            ownerAddress = nftDetails.NFTdetails?.owner ?? ""
                                            creatorName = item.creatorName
                                            tokenStandard = item.tokenStandard
                                            blockchain = item.blockchain
                                           
                                            
                                        } label : {
                                            
                                            NFTViewController(imageUrl: item.url )
                                                .frame(width: (( geo.size.width * 0.5) < 198.0) ? geo.size.width * 0.5 : 198.0,
                                                       height:  ( geo.size.height * 0.65 < 245.05) ? geo.size.height * 0.65 : 245.05 , alignment: .center)
                                                .cornerRadius(30)
                                                .shadow(color:  Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 0)
                                        }
                                        
                                        .fullScreenCover(isPresented: $show) { // if true, initialized variables are passed as arguments to the SpecificNFTView call
                                            VStack {
                                                SpecificNftView(close: $show, nftImageUrl: url, creatorName: creatorName, attributes: attributes, contractAddress: contractAddress, tokenId: tokenId, tokenStandard: tokenStandard, blockchain: blockchain, transaction: transaction,ownerAddress: ownerAddress)
                                            }
                                        }
                                        
                                        HStack {
                                            VStack (alignment: .leading){
                                                Text(item.creatorName)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 13))
                                                Text(item.tokenID)
                                                    .bold()
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.mint)
                                            }
                                            
                                            collection.collection[index].toggle  ? // Ternary operator to determine which systemName is used and the function of the button
                                            
                                            Button {
                                                
                                                contractAddress = item.contractAddress
                                                tokenId = item.tokenID
                                                collection.collection[index].toggle.toggle()
                                                if let toDelete =   favoritedNFT.favorites.firstIndex(where: {$0.tokenID == tokenId && $0.contractAddress == contractAddress }) {
                                                    favoritedNFT.favorites.remove(at: toDelete)
                                                }
                                                
                                            } label : {
                                                Image(systemName:   "heart.fill")
                                                    .foregroundColor(.mint)
                                                    .font(.system(size: 20))
                                            } // If true, this button appears. If toggled and if let passes, the appropriate element is removed from favorites
                                            
                                            :
                                            Button { // If false, this button appears. On toggled, declared variables are initialized to values stored at
                                                // collection.collection[index] and passed as arguments in a call to Favorites by favorites
                                                
                                                nftTransaction.load(tokenID: tokenId, contractAddress:      contractAddress)
                                                nftDetails.load(tokenID: tokenId, contractAddress: contractAddress)
                                                
                                                url = item.url
                                                attributes = item.attributes
                                                contractAddress = item.contractAddress
                                                tokenId = item.tokenID
                                                self.index = index
                                                transaction = nftTransaction.nftTransaction?.transactions ?? []
                                                ownerAddress = nftDetails.NFTdetails?.owner ?? ""
                                                creatorName = item.creatorName
                                                tokenStandard = item.tokenStandard
                                                blockchain = item.blockchain
                                                
                                                collection.collection[index].toggle.toggle()
                                                
                                                toggled = collection.collection[index].toggle
                                                
                                                
                                                
                                                favoritedNFT.favorites.append(Favorites(url: url, attributes: attributes, contractAddress: contractAddress, tokenID: tokenId, creatorName: creatorName, tokenStandard: tokenStandard, blockchain: blockchain, symbol: item.symbol , toggle: true,transaction: transaction ))
                                                
                                            } label : {
                                                Image(systemName:   "heart")
                                                    .foregroundColor(.mint)
                                                    .font(.system(size: 20))
                                            }
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                                        .padding()
                                        .padding(.bottom, 5)
                                    }
                                }
                                
                            }
                        }
                    }
                }
                
                .searchable(text: $searchText,  placement: .navigationBarDrawer(displayMode: .always), prompt: selectedFilter == "" ?  "Search a NFT" : "Search a NFT by \(selectedFilter)")
                .navigationBarTitle(selectedFilter == "" ? "Search" : "NFTs by \(selectedFilter)")
                .navigationBarItems(trailing:
                                        
                                        VStack {
                    Spacer()
                    Button {
                        showSheet.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .imageScale(.large)
                            Text("Add Collection")
                                .font(.system(size: 15, weight: .regular, design: .default))
                        }
                        
                    }
                    
                    .sheet(isPresented: $showSheet) {
                        AddCollectionView()
                    }
                }
                    .padding()
                )
                
            }
            
        }
    }}




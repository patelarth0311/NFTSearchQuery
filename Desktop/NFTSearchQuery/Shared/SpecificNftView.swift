//
//  SpecificNftView.swift
//  NFTSearchQuery
//
//  Created by Arth Patel on 3/7/22.
//

import SwiftUI

struct SpecificNftView: View {
    
    @Binding var close : Bool // Used to determine when to close the view
    var nftImageUrl : String
    var creatorName : String
    var attributes: [Attribute]
    var contractAddress: String
    var tokenId: String
    var tokenStandard : String
    var blockchain : String
    var transaction: [Transaction]
    var ownerAddress: String
   

    
    
    var body: some View {
        VStack {
            HStack {
                VStack (alignment: .leading,spacing: 15){
                    Text(creatorName)
                        .font(.title2)
                        .bold()
                    Text("#\(tokenId)")
                        .font(.largeTitle)
                        .bold()
                }
                Spacer()
                Button { // The button that closes the full screen cover view
                    close.toggle()
                } label: {
                    VStack (alignment: .center) {
                        
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.mint)
                            .font(.system(size: 30))
                    }
                }
            }
            .padding()
            Rectangle()
                .fill(Color.mint)
                .frame(maxWidth: .infinity, maxHeight: 0.5)
        }
        .background(.mint.opacity(0.1))
        GeometryReader { geo in
            ZStack {
                ScrollView (showsIndicators: false){
                    VStack (alignment: .center, spacing: 15){
                        VStack   (alignment: .center, spacing: 20){
                            AsyncImage(url: URL(string: "\(nftImageUrl)"),
                                       content: { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fit)
                            }, placeholder: {
                                Color.gray
                            }
                            )
                                .padding()
                                .frame(width: geo.size.width , height: geo.size.width)
                            HStack (alignment: .bottom){
                                Text("Owned by ")
                                    .font(.system(size: 15))
                                Link(destination:URL(string: "https://opensea.io/\(ownerAddress)")!) {
                                    
                                    Text("\(ownerAddress.prefix(6) + "..." + ownerAddress.suffix(4))")
                                        .font(.system(size: 15))
                                        .bold()
                                        .foregroundColor(.mint)
                                }
                             
                            }
                            Price(width: geo.size.width * 0.8, height: 200, tokenID: tokenId,contractAddress: contractAddress)
                        }
                        VStack (alignment: .center, spacing: geo.size.height/10){
                            VStack ( alignment: .leading, spacing: 10) {
                                Text("Description")
                                    .font(.title)
                                    .bold()
                                HStack {
                                    Text("Created by \(creatorName)")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                            }
                            VStack (alignment: .leading){
                                Text("Properties")
                                    .font(.title)
                                    .bold()
                                LazyVGrid(columns:   [GridItem(.adaptive(minimum: geo.size.width/3 ))],spacing: 0) {
                                    ForEach(attributes) { item in
                                        Properties(trait: item.trait_type, value: item.value, width: geo.size.width/3,
                                                   height: geo.size.height/7)
                                    } // Transversing through attributes which is of type [Attribute] and passes it's struct variables as arguments to the Properties struct.
                                    // More information on this struct is in NFTAPICollectionHandler
                                }
                            }
                            
                            VStack (alignment: .center){
                                HStack {
                                    
                                    Text("Details")
                                        .font(.title)
                                        .bold()
                                    Spacer()
                                }
                                Details( tokenId: tokenId, tokenStandard: tokenStandard, blockchain: blockchain, contractAddress: contractAddress ,width: geo.size.width * 0.8, height: 200)
                            }
                            VStack {
                                HStack {
                                    Text("Transaction History")
                                        .font(.title)
                                        .bold()
                                    Spacer()
                                }
                                Activity(transactions: transaction)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}


// Displays properties of the NFT
struct Properties : View {
    var trait: String
    var value: String
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        VStack {
            PropertiesContainer(trait: trait, value: value, width: width, height: height)
        }
    }
}

// Displays all properties of the NFT in styled containers, or rectangles
struct PropertiesContainer : View {
    var trait: String
    var value: String
    var width: CGFloat
    var height: CGFloat
    var body : some View {
        VStack  (alignment: .center, spacing: 10) {
            Text(trait.uppercased())
                .foregroundColor(Color.mint)
                .font(.system(size: 11, weight: .bold, design: .default))
                .fontWeight(.semibold)
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .default))
            
        }
        .frame(width: width+30, height: height+30, alignment: .center)
        .background(Color.mint.opacity(0.06))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mint, lineWidth: 1)
        )
        .padding(13)
    }
}

// Displays details of the NFT
struct Details : View {
    var tokenId: String
    var tokenStandard : String
    var blockchain : String
    var contractAddress: String
    var width: CGFloat
    var height: CGFloat
    var body : some View {
        HStack {
            VStack  (alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "point.3.connected.trianglepath.dotted")
                        .font(.system(size: 24))
                        .foregroundColor(.mint)
                    Text("Contract Address")
                        .font(.system(size: 15, weight: .bold, design: .default))
                    
                    Spacer()
                    Link(destination: URL(string: "https://etherscan.io/address/\(contractAddress)")!) {
                        Text(contractAddress.prefix(5) + "..." + contractAddress.suffix(5))
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .foregroundColor(.mint)
                    }
                }
                HStack {
                    Image(systemName: "wallet.pass")
                        .font(.system(size: 24))
                        .foregroundColor(.mint)
                    Text("Token ID")
                        .font(.system(size: 15, weight: .bold, design: .default))
                    Spacer()
                    Text(tokenId)
                        .font(.system(size: 15, weight: .bold, design: .default))
                }
                HStack {
                    Image(systemName: "doc")
                        .font(.system(size: 24))
                        .foregroundColor(.mint)
                    Text("Token Standard")
                        .font(.system(size: 15, weight: .bold, design: .default))
                    Spacer()
                    Text(tokenStandard)
                        .font(.system(size: 15, weight: .bold, design: .default))
                }
                HStack {
                    Image(systemName: "cube")
                        .font(.system(size: 24))
                        .foregroundColor(.mint)
                    Text("Blockchain")
                        .font(.system(size: 15, weight: .bold, design: .default))
                    Spacer()
                    Text(blockchain)
                        .font(.system(size: 15, weight: .bold, design: .default))
                }
            }
        }
        .padding()
        .frame(width: width, height: height, alignment: .center)
        .background(Color.mint.opacity(0.06))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mint, lineWidth: 1)
        )
        .padding(15)
    }
}

// Displays a link
struct Price : View {
    var width: CGFloat
    var height: CGFloat
    var tokenID : String
    var contractAddress : String
    var body : some View {
        VStack (alignment: .leading, spacing: 10){
            HStack {
                Link(destination: URL(string: "https://opensea.io/\(contractAddress)/\(tokenID)")!) {
                    Text("Buy on OpenSea")
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
            }
            .frame(width: width, height: 60, alignment: .center)
            .background(Color.mint.opacity(1))
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.mint, lineWidth: 1)
            )
            Spacer()
        }
        .padding(12)
    }
}

// Displays the transactions of the NFT
struct Activity : View {
    var transactions: [Transaction]
    var gridItemLayout = [GridItem(.adaptive(minimum: 400)), GridItem(.adaptive(minimum: 400)),GridItem(.adaptive(minimum: 400)) , GridItem(.adaptive(minimum: 400))]
    var body: some View {
        ScrollView (.horizontal,showsIndicators: false) {
            VStack (alignment: .leading){
                HStack (alignment: .center, spacing: 10){
                    Text("Event")
                        .frame(width: 110, height: 10, alignment: .leading)
                    Text("Price")
                        .frame(width: 110, height: 10, alignment: .leading)
                    Text("From")
                        .frame(width: 200, height: 10,alignment: .leading)
                    Text("To")
                        .frame(width: 200, height: 10,alignment: .leading)
                    Text("Date")
                        .frame(width: 200, height: 10, alignment: .leading)
                    
                }
                .padding(16)
                .font(.system(size: 15, weight: .bold, design: .default))
                
                
                ForEach(transactions) { item in
                    HStack (alignment: .center, spacing: 10){
                        HStack {
                            Image(systemName: "\(item.type != nil ? item.type == "cancel_list" ? "xmark.bin.circle" : item.type == "bid" ? "hand.raised.circle" : item.type == "sale" ? "cart.circle" : item.type == "mint" ? "bag.circle" : "arrow.left.arrow.right.circle" : ""  )")
                                .foregroundColor(.mint)
                                .font(.system(size: 24))
                            Text("\(item.type != nil ?  item.type == "cancel_list" ? "Canceled" : item.type?.capitalized as! String : "" )")
                        }
                        .frame(width: 110, height: 10, alignment: .leading)
                        Text("\(item.priceDetails?.priceUsd ?? 0.0, specifier: "%.2f")")
                            .frame(width: 110, height: 10, alignment: .leading)
                        Link(destination: URL(string: "https://opensea.io/\(item.type == "bid" ? item.bidderAddress  ?? "" : item.type == "sale" ? item.buyerAddress ?? "" : item.type == "mint"  ?  "NullAddress" :  item.transferFrom ?? "" )")!) {
                            
                            Text("\(item.type == "bid" ? item.bidderAddress ?? "" : item.type == "sale" ? item.buyerAddress ?? "" : item.type == "mint"  ?  "NullAddress" :  item.transferFrom ?? "" )")
                                .foregroundColor(.mint)
                        }
                        .frame(width: 200, height: 10,alignment: .leading)
                        
                        Link(destination: URL(string: "https://opensea.io/\( item.type == "bid" ? "" : item.type == "sale" ? item.sellerAddress ?? "" : item.type == "mint"  ?  item.ownerAddress ?? "" :  item.transferTo ?? "" )")!) {
                            
                            Text("\( item.type == "bid" ? "" : item.type == "sale" ? item.sellerAddress ?? "" : item.type == "mint"  ?  item.ownerAddress ?? "" :  item.transferTo ?? "" )")
                                .foregroundColor(.mint)
                        }
                        .frame(width: 200, height: 10, alignment: .leading)
                        Text("\(item.transactionDate?.replacingOccurrences(of: "T", with: " ") ?? "" )")
                            .frame(width: 200, height: 10, alignment: .leading)
                    }
                    .padding(16)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .foregroundColor(Color("Gray"))
                    VStack {
                        Rectangle()
                            .fill(Color.mint)
                            .frame(maxWidth: .infinity, maxHeight: 1, alignment: .bottom)
                    }
                    
                }
            }
        }
        .font(.system(size: 14, weight: .medium, design: .default))
        .foregroundColor(Color("Gray"))
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mint, lineWidth: 1)
            
        )
        .background(.mint.opacity(0.06))
    }
}

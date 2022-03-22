//
//  AddCollectionView.swift
//  NFTSearchQuery
//
//  Created by Arth Patel on 3/16/22.
//

import SwiftUI

struct AddCollectionView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var address: String = ""
    

    
    @ObservedObject   var nftCollections = GetCollectionNFT()
    var body: some View {
      
            HStack {
                Spacer()
                Button { // dismisses the sheet view
                   dismiss()
                } label: {
                    VStack (alignment: .center) {
                        
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.mint)
                            .font(.system(size: 30))
                    }
                }
                .padding()
            }
        
        VStack (alignment: .leading)  {
            
           Text("Add Collection")
                .bold()
                .font(.largeTitle)
        
            
            TextField("Enter a contract address", text: $address)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.mint.opacity(0.06))
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.mint, lineWidth: 1)
                )
                .onSubmit {
                    nftCollections.load(contractAddress: address)
                    
                    dismiss()
                }
            Suggestions(address: $address)
            
           
    }
        .padding()
        Spacer()
}
}
    


struct Suggestions: View {
    
    var suggestions = ["0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D","0x60E4d786628Fea6478F785A6d7e704777c86a7c6",
    "0x7Bd29408f11D2bFC23c34f18275bBf23bB716Bc7","0xf76179bb0924BA7da8E7b7Fc2779495D7A7939d8"]
    
    @Binding var address: String
    var body: some View {
        VStack (alignment: .leading, spacing: 10){
           Text("Suggestions")
                
                .bold()
                .font(.title2)
        
            
            VStack (alignment: .center, spacing: 10){
                ForEach(suggestions, id: \.self) { item in
                    
                    Button {
                        address = item
                       
                    } label : {
                       Text(item)
                            .foregroundColor(.mint)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.mint.opacity(0.06))
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.mint, lineWidth: 1)
                            )
                    }
                    
                } // end of foreach
                Link(destination: URL(string: "https://opensea.io/explore-collections")!) {
                    HStack  {
                        Image(systemName: "link")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Text("Find a collection on OpenSea")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .bold()
                    }
                   
                        
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.mint.opacity(1))
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.mint, lineWidth: 1)
                )
            }
              
            
           
        
      
       
        }
        
        
        
    }
}

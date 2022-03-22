//
//  NFTViewController.swift
//  NFTSearchQuery
//
//  Created by Arth Patel on 3/6/22.
//

import UIKit
import SwiftUI

// Makes a call to NFTCollectionView and passes in a single argument that is passed in in SearchNFT.swift at line 85
struct NFTViewController: UIViewControllerRepresentable {
    
    var imageUrl : String
    
    func makeUIViewController(context: Context) -> NFTCollectionView {
        
        
        return NFTCollectionView(imageUrl : imageUrl)
    }
    
    
    func updateUIViewController(_ uiViewController: NFTCollectionView, context: Context) {
        
    }
}

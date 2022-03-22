//
//  NFTCollectionView.swift
//  NFTSearchQuery
//
//  Created by Arth Patel on 3/6/22.
//

import UIKit
import SwiftUI

// Fetches an image using a url and styles the image's view
class NFTCollectionView: UIViewController {

   
    var imageUrl : String
    
    
    
    init( imageUrl : String) {
        self.imageUrl =  imageUrl // stores url of image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 35, y: 30, width: 130, height: 130))
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.15
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowRadius = 10
        return imageView
    }()
    
 
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
      
        view.addSubview(imageView)
       
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       
       
        fetchNFTImage(imageUrl: imageUrl)
        
    }
    
  
    private func fetchNFTImage(imageUrl : String) { // Fetching the image and styling it's background (view)
        
        guard let urls = URL(string: imageUrl) else {
          
            return
        }
        
        let getDataTask = URLSession.shared.dataTask(with: urls, completionHandler: {data,  _, error in
            
            guard let data = data, error == nil else {
               
                return
            }
            
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                let uiColor = UIImage(data: data)?.averageColor ?? .clear
                self.view.backgroundColor = uiColor
                self.view.layer.cornerRadius = 30
                self.view.clipsToBounds = true
                self.imageView.image = image
            }
          
        })
        getDataTask.resume()
      
        
       
        
        
    }
  
}



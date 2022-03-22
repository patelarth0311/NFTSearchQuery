//
//  NFTAPICollectionHandler.swift
//  NFTSearchQuery
//
//  Created by Arth Patel on 3/4/22.
//

import Foundation



public class GetCollectionNFT : ObservableObject {
    
    @Published var nftCollection  : NFTCollection?
    
    func load(contractAddress: String) {
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "9475e5a2-c333-4f24-96a0-3a1beb16f35d"
        ]
        
        let decoder = JSONDecoder()
        
        let request = NSMutableURLRequest(url: NSURL(string:  "https://api.nftport.xyz/v0/nfts/\(contractAddress)?chain=ethereum&include=all")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
            
            
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            if let  getnfts = try? decoder.decode(NFTCollection.self, from: data) {
                DispatchQueue.main.async {
                    self.nftCollection  = getnfts
                    print(getnfts)
                    for item in getnfts.nfts {
                        if (item.cachedFileURL?.isEmpty == false) {
                            
                            
                            FavoritedNFTs.shared.collection.append(Favorites(url: item.cachedFileURL ?? "", attributes: item.metadata?.attributes ?? [], contractAddress: contractAddress, tokenID: item.tokenID, creatorName: getnfts.contract.name, tokenStandard: getnfts.contract.type, blockchain: item.chain.rawValue, symbol: getnfts.contract.symbol, toggle: false))
                        }
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                
            }
            
            
            
            
        })
        
        dataTask.resume()
        
        
        
        
        
    }
}



// MARK: - Contract
struct NFTCollection: Codable {
    let response: String
    let nfts: [Nft]
    let contract: Contract
    let total: Int
    let owner: String?
}

// MARK: - Contract
struct Contract: Codable {
    let name, symbol, type: String
}

// MARK: - Nft
struct Nft: Codable, Identifiable {
    let chain: Chain
    
    let tokenID: String
    let metadata: Metadata?
    let metadataURL: String?
    let fileURL: String?
    let cachedFileURL: String?
    let mintDate: String?
    let fileInformation: FileInformation?
    let updatedDate: String
    var id = UUID()
    
    
    enum CodingKeys: String, CodingKey {
        case chain
        
        case tokenID = "token_id"
        case metadata
        case metadataURL = "metadata_url"
        case fileURL = "file_url"
        case cachedFileURL = "cached_file_url"
        case mintDate = "mint_date"
        case fileInformation = "file_information"
        case updatedDate = "updated_date"
    }
}

enum Chain: String, Codable {
    case ethereum = "ethereum"
}



// MARK: - FileInformation
struct FileInformation: Codable {
    let height, width, fileSize: Int
    
    enum CodingKeys: String, CodingKey {
        case height, width
        case fileSize = "file_size"
    }
}

// MARK: - Metadata
struct Metadata: Codable {
    let attributes: [Attribute]
    let image: String
    
    
}

// MARK: - Attribute
struct Attribute: Codable, Identifiable {
    var id = UUID()
    let trait_type: String
    let value: String
    
    
    enum CodingKeys: String, CodingKey {
        case trait_type
        case value
    }
}


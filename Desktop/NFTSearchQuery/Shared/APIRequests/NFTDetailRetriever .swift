//
//  NFTDetailRetriever .swift
//  NFTSearchQuery
//
//  Created by Arth Patel on 3/11/22.
//

import Foundation







public class NFTDetailRetriever : ObservableObject {
    
    
    
    
    @Published var NFTdetails  : NFTDetails?
     
  
    
    func load(tokenID: String, contractAddress: String) {
        
        let headers = [
          "Content-Type": "application/json",
          "Authorization": "9475e5a2-c333-4f24-96a0-3a1beb16f35d"
        ]

        let decoder = JSONDecoder()
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.nftport.xyz/v0/nfts/\(contractAddress)/\(tokenID)?chain=ethereum")! as URL,
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
                              if let  getnfts = try? decoder.decode(NFTDetails.self, from: data) {
                              DispatchQueue.main.async {
                                  self.NFTdetails  = getnfts
                            
                                  }
                                  
                          }
                         
           
           
    
        })

        dataTask.resume()
        
        
        
        
        
}
}


struct NFTDetails: Codable {
    let response: String
    let nft: Nft3
    let owner: String
    let contract: Contract3

}

// MARK: - Contract
struct Contract3: Codable {
    let name, symbol, type: String
}

// MARK: - Nft
struct Nft3: Codable {
    let chain, contractAddress, tokenID: String
    let metadataURL: String
    let metadata: Metadata2
    let fileInformation: FileInformation2
    let fileURL: String
    let cachedFileURL: String
    let mintDate, updatedDate: String

    enum CodingKeys: String, CodingKey {
        case chain
        case contractAddress = "contract_address"
        case tokenID = "token_id"
        case metadataURL = "metadata_url"
        case metadata
        case fileInformation = "file_information"
        case fileURL = "file_url"
        case cachedFileURL = "cached_file_url"
        case mintDate = "mint_date"
        case updatedDate = "updated_date"
    }
}

// MARK: - FileInformation
struct FileInformation2: Codable {
    let height, width, fileSize: Int

    enum CodingKeys: String, CodingKey {
        case height, width
        case fileSize = "file_size"
    }
}

// MARK: - Metadata
struct Metadata2: Codable {
    let attributes: [Attribute2]
    let image: String
}

// MARK: - Attribute
struct Attribute2: Codable {
    let traitType, value: String

    enum CodingKeys: String, CodingKey {
        case traitType = "trait_type"
        case value
    }
}

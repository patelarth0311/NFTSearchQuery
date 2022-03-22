import Foundation


public class GetNFTTransaction : ObservableObject {
    
    
    
    
    @Published var nftTransaction  : NFTTransaction?
     
  
    
    func load(tokenID: String, contractAddress: String) {
        
        let headers = [
          "Content-Type": "application/json",
          "Authorization": "9475e5a2-c333-4f24-96a0-3a1beb16f35d"
        ]

        let decoder = JSONDecoder()
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.nftport.xyz/v0/transactions/nfts/\(contractAddress)/\(tokenID)?chain=ethereum&type=all")! as URL,
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
                              if let  getnfts = try? decoder.decode(NFTTransaction.self, from: data) {
                              DispatchQueue.main.async {
                                  self.nftTransaction  = getnfts
                         
                                  }
                                  
                          }
                         
           
           
    
        })

        dataTask.resume()
        
        
        
        
        
}
}


struct NFTTransaction: Codable {
    let response: String
    let transactions: [Transaction]
}


// MARK: - Transaction
struct Transaction: Codable, Identifiable {
    let type, listerAddress: String?
    let nft: Nft2?
    let priceDetails: PriceDetails?
    let transactionHash, blockHash: String?
    let blockNumber: Int?
    var transactionDate: String?
    let marketplace: Marketplace?
    let bidderAddress: String?
    let quantity: Int?
    let transferFrom, transferTo: String?

    let tokenID, buyerAddress, sellerAddress, ownerAddress: String?
    var id = UUID()

    enum CodingKeys: String, CodingKey {
        case type
        case listerAddress = "lister_address"
        case nft
        case priceDetails = "price_details"
        case transactionHash = "transaction_hash"
        case blockHash = "block_hash"
        case blockNumber = "block_number"
        case transactionDate = "transaction_date"
        case marketplace
        case bidderAddress = "bidder_address"
        case quantity
        case transferFrom = "transfer_from"
        case transferTo = "transfer_to"
      
        case tokenID = "token_id"
        case buyerAddress = "buyer_address"
        case sellerAddress = "seller_address"
        case ownerAddress = "owner_address"
    }
}



enum Marketplace: String, Codable {
    case opensea = "opensea"
}

// MARK: - Nft
struct Nft2: Codable {
    let contractType: ContractType?
    let tokenID: String?

    enum CodingKeys: String, CodingKey {
        case contractType = "contract_type"
      
        case tokenID = "token_id"
    }
}

enum ContractType: String, Codable {
    case erc721 = "ERC721"
}

// MARK: - PriceDetails
struct PriceDetails: Codable {
    let assetType: AssetType?
    let contractAddress: String?
    let price, priceUsd: Double?

    enum CodingKeys: String, CodingKey {
        case assetType = "asset_type"
        case contractAddress = "contract_address"
        case price
        case priceUsd = "price_usd"
    }
}

enum AssetType: String, Codable {
    case erc20 = "ERC20"
    case eth = "ETH"
}

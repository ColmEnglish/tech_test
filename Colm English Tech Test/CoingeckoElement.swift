// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let coingecko = try? newJSONDecoder().decode(Coingecko.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCoingeckoElement { response in
//     if let coingeckoElement = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - CoingeckoElement
struct CoingeckoElement: Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank: Int
    let fullyDilutedValuation: Int?
    let totalVolume, high24H, low24H, priceChange24H: Double
    let priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H, circulatingSupply: Double
    let totalSupply, maxSupply: Double?
    let ath, athChangePercentage: Double
    let athDate: String
    let atl, atlChangePercentage: Double
    let atlDate: String
    let roi: Roi?
    let lastUpdated: String

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case roi
        case lastUpdated = "last_updated"
    }
}


class CryptoDataModel{
    
    static let sharedInstance = CryptoDataModel()
    
    static var coinData: Coingecko = []

    
    static func getCryptoData(){
        
        // Full URL including parameters: https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap _desc&per_page=100&page=1&sparkline=false
        AF.request("https://api.coingecko.com/api/v3/coins/markets", method: .get, parameters: ["vs_currency":"eur","order":"market_cap"], encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .responseData { response in
                
                //Debug to check raw json return
//                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                    print("Data: \(utf8Text)")
//                }
                
                switch response.result {
                case .failure(let error):
                    print(error)
                    NotificationCenter.default.post(name: Notification.Name.dataFailed, object: nil)
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(Coingecko.self, from: data)
                        coinData.removeAll()
                        coinData.append(contentsOf: result)
                        print(result)
                        NotificationCenter.default.post(name: Notification.Name.dataUpdated, object: nil)
                    } catch {
                        print(error)
                        NotificationCenter.default.post(name: Notification.Name.dataFailed, object: nil)
                    }
                }
            }
    }
    
    
}



// MARK: - Roi
struct Roi: Codable {
    let times: Double?
    let currency: String?
    let percentage: Double?
}

typealias Coingecko = [CoingeckoElement]

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

//MARK: - Notification names for updates
extension Notification.Name {
    static let dataUpdated = Notification.Name("DataUpdated")
    static let dataFailed = Notification.Name("DataFailed")
}


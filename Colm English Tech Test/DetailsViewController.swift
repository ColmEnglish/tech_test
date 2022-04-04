//
//  DetailsViewController.swift
//  Colm English Tech Test
//
//  Created by Colm English on 03/04/2022.
//

import Foundation
import UIKit
import Kingfisher


class DetailsViewController:UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var rangeBar: UIProgressView!
    @IBOutlet weak var highPriceLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    
    
    @IBOutlet weak var athLabel: UILabel!
    @IBOutlet weak var athDateLabel: UILabel!
    
    @IBOutlet weak var atlLabel: UILabel!
    @IBOutlet weak var atlDateLabel: UILabel!
    
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var marketCapRankLabel: UILabel!
    
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var fdvLabel: UILabel!
    
    @IBOutlet weak var totalSupplyLabel: UILabel!
    @IBOutlet weak var maxSupplyLabel: UILabel!
    
    
    var index = 0;
    var element:CoingeckoElement?
    
    override func viewDidLoad() {
        self.navigationController?.title = "Details"
        element = CryptoDataModel.coinData[index]
        
        populateViews()
        
    }
    
    private func populateViews(){
        
        

        
        logoImageView.kf.setImage(with: URL(string: element!.image),
                                       placeholder: UIImage(contentsOfFile: "cryptoPlaceholder"))
        
        titleLabel.text = "\(element?.name ?? "") (\(element?.symbol.uppercased() ?? ""))"
        
        
        let roundedPercent = round(element!.priceChangePercentage24H * 100.0) / 100.0
        
        priceLabel.text = element!.currentPrice.toEuro()
        
        if roundedPercent > 0 {
            self.percentLabel.text = "\(roundedPercent)% ▲"
            self.percentLabel.textColor = .systemGreen
        }else if roundedPercent < 0 {
            self.percentLabel.text = "\(roundedPercent)% ▼"
            self.percentLabel.textColor = .systemRed
        }else{
            self.percentLabel.text = "0.0%"
            self.percentLabel.textColor = UIColor(named: "MainText")
        }
        let max = Float(element!.high24H - element!.currentPrice)
        let diff = Float(element!.currentPrice - element!.low24H)
        
        let ratio = diff/max

        rangeBar.progress = ratio
        
        print(ratio)
        
        highPriceLabel.text = element!.high24H.toEuro()
        lowPriceLabel.text = element!.low24H.toEuro()
        
        
        athLabel.text = element!.ath.toEuro()
        athDateLabel.text = element!.athDate.toDate()
    
        atlLabel.text = element!.atl.toEuro()
        atlDateLabel.text = element!.atlDate.toDate()
        
        marketCapLabel.text = element!.marketCap.toEuro()
        marketCapRankLabel.text = String(format: "%1d", element!.marketCapRank)
        
        volumeLabel.text = element!.totalVolume.toEuro()
        if element!.fullyDilutedValuation == nil{
            fdvLabel.text = "N/A"
        }else{
            fdvLabel.text = element!.fullyDilutedValuation!.toEuro()
        }
        
        if element!.totalSupply == nil{
            totalSupplyLabel.text = "N/A"
        }else{
            totalSupplyLabel.text = element!.totalSupply!.toString()
        }
        
        if element!.maxSupply == nil{
            maxSupplyLabel.text = "N/A"
        }else{
            maxSupplyLabel.text = element!.maxSupply!.toString()
        }
        
        
        
    }
}

extension String{
    func toDate()->String{
        
        let dateFormatterIn = DateFormatter()
        dateFormatterIn.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

        if let updatedAt = dateFormatterIn.date(from: self){

            let dateFormatterOut = DateFormatter()
            dateFormatterOut.dateFormat = "MMM dd, yyyy"

            return dateFormatterOut.string(from: updatedAt)
        }
        return ""
    }
}

extension Double {
    func toEuro()->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_IE")
        
        let ret = currencyFormatter.string(from: NSNumber(value: self)) ?? "N/A"
        
        return ret.replacingOccurrences(of: ".00", with: "")
    }
    
    func toString()->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.locale = Locale(identifier: "en_IE")
        
        let ret = currencyFormatter.string(from: NSNumber(value: self)) ?? "N/A"
        
        return ret.replacingOccurrences(of: ".00", with: "")
    }
    
    
}

extension Int {
    func toEuro()->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_IE")
        
        let ret = currencyFormatter.string(from: NSNumber(value: self)) ?? "N/A"
        
        return ret.replacingOccurrences(of: ".00", with: "")
    }
    
    func toString()->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.maximumFractionDigits = 0
        currencyFormatter.locale = Locale(identifier: "en_IE")
        
        let ret = currencyFormatter.string(from: NSNumber(value: self)) ?? "N/A"
        
        return ret.replacingOccurrences(of: ".00", with: "")
    }
    
    
}


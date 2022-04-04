//
//  CryptoTableViewCell.swift
//  Colm English Tech Test
//
//  Created by Colm English on 03/04/2022.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    
    var element:CoingeckoElement!{
        didSet{
            self.titleLbl.text = element.name
            
            let roundedPercent = round(element.priceChangePercentage24H * 100.0) / 100.0 // Swift has no round percision
            if roundedPercent == 0.0{
                
            }
            priceLbl.text = element.currentPrice.toEuro()
            
            
            if roundedPercent > 0 {
                self.changeLabel.text = "\(roundedPercent)% ▲"
                self.changeLabel.textColor = .systemGreen
            }else if roundedPercent < 0 {
                self.changeLabel.text = "\(roundedPercent)% ▼"
                self.changeLabel.textColor = .systemRed
            }else{
                self.changeLabel.text = "0.0%"
                self.changeLabel.textColor = UIColor(named: "MainText")
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

//
//  SignalsTableViewCell.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 12/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit

class SignalsTableViewCell: UITableViewCell {

    @IBOutlet weak var signalCurrency: UILabel!
    @IBOutlet weak var signalImage: UIImageView!
    @IBOutlet weak var signalAction: UILabel!
    @IBOutlet weak var signalDate: UILabel!
    @IBOutlet weak var tradePrice: UILabel!
    @IBOutlet weak var takeProfit: UILabel!
    @IBOutlet weak var stopLoss: UILabel!
    @IBOutlet weak var decision: UILabel!
    @IBOutlet weak var takeProfitPercentage: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        contentView.frame = contentView.frame.inset(by: margins)
        
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 1
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }

}

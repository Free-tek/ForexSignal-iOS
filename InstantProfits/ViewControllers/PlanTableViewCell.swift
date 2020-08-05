//
//  PlanTableViewCell.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 13/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit

class PlanTableViewCell: UITableViewCell {
    
    @IBOutlet weak var planName: UILabel!
    @IBOutlet weak var planDescription: UILabel!
    @IBOutlet weak var planPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Utilities.styleHollowLabel(planPrice)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

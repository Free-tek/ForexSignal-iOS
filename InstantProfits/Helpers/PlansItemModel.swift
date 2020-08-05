//
//  PlansItemModel.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 13/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import Foundation
class PlansItemModel{
    var planDescription: String?
    var planName: String?
    var planPrice: String?
    var planKey: String?
    
    init(planDescription: String?, planName: String?, planPrice: String?, planKey: String?){
        self.planDescription = planDescription
        self.planName = planName
        self.planPrice = planPrice
        self.planKey = planKey
    }
}

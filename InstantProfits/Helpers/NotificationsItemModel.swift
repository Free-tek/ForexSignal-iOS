//
//  NotificationsItemModel.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 14/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import Foundation

class NotificationsItemModel{
    var title: String?
    var body: String?
    var key: String?
    
    init(title: String?, body: String?, key: String?){
        self.title = title
        self.body = body
        self.key = key
    }
}

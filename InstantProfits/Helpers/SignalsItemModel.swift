//
//  SignalsItemModel.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 12/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import Foundation

class SignalsItemModel{
    var itemCurrency: String?
    var itemDecision: String?
    var itemImage: Int?
    var itemSignalTime: String?
    var itemStopLoss: String?
    var itemTimeStamp: Int?
    var itemTradeOutcome: String?
    var itemTradePrice: String?
    var itemTradeProfit: String?

    init(itemCurrency: String?, itemDecision: String?, itemImage: Int?, itemSignalTime: String?, itemStopLoss: String?, itemTimeStamp: Int?, itemTradeOutcome: String?, itemTradePrice: String?, itemTradeProfit: String?){
        self.itemCurrency = itemCurrency
        self.itemDecision = itemDecision
        self.itemImage = itemImage
        self.itemSignalTime = itemSignalTime
        self.itemStopLoss = itemStopLoss
        self.itemTimeStamp = itemTimeStamp
        self.itemTradeOutcome = itemTradeOutcome
        self.itemTradePrice = itemTradePrice
        self.itemTradeProfit = itemTradeProfit
    }
}


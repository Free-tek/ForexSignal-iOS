//
//  PaymentViewController.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 14/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit
import PassKit
import StoreKit
import FirebaseAuth
import FirebaseDatabase

class PaymentViewController: UIViewController, SKPaymentTransactionObserver {

    
    let productId = "com.instantprofits.ios.instantprofitsapp.PremiumSignalsPurchasetest"
    let productIdLevel30 = "com.instantprofits.ios.instantprofitsapp.PremiumSignalsPurchase30"
    let productIdLevel60 = "com.instantprofits.ios.instantprofitsapp.PremiumSignalsPurchase60"
    let productIdLevel90 = "com.instantprofits.ios.instantprofitsapp.PremiumSignalsPurchase90"
    let productIdLevel120 = "com.instantprofits.ios.instantprofitsapp.PremiumSignalsPurchase120"
    
    
    @IBOutlet weak var _planPrice: UILabel!
    @IBOutlet weak var _planName: UILabel!
    @IBOutlet weak var _planDescription: UILabel!
    var planName  = ""
    var planDescription  = ""
    var planPrice = ""
    var plan = 0
    @IBOutlet weak var payNow: UIButton!
    
    private var payment : PKPaymentRequest = PKPaymentRequest()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        SKPaymentQueue.default().add(self)
        
        Utilities.styleFilledButton(payNow)
        _planName.text = planName
        _planPrice.text = planPrice
        _planDescription.text = planDescription

       
                
        // Do any additional setup after loading the view.
    }
    
    @IBAction func paymentFunc(_ sender: Any) {
        if SKPaymentQueue.canMakePayments(){
            if planName == "30 Premium Signals"{
                let paymetRequest = SKMutablePayment()
                paymetRequest.productIdentifier = productIdLevel30
                SKPaymentQueue.default().add(paymetRequest)
            }else if planName == "60 Premium Signals"{
                let paymetRequest = SKMutablePayment()
                paymetRequest.productIdentifier = productIdLevel60
                SKPaymentQueue.default().add(paymetRequest)
            }else if planName == "90 Premium Signals"{
                let paymetRequest = SKMutablePayment()
                paymetRequest.productIdentifier = productIdLevel90
                SKPaymentQueue.default().add(paymetRequest)
            }else if planName == "120 Premium Signals"{
                let paymetRequest = SKMutablePayment()
                paymetRequest.productIdentifier = productIdLevel120
                SKPaymentQueue.default().add(paymetRequest)
            }
        }else{
            showToast(message: "User is unable to make payments successful", seconds: 1.5)

        }
        
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            if transaction.transactionState == .purchased{
                //if item has been purchased
                let userId = (Auth.auth().currentUser?.uid)
                let ref = Database.database().reference().child("users").child(userId!)
                ref.child("paid").setValue(1)
                
                if planName == "30 Premium Signals"{
                    ref.child("remainingSignals").setValue(30)
                    
                }else if planName == "60 Premium Signals"{
                    ref.child("remainingSignals").setValue(60)
                }else if planName == "90 Premium Signals"{
                    ref.child("remainingSignals").setValue(90)
                }else if planName == "120 Premium Signals"{
                    ref.child("remainingSignals").setValue(120)
                }

                 
                showToast(message: "Transaction successful", seconds: 1.5)
            }else if transaction.transactionState == .failed{
                showToast(message: "Ooops.. transaction failed, please try again", seconds: 1.5)
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.performSegue(withIdentifier: "backToPremium", sender: nil)
        
        

    }
    
    
}

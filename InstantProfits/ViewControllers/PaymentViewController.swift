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


    @IBOutlet weak var _planPrice: UILabel!
    @IBOutlet weak var _planName: UILabel!
    @IBOutlet weak var _planDescription: UILabel!
    var planName  = ""
    var planDescription  = ""
    var planPrice = ""
    var plan = 0
    var planProductId = ""
    
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
            let paymetRequest = SKMutablePayment()
            paymetRequest.productIdentifier = planProductId
            SKPaymentQueue.default().add(paymetRequest)
            
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
                
                let totalSignal = Int(planName.components(separatedBy: " ")[0])
                
                ref.child("remainingSignals").setValue(totalSignal)
            
        
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

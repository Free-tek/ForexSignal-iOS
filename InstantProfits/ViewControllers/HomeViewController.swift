//
//  HomeViewController.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 12/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import OneSignal

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var signalsView: UIView!
    @IBOutlet weak var addSignalButton: UIButton!
    @IBOutlet weak var newSignal: UIButton!
    @IBOutlet weak var oldSignal: UIButton!
    @IBOutlet weak var sortSignalsView: UIView!
    
    @IBOutlet weak var signalsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeHeader: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var signalsViewVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    var refList: DatabaseReference!
    var ref = Database.database().reference()
    var itemList = [SignalsItemModel]()

    var sort = false
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    var _oldSignal = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
        // Do any additional setup after loading the view.




    }

    
    func setUpElements() {
        //show that app user uses iOS
        let userID = Auth.auth().currentUser?.uid
        let refUser = Database.database().reference().child("users").child(userID!)
        refUser.child("version").setValue("iOS V1")

        
        premiumView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 5.0, opacity: 0.35)
        premiumView.layer.cornerRadius = 15
        
        let insetsTrack = UIEdgeInsets(top: 100, left: 0, bottom: 200, right: 0)
        tableView.contentInset = insetsTrack
    
        addSignalButton.addShadowButton(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 5.0, opacity: 0.35)
        addSignalButton.layer.cornerRadius = 15
        
        
        newSignal.addShadowButton(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 5.0, opacity: 0.35)
        newSignal.layer.cornerRadius = 15
        
        oldSignal.addShadowButton(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 5.0, opacity: 0.35)
        oldSignal.layer.cornerRadius = 15
        

        tableView.alpha = 0
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 130, right: 0);
        
        
        //----set up activity indicator-----
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.color = UIColor.black

        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()


        //check if user has paid
        let refPaid = ref.child("users").child(userID!)


        refPaid.observeSingleEvent(of: .value) {
            (snapshot) in
            let data = snapshot.value as? [String: Any]
            let paid = (data?["paid"])

            let _balance = (paid as? Int)

            if _balance == 0 {
                self.refList = Database.database().reference().child("freesignals");
                //fetch all signals
                self.refList.observe(.value, with: {
                    (snapshot) in
                    if snapshot.childrenCount > 0 {

                        //clearing the list
                        self.itemList.removeAll()

                        //iterating through all the values
                        for item in snapshot.children.allObjects as! [DataSnapshot] {
                            //getting values
                            let itemObject = item.value as? [String: AnyObject]
                            let itemCurrency = itemObject?["currency"]
                            let itemDecision = itemObject?["decision"]
                            let itemImage = itemObject?["image"] as? Int
                            let itemSignalTime = itemObject?["signal_time"]
                            let itemStopLoss = itemObject?["stop_loss"]
                            let itemTimeStamp = itemObject?["time_stamp"]
                            let itemTradeOutcome = itemObject?["trade_outcome"]
                            let itemTradePrice = itemObject?["trade_price"]
                            let itemTradeProfit = itemObject?["trade_profit"]
                            
                            
                            
                            let dateFormatterGet = DateFormatter()
                                    dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"

                            let dateFormatterPrint = DateFormatter()
                            dateFormatterPrint.dateFormat = "dd-MM-yy HH:mm"

                            let date: Date? = dateFormatterGet.date(from: (itemSignalTime as! String?)!)
                            let _itemSignalTime = dateFormatterPrint.string(from: date!)
                            
                            //creating itemGotten object with model and fetched values
                            let itemGotten = SignalsItemModel(itemCurrency: itemCurrency as! String?, itemDecision: itemDecision as! String?, itemImage: itemImage, itemSignalTime: _itemSignalTime, itemStopLoss: itemStopLoss as! String?, itemTimeStamp: itemTimeStamp as! Int?, itemTradeOutcome: itemTradeOutcome as! String?, itemTradePrice: itemTradePrice as! String?, itemTradeProfit: itemTradeProfit as! String?)

                            //appending it to list
                            self.itemList.append(itemGotten)

                        }

                        if(!self._oldSignal) {
                            self.itemList.reverse()
                        }



                        //reloading the tableview
                        self.tableView.reloadData()

                    }

                })

            } else {
                self.premiumView.isHidden = true
                self.homeHeader.isHidden = true
                
                self.sortSignalsView.backgroundColor = UIColor(patternImage: UIImage(named: "homeHeader.png")!)

                let xPosition = self.signalsView.frame.origin.x
                let yPosition = self.signalsView.frame.origin.y - 160 // Slide Up - 20px

                let width = self.signalsView.frame.size.width
                //let height = self.signalsView.frame.size.height
                
                let height = CGFloat(1194)
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.signalsView.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
                })

                self.signalsViewHeightConstraint.constant = height
                self.tableViewHeightConstraint.constant = height - 100
                
                if height > 896 {
                    self.signalsViewVerticalConstraint.constant = -1 * (self.homeHeader.frame.height - 50)
                }else{
                    self.signalsViewVerticalConstraint.constant = -1 * (self.homeHeader.frame.height - 50)
                }
                
                self.signalsView.layoutIfNeeded()
                self.tableView.layoutIfNeeded()
                
                self.refList = Database.database().reference().child("premiumsignals");

                //fetch all signals
                self.refList.observe(.value, with: {
                    (snapshot) in
                    if snapshot.childrenCount > 0 {

                        //clearing the list
                        self.itemList.removeAll()

                        //iterating through all the values
                        for item in snapshot.children.allObjects as! [DataSnapshot] {
                            //getting values
                            let itemObject = item.value as? [String: AnyObject]
                            let itemCurrency = itemObject?["currency"]
                            let itemDecision = itemObject?["decision"]
                            let itemImage = itemObject?["image"] as! Int?
                            let itemSignalTime = itemObject?["signal_time"]
                            let itemStopLoss = itemObject?["stop_loss"]
                            let itemTimeStamp = itemObject?["time_stamp"]
                            let itemTradeOutcome = itemObject?["trade_outcome"]
                            let itemTradePrice = itemObject?["trade_price"]
                            let itemTradeProfit = itemObject?["trade_profit"]
                            
                            let dateFormatterGet = DateFormatter()
                                    dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"

                            let dateFormatterPrint = DateFormatter()
                            dateFormatterPrint.dateFormat = "dd-MM-yy HH:mm"

                            let date: Date? = dateFormatterGet.date(from: (itemSignalTime as! String?)!)
                            let _itemSignalTime = dateFormatterPrint.string(from: date!)
                           
                            //creating itemGotten object with model and fetched values
                            let itemGotten = SignalsItemModel(itemCurrency: itemCurrency as! String?, itemDecision: itemDecision as! String?, itemImage: itemImage, itemSignalTime: _itemSignalTime, itemStopLoss: itemStopLoss as! String?, itemTimeStamp: itemTimeStamp as! Int?, itemTradeOutcome: itemTradeOutcome as! String?, itemTradePrice: itemTradePrice as! String?, itemTradeProfit: itemTradeProfit as! String?)

                            //appending it to list
                            self.itemList.append(itemGotten)
                        }

                        if(!self._oldSignal) {
                            self.itemList.reverse()
                        }


                        //reloading the tableview
                        self.tableView.reloadData()

                    }

                })

            }

        }


    }

    @IBAction func toPurchasePremiumSignals(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 1
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "signalsCell", for: indexPath) as! SignalsTableViewCell

        let item: SignalsItemModel
        item = itemList[indexPath.row]



        // Stop and hide indicator
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        tableView.alpha = 1


        //set image

        if item.itemImage! == 0 {
            cell.signalImage.image = UIImage(named: "buy")
            cell.signalAction.text = "Buy"
        } else {
            cell.signalImage.image = UIImage(named: "sell")
            cell.signalAction.text = "Sell"
            cell.signalAction.textColor = UIColor.red
        }


        //set cell name and price
        cell.signalCurrency.text = item.itemCurrency
        cell.signalDate.text = item.itemSignalTime
        cell.tradePrice.text = item.itemTradePrice
        cell.takeProfit.text = item.itemTradeProfit
        cell.stopLoss.text = item.itemStopLoss
        cell.decision.text = item.itemDecision

        let tradeProfit = Double(item.itemTradeProfit!)
        let tradePrice = Double(item.itemTradePrice!)

        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = round((tradeProfit! - tradePrice!) * multiplier) / multiplier

        cell.takeProfitPercentage.text = String(rounded)
        cell.selectionStyle = .none
        
    

        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item: SignalsItemModel
        item = itemList[indexPath.row]
    }


    @IBAction func newSignalFunc(_ sender: Any) {
        sort = true
        _oldSignal = false
        setUpElements()
    }

    @IBAction func oldSignalFunc(_ sender: Any) {
        sort = false
        _oldSignal = true
        setUpElements()
    }

    @IBAction func cancelFunc(_ sender: Any) {

        premiumView.isHidden = true
        homeHeader.isHidden = true
        
        sortSignalsView.backgroundColor = UIColor(patternImage: UIImage(named: "homeHeader.png")!)

        let xPosition = signalsView.frame.origin.x
        let yPosition = signalsView.frame.origin.y - premiumView.frame.size.height - 40 // Slide Up - 20px

        let width = signalsView.frame.size.width
        let height = signalsView.frame.size.height
        
        
        let tableViewWidth = tableView.frame.size.width
        let tableViewHeight = tableView.frame.size.height
            
            
        
        UIView.animate(withDuration: 1.0, animations: {
            self.signalsView.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            
            self.signalsView.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height + 160)
            self.tableView.frame  = CGRect(x: xPosition, y: yPosition, width: width, height: height + 160)
            
            
          
            })
        
        

    }

}

//
//  PremiumPlanViewController.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 13/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PremiumPlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signalsLeft: UILabel!
    @IBOutlet weak var signalsLeftCount: UILabel!
    
    var refList: DatabaseReference!
    var ref = Database.database().reference()
    var itemList = [PlansItemModel]()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

         setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        tabBarController?.selectedIndex = 1
        tableView.alpha = 0
        
        let insets =  UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        tableView.contentInset = insets
        
        tableView.tableFooterView = UIView()
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
        let userID = Auth.auth().currentUser?.uid
        let refPaid = ref.child("users").child(userID!)
        
        
        refPaid.observeSingleEvent(of: .value){
            (snapshot) in
            let data = snapshot.value as? [String:Any]
            let signalsleft = (data?["remainingSignals"])
            
            let _signalsleft = (signalsleft as? Int)
            
            self.signalsLeftCount.text = "\(_signalsleft!)"
            
            self.refList = Database.database().reference().child("plans");
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
                        let planDescription  = itemObject?["plan_description"]
                        let planName  = itemObject?["plan_name"]
                        let planPrice  = itemObject?["plan_price"]
                        let planProductId = itemObject?["plan_productId"]
                        let planKey = item.key
                                  
                                   
                        //creating itemGotten object with model and fetched values
                        let itemGotten = PlansItemModel(planDescription: planDescription as! String?, planName: planName as! String?, planPrice: planPrice as! String?, planProductId: planProductId as! String? , planKey: planKey as! String?)
                                      
                        //appending it to list
                        self.itemList.append(itemGotten)
                    
                }
                
                //reloading the tableview
                self.tableView.reloadData()
                
                }
                          
            })
            
            
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "plansCell", for: indexPath) as! PlanTableViewCell
        
         let item: PlansItemModel
         item = itemList[indexPath.row]
        
        
         
         // Stop and hide indicator
         self.activityIndicator.stopAnimating()
         self.activityIndicator.isHidden = true
         tableView.alpha = 1
        
        
         //set cell name and price
         cell.planName.text = item.planName
         cell.planDescription.text = item.planDescription
         cell.planPrice.text = item.planPrice
        

        cell.priceView.layer.cornerRadius = 10
        cell.priceView.layer.borderColor = UIColor.clear.cgColor
        

        cell.priceView.layer.shadowColor = UIColor.gray.cgColor
        cell.priceView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.priceView.layer.shadowRadius = 2.0
        cell.priceView.layer.shadowOpacity = 1.0
        cell.priceView.layer.masksToBounds = false
        cell.priceView.layer.shadowPath = UIBezierPath(roundedRect: cell.priceView.bounds, cornerRadius: cell.priceView.layer.cornerRadius).cgPath
        
        
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item: PlansItemModel
        item = itemList[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
      
       let viewController = storyboard.instantiateViewController(withIdentifier: "paymentPage") as! PaymentViewController
       viewController.planName = item.planName!
       viewController.planDescription = item.planDescription!
       viewController.planPrice = item.planPrice!
       viewController.planProductId = item.planProductId!
    
       viewController.view.window?.rootViewController = viewController
       viewController.view.window?.makeKeyAndVisible()


       self.present(viewController, animated: true, completion: nil)
    }



    
}


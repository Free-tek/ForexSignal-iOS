//
//  NotificationsViewController.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 14/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var refList: DatabaseReference!
    var ref = Database.database().reference()
    var itemList = [NotificationsItemModel]()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    

    func setUpElements(){
        
        
        
        tableView.alpha = 0
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 130, right: 0);
        
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
        
        
    
        self.refList = Database.database().reference().child("notifications");
        //fetch all notifications
        self.refList.observe(.value, with: {
            (snapshot) in
            if snapshot.childrenCount > 0 {
                      
                //clearing the list
                self.itemList.removeAll()
                          
                //iterating through all the values
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let itemObject = item.value as? [String: AnyObject]
                    let title  = itemObject?["title"]
                    let body  = itemObject?["body"]
                    let key = item.key
                              
                               
                    //creating itemGotten object with model and fetched values
                    let itemGotten = NotificationsItemModel(title: title as! String?, body: body as! String?, key: key as String?)
                                  
                    //appending it to list
                    self.itemList.append(itemGotten)
                
            }
            
            //reloading the tableview
            self.tableView.reloadData()
            
            }
                      
        })
    
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCell", for: indexPath) as! NotificationsTableViewCell
        
         let item: NotificationsItemModel
         item = itemList[indexPath.row]
        
        
         
         // Stop and hide indicator
         self.activityIndicator.stopAnimating()
         self.activityIndicator.isHidden = true
         tableView.alpha = 1
        
        
         //set cell name and price
         cell.title.text = item.title
         cell.body.text = item.body
         if item.title!.lowercased().contains("premium") {
            cell.icon.image = UIImage(named: "premium2")
         }else if item.body!.lowercased().contains("buy") {
             cell.icon.image = UIImage(named: "buy")
         }else if item.body!.lowercased().contains("sell") {
             cell.icon.image = UIImage(named: "sell")
         }else if item.body!.lowercased().contains("new") {
             cell.icon.image = UIImage(named: "notifications-")
         }else{
            cell.icon.image = UIImage(named: "notifications-")
         }
         
        
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item: NotificationsItemModel
        item = itemList[indexPath.row]
        
    }


}

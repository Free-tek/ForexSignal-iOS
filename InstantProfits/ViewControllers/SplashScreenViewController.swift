//
//  SplashScreenViewController.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 11/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var icon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        checkLogin()
        // Do any additional setup after loading the view.
    }
    
    
    func setUpElements(){
        self.icon.center = self.view.center
    }
    

   func checkLogin(){
         let userID = Auth.auth().currentUser?.uid
         
         
         if userID != nil{
            
            let refUser = Database.database().reference().child("users").child(userID!)
            
            refUser.observeSingleEvent(of: .value){
            (snapshot) in
                                           
                let data = snapshot.value as? [String:Any]
                let verified = (data?["verified"])
                var _verified = (verified as? String)!
                
                if(_verified == "false"){
                    let alert = UIAlertController(title: "Ooops...", message: "You have not verified you mail, check your email for a link or click resend to get a new link.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (upVote) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Resend", style: UIAlertAction.Style.default, handler: { (downVote) in
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                            self.showToast(message: "Done", seconds: 2)
                        })
                        
                       
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    print(userID!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        self.transitionToHome()
                    })
                }
                
            }
                
             
         }else{
             DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
                 self.performSegue(withIdentifier: "launchLogin", sender: nil)
             }
         }
     }
     
    func transitionToHome(){
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        let viewController = storyboard.instantiateInitialViewController()

        if let viewController = viewController {
            view.window?.rootViewController = viewController
            view.window?.makeKeyAndVisible()
            self.present(viewController, animated: true, completion: nil)
        }
        
        
    }
    
}

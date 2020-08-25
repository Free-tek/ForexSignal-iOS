//
//  ProfileViewController.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 14/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var remainingSignals: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var updateProfile: UIButton!
    @IBOutlet weak var contactUs: UIButton!
    @IBOutlet weak var changePassword: UIButton!
    @IBOutlet weak var logOut: UIButton!
    
    var refList: DatabaseReference!
    var ref = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
        hideKeyboardWhenTappedAround()
        getData()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        email.isEnabled = false
        firstName.isEnabled = false
        surname.isEnabled = false
        
        Utilities.styleFilledButton2(updateProfile)
        Utilities.styleFilledButton(changePassword)
        Utilities.styleFilledButton3(logOut)
        Utilities.styleFilledLabel2(remainingSignals)
    }
    
    func getData(){
        //check if user has paid
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userID!)

        ref.observeSingleEvent(of: .value){
            (snapshot) in
            let data = snapshot.value as? [String:Any]


            let _firstName  = data?["name"]
            let _surname  = data?["surname"]
            let _phoneNumber = data?["phoneNumber"]
            let _email = data?["email"]
            let _country  = data?["country"]
            let _remainingSignals  = data?["remainingSignals"] as? Int
            
           
            self.remainingSignals.text = "Remaining Signals: \(_remainingSignals!)"
            self.email.text = (_email as? String)!
            self.firstName.text = (_firstName as? String)!
            self.surname.text = (_surname as? String)!
            self.phoneNo.text = (_phoneNumber as? String)!
            self.country.text = (_country as? String)!
            
            
            
        }
        
    }
    

    @IBAction func updateProfilePicFunc(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        let refUser = Database.database().reference().child("users").child(userID!)
        refUser.child("name").setValue(firstName.text)
        refUser.child("surname").setValue(surname.text)
        refUser.child("phoneNumber").setValue(phoneNo.text)
        refUser.child("country").setValue(country.text)
        refUser.child("email").setValue(email.text)
        
        showToast(message: "Profile update successful", seconds: 2)
    }
    
    @IBAction func changePasswordFunc(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "forgotPasswordPage") as! ForgotPasswordViewController
        viewController.view.window?.rootViewController = viewController
        viewController.view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func logoutFunc(_ sender: Any) {
        let alert = UIAlertController(title: "Proceed?", message: "Do you want to proceed to sign out?.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (upVote) in
            try! Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let viewController = storyboard.instantiateInitialViewController()

            if let viewController = viewController {
                self.view.window?.rootViewController = viewController
                self.view.window?.makeKeyAndVisible()
                self.present(viewController, animated: true, completion: nil)
            }
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (downVote) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func contactUsFunc(_ sender: Any) {
        showToast(message: "Contact us at instantprofitsinc@gmail.com", seconds: 3)
    }
    
    
}

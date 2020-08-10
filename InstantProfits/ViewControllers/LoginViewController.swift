//
//  LoginViewController.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 11/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit
import Firebase
import Lottie
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var googleSignIn: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var or: UILabel!
    
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        
        setUpElements()
        self.hideKeyboardWhenTappedAround()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        Utilities.styleFilledButton(login)
        Utilities.styleFilledButton(signUp)
        Utilities.styleFilledButton2(googleSignIn)
        errorMessage.alpha = 0
            
    }
    
    @IBAction func forgotPasswordfunc(_ sender: Any) {
    }
    
    @IBAction func loginFunc(_ sender: Any) {
        
        //Validate the textfields
         if validateFields() ==  nil{
              //sign in the user
             
             //show loading spinner
             
             self.animationView.alpha = 1
             self.animationView.animation = Animation.named("loading")
             self.animationView.frame = CGRect(x:0, y:0, width: 150, height: 150)
             self.animationView.center = self.view.center
             self.animationView.contentMode = .scaleAspectFit
             self.animationView.loopMode = .loop
             self.animationView.play()
             self.view.addSubview(self.animationView)
             
             //switch views off

             errorMessage.alpha = 0
             email.alpha = 0.2
             password.alpha = 0.2
             forgotPassword.alpha = 0.2
             login.alpha = 0.2
             signUp.alpha = 0.2
             googleSignIn.alpha = 0.2
             logo.alpha = 0.2
             or.alpha = 0.2
             
             
             let _email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
             let _password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)

             
             Auth.auth().signIn(withEmail: _email, password: _password) { [weak self] authResult, error in
                 guard self != nil else { return }
               
                 if error == nil{
                    
                    if Auth.auth().currentUser?.isEmailVerified == false{
                        let alert = UIAlertController(title: "Ooops...", message: "You have not verified you mail, check your email for a link or click resend to get a new link.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (upVote) in
                            alert.dismiss(animated: true, completion: nil)
                            
                        }))
                        alert.addAction(UIAlertAction(title: "Resend", style: UIAlertAction.Style.default, handler: { (downVote) in
                            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                                self!.showToast(message: "Done", seconds: 2)
                            })
                            
                           
                        }))
                        self!.present(alert, animated: true, completion: nil)
                        self?.animationView.stop()
                        self?.animationView.alpha = 0
                        
                        //switch views back on
                        self?.errorMessage.alpha = 0
                        self?.email.alpha = 1
                        self?.password.alpha = 1
                        self?.forgotPassword.alpha = 1
                        self?.login.alpha = 1
                        self?.signUp.alpha = 1
                        self?.googleSignIn.alpha = 1
                        self?.logo.alpha = 1
                        self?.or.alpha = 1
                    }else{
                        self?.transitionToHome()
                    }
                    
                    
                 }else{
                     // user sign in unsucessful
                     self?.showToast(message: error!.localizedDescription, seconds: 1.5)
                     //self?.showErrorMessage(error!.localizedDescription)
                     print("Error during login")
                     self?.animationView.stop()
                     self?.animationView.alpha = 0
                     
                     //switch views back on
                     self?.errorMessage.alpha = 0
                     self?.email.alpha = 1
                     self?.password.alpha = 1
                     self?.forgotPassword.alpha = 1
                     self?.login.alpha = 1
                     self?.signUp.alpha = 1
                     self?.googleSignIn.alpha = 1
                     self?.logo.alpha = 1
                     self?.or.alpha = 1
                     
                     

                 }
             }
             
             
             
             
         }else{
             showToast(message: validateFields()!, seconds: 1.5)
             //showErrorMessage(validateFields()!)
             
         }
        
        
    }
    
    func transitionToHome(){
        // Stop and hide indicator
        self.animationView.stop()
        self.animationView.alpha = 0
        
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        let viewController = storyboard.instantiateInitialViewController()

        if let viewController = viewController {
            view.window?.rootViewController = viewController
              view.window?.makeKeyAndVisible()
        }
    }

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else {
            return
            
        }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful.")
                //get users detail and save it to firebase
                let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
                let surname = user.profile.familyName
                let name = user.profile.givenName
                let email = user.profile.email
                
                
                let userId = Auth.auth().currentUser?.uid
                let ref = Database.database().reference().child("users")
            
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in

                     if snapshot.hasChild(userId!){
                        
                        
                     }else{
                       
                        let post: [String : Any] = [
                            "name" : name ?? "",
                             "surname" : surname ?? "",
                             "phoneNumber" : "",
                             "password": "Google Sign In",
                             "email": email ?? "",
                             "country": "",
                             "city": "",
                             "isAdmin": 0,
                             "paid": 0,
                             "remainingSignals": 0,
                             "verified": "true",
                             "signalsLeft": 0,
                             "version" : "iOS V1"
                             ]
                             
                         
                         let ref = Database.database().reference().child("users").child(userId!)
                             
                             //save user's data
                             ref.setValue(post) { (err, resp) in
                                if err == nil {
                                    self.transitionToHome()
                                }else {
                                     print("Posting failed : ")
                                     return
                                 }
                                 print("No errors while posting, :")
                                 print(resp)
                                 

                                 
                                 
                             }
                     }


                 })
                
                            }
            
        }
    }
    
   
    @IBAction func googleSignInFunc(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func validateFields() -> String?{
           //check that all fields are filled in
           if self.email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
           {
               return "Please enter your email."
           }else if self.password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
               return "Please enter your password."
           }
           
           return nil
       }
       
       func showErrorMessage(_ message: String){
           errorMessage.text = "Error:  " + message
           errorMessage.alpha = 1
       }
}
//hide keyboard ontouch outside
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//
//  SignUpViewController.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 11/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit
import Firebase
import Lottie
import GoogleSignIn

class SignUpViewController: UIViewController, GIDSignInDelegate {
    
    private var dataSource = [String]()

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleSignIn: UIButton!
    
    @IBOutlet weak var signInView: UIView!
    
    @IBOutlet weak var signUpScroll: UIScrollView!
    private var countryPicker: UIPickerView?
    let countries = Utilities.countries
    
    
    let animationView = AnimationView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        
        signInView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 5.0, opacity: 0.35)
        signInView.layer.cornerRadius = 15
        
        googleSignIn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 5.0, opacity: 0.35)
        googleSignIn.layer.cornerRadius = 15
        
        countryPicker = UIPickerView()
        country.inputView = countryPicker
        countryPicker!.delegate = self
        
        signUp.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 5.0, opacity: 0.35)
        signUp.layer.cornerRadius = 15
        

        self.countryPicker!.delegate = self
        self.countryPicker!.dataSource = self
        
    }
    
    @IBAction func signUpFunc(_ sender: Any) {
        if(validateFields() == nil){

            signUpScroll.alpha = 0.2
            
           
            self.animationView.alpha = 1
            self.animationView.animation = Animation.named("loading")
            self.animationView.frame = CGRect(x:0, y:0, width: 150, height: 150)
            self.animationView.center = self.view.center
            self.animationView.contentMode = .scaleAspectFit
            self.animationView.loopMode = .loop
            self.animationView.play()
            self.view.addSubview(self.animationView)
            
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (result, err) in
                
                
                //check for errors
                if err != nil{
                    //there was an error
                    self.showToast(message: "Please try again, we could not create your account", seconds: 1.5)
                    
                    
                    self.animationView.stop()
                    self.animationView.alpha = 0
                    
                    self.signUpScroll.alpha = 1
                    
                    self.showToast(message: "Please try again, we could not create your account", seconds: 1)
                    self.animationView.stop()
                    self.animationView.alpha = 0
                    
                }else{
                
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                      // Notify the user that the mail has sent or couldn't because of an error.
                        
                        
                        let post: [String : Any] = [
                                                        "name" : self.firstName.text!,
                                                        "surname" : self.surname.text!,
                                                        "phoneNumber" : self.phoneNo.text!,
                                                        "password": self.password.text!,
                                                        "email": self.email.text!,
                                                        "country": self.country.text!,
                                                        "city": "",
                                                        "isAdmin": 0,
                                                        "paid": 0,
                                                        "remainingSignals": 0,
                                                        "verified": "false",
                                                        "signalsLeft": 0,
                                                        "version" : "iOS V1"
                                                        ]
                            
                        
                        let userId = result!.user.uid
                        let ref = Database.database().reference().child("users").child(userId)
                            
                        
                        
                            //save user's data
                            ref.setValue(post) { (err, resp) in
                                        guard err == nil else {
                                            print("Posting failed : ")
                                            //print(err)

                                            return
                                        }
                                        print("No errors while posting, :")
                                        print(resp)
                                        
                                        
                                    }
                            
                        
                    })
                    
                    self.animationView.stop()
                    self.animationView.alpha = 0
                    
                    self.signUpScroll.alpha = 1
                    
                    self.showToast(message: "A verification email has been sent to you, please confirm your email.", seconds: 3)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
                        self.performSegue(withIdentifier: "launchLogin", sender: nil)
                    }
                }
            }
            
        }else{
            showToast(message: validateFields()!, seconds: 1.5)
        }
    }
   
    func validateFields()-> String?{
        
        if email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please enter your email."
        }else if firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please enter your First name."
        }else if surname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please enter your Surname."
        }else if phoneNo.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please enter your password."
        }else if password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please enter your password."
        }else if confirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please confirm your password."
            
        }else if password.text?.trimmingCharacters(in: .whitespacesAndNewlines) != confirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return "Your passwords dont match"
            
        }else if country.text == "Select Country" {
            return "Please select a country"
        }
        
        return nil
    }
    
    @IBAction func signUpGoogleFunc(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
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
                self.showToast(message: "Ooops... This email already exists", seconds: 1.5)
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

                    if snapshot.hasChild(userId!) {
                        print("user already exists \(userId!)")
                        self.transitionToHome()

                    } else {

                        let post: [String: Any] = [
                            "name": name ?? "",
                            "surname": surname ?? "",
                            "phoneNumber": "",
                            "password": "Google Sign In",
                            "email": email ?? "",
                            "country": "",
                            "city": "",
                            "isAdmin": 0,
                            "paid": 0,
                            "remainingSignals": 0,
                            "verified": "true",
                            "signalsLeft": 0,
                            "version": "iOS V1"
                        ]


                        let ref = Database.database().reference().child("users").child(userId!)

                        //save user's data
                        ref.setValue(post) { (err, resp) in
                            if err == nil {
                                self.transitionToHome()
                            } else {
                                self.showToast(message: "Ooops... This email already exists", seconds: 1.5)
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

    
    func transitionToHome() {
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
    
    
}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        country.text = countries[row]
    }

}

extension UIViewController {
    func showToast(message: String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
        }
        
    }
    
   
}

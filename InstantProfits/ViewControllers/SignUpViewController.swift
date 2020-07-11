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

class SignUpViewController: UIViewController {
    
    private var dataSource = [String]()

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var CountryPicker: UIPickerView!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var selectCountry: UILabel!
    
    let animationView = AnimationView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        Utilities.styleFilledButton(signUp)
        errorMessage.alpha = 0
        
        self.dataSource = ["Afghanistan","Albania","Algeria","Angola","Argentina","Armenia","Australia","Austria","Azerbaijan","Bahamas","Bangladesh","Belarus","Belgium","Belize","Benin","Bhuta","Bolivia","Bosnia and Herzegovina","Botswana","Brazil","Brunei Darussalam","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Ivory Coast","Central African Republic","Chad","Chile","China","Colombia","Congo","Democratic Republic of Congo","Costa Rica","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Diamond Princess","Djibouti","Dominican Republic","DR Congo","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Falkland Islands","Fiji","Finland","France","French Guiana","French Southern Territories","Gabon","Gambia","Georgia","Germany","Ghana","Greece","Greenland","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Korea","Kosovo","Kuwait","Kyrgyzstan","Lao","Latvia","Lebanon","Lesotho","Liberia","Libya","Lithuania","Luxembourg","Macedonia","Madagascar","Malawi","Malaysia","Mali","Mauritania","Mexico","Moldova","Mongolia","Montenegro","Morocco","Mozambique","Myanmar","Namibia","Nepal","Netherlands","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","North Korea","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Republic of Kosovo","Romania","Russia","Rwanda","Saudi Arabia","Senegal","Serbia","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Korea","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Svalbard and Jan Mayen","Swaziland","Sweden","Switzerland","Syrian Arab Republic","Taiwan","Tajikistan","Tanzania","Thailand","Timor-Leste","Togo","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","UAE","Uganda","United Kingdom","Ukraine","USA","Uruguay","Uzbekistan","Vanuatu","Venezuela","Vietnam","Western Sahara","Yemen","Zambia","Zimbabwe"]
        
        
        self.CountryPicker.reloadAllComponents()
        self.CountryPicker.dataSource = self
        self.CountryPicker.delegate = self
        
    }
    
    @IBAction func signUpFunc(_ sender: Any) {
        if(validateFields() == nil){

            email.alpha = 0.2
            firstName.alpha = 0.2
            surname.alpha = 0.2
            phoneNo.alpha = 0.2
            password.alpha = 0.2
            confirmPassword.alpha = 0.2
            CountryPicker.alpha = 0.2
            signUp.alpha = 0.2
            loginButton.alpha = 0.2
            errorMessage.alpha = 0.2
            selectCountry.alpha = 0.2
            
            
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
                    self.showErrorMessage("Please try again, we could not create your account")
                    
                    self.email.alpha = 1
                    self.firstName.alpha = 1
                    self.surname.alpha = 1
                    self.phoneNo.alpha = 1
                    self.password.alpha = 1
                    self.confirmPassword.alpha = 1
                    self.CountryPicker.alpha = 1
                    self.signUp.alpha = 1
                    self.loginButton.alpha = 1
                    self.errorMessage.alpha = 1
                    self.selectCountry.alpha = 1
                    
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
                                                        "country": self.selectCountry.text!,
                                                        "city": "",
                                                        "password": self.password.text!,
                                                        "version": "iOS",
                                                        "isAdmin": 0,
                                                        "paid": 0,
                                                        "remainingSignals": 0,
                                                        "verified": "false"
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
                    
                    
                        
                        
                }
            }
            
        }else{
            showErrorMessage(validateFields()!)
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
            
        }else if selectCountry.text == "Select Country" {
            return "Please select a country"
        }
        
        return nil
    }
    
    func showErrorMessage(_ message: String){
        errorMessage.text = "Error:  " + message
        errorMessage.alpha = 1
    }
    
    
    
    

}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCountry.text = dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row ]
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

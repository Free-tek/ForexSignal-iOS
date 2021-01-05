//
//  ForgotPasswordViewController.swift
//  InstantProfits
//
//  Created by Babatunde Adewole on 11/6/20.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import Lottie


class ForgotPasswordViewController: UIViewController {
    

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var instruction: UILabel!
    @IBOutlet weak var forgotPasswordView: UIView!
    
     let animationView = AnimationView()
    
    override func viewDidLoad() {
        setUpElements()
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        
        email.borderStyle = .none
        
        forgotPasswordView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 5.0, opacity: 0.35)
        forgotPasswordView.layer.cornerRadius = 15
        
        send.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 5.0, opacity: 0.35)
        send.layer.cornerRadius = 15
            
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        
        if self.validateFields() == nil{
            //show loading
            self.animationView.alpha = 1
            self.animationView.animation = Animation.named("loading")
            self.animationView.frame = CGRect(x:0, y:0, width: 150, height: 200)
            self.animationView.center = self.view.center
            self.animationView.contentMode = .scaleAspectFit
            self.animationView.loopMode = .loop
            self.animationView.play()
            self.view.addSubview(self.animationView)
            
            
            forgotPasswordView.alpha = 0.2
            
            
            let _email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().sendPasswordReset(withEmail: _email) { error in
                
            }
            
            showToast(message: "A reset password link has been sent to your mail", seconds: 2)
        }else{
            showToast(message: self.validateFields()!, seconds: 1)
        }
        
        forgotPasswordView.alpha = 1
        self.animationView.stop()
        self.animationView.alpha = 0
    }
    
    
    func validateFields() -> String?{
       //check that all fields are filled in
       if self.email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
       {
           return "Please enter your email."
       }
       
       return nil
   }
       
    @IBAction func backFunction(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
    }
    
    
}

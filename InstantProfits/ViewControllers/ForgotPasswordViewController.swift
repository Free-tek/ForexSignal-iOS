//
//  ForgotPasswordViewController.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 11/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import Lottie


class ForgotPasswordViewController: UIViewController {
    

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var instruction: UILabel!
    
     let animationView = AnimationView()
    
    override func viewDidLoad() {
        setUpElements()
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        Utilities.styleFilledButton(send)
        errorMessage.alpha = 0
            
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        
        if self.validateFields() == nil{
            //show loading
            self.animationView.alpha = 1
            self.animationView.animation = Animation.named("loading")
            self.animationView.frame = CGRect(x:0, y:0, width: 150, height: 150)
            self.animationView.center = self.view.center
            self.animationView.contentMode = .scaleAspectFit
            self.animationView.loopMode = .loop
            self.animationView.play()
            self.view.addSubview(self.animationView)
            
            
            cancel.alpha = 0.2
            email.alpha = 0.2
            send.alpha = 0.2
            header.alpha = 0.2
            instruction.alpha = 0.2
            
            
            let _email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().sendPasswordReset(withEmail: _email) { error in
                
            }
            
            showToast(message: "A reset password link has been sent to your mail", seconds: 2)
        }else{
            showToast(message: self.validateFields()!, seconds: 1)
        }
        
        cancel.alpha = 1
        email.alpha = 1
        send.alpha = 1
        header.alpha = 1
        instruction.alpha = 1
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
       
    
}

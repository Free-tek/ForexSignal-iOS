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
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    let animationView = AnimationView()

    override func viewDidLoad() {

        setUpElements()
        self.hideKeyboardWhenTappedAround()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self


        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func setUpElements() {
        Utilities.styleFilledButton(login)
        
        email.borderStyle = .none
        password.borderStyle = .none
        
        
       
        
        loginView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 5.0, opacity: 0.35)
        loginView.layer.cornerRadius = 15
        
        googleSignIn.addShadowButton(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 5.0, opacity: 0.35)
        googleSignIn.layer.cornerRadius = 15

    }

    @IBAction func forgotPasswordfunc(_ sender: Any) {
    }

    @IBAction func loginFunc(_ sender: Any) {

        //Validate the textfields
        if validateFields() == nil {
            //sign in the user

            //show loading spinner

            self.animationView.alpha = 1
            self.animationView.animation = Animation.named("loading")
            self.animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            self.animationView.center = self.view.center
            self.animationView.contentMode = .scaleAspectFit
            self.animationView.loopMode = .loop
            self.animationView.play()
            self.view.addSubview(self.animationView)

            //switch views off
            loginView.alpha = 0.2


            let _email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let _password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)


            Auth.auth().signIn(withEmail: _email, password: _password) { [weak self] authResult, error in
                guard self != nil else { return }

                if error == nil {

                    if Auth.auth().currentUser?.isEmailVerified == false {
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
                        
                        self?.loginView.alpha = 1
                        
                        
                    } else {
                        self?.transitionToHome()
                    }


                } else {
                    // user sign in unsucessful
                    self?.showToast(message: error!.localizedDescription, seconds: 1.5)
                    
                    print("Error during login")
                    self?.animationView.stop()
                    self?.animationView.alpha = 0

                    //switch views back on
                    self?.loginView.alpha = 1



                }
            }




        } else {
            showToast(message: validateFields()!, seconds: 1.5)

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


    @IBAction func googleSignInFunc(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }

    func validateFields() -> String? {
        //check that all fields are filled in
        if self.email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please enter your email."
        } else if self.password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please enter your password."
        }

        return nil
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


extension UIView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
}


extension UIButton{

    func addShadowButton(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
}

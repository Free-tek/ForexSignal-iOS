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
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController, GIDSignInDelegate {



    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var googleSignIn: UIButton!
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signInWithApple: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    let animationView = AnimationView()
    
    fileprivate var currentNonce: String?
    
    static var fromLogin = true
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
        
        signInWithApple.addShadowButton(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 5.0, opacity: 0.35)
        signInWithApple.layer.cornerRadius = 15
        
        
    }

    @IBAction func signInWithAppleFunc(_ sender: Any) {
        if #available(iOS 13.0, *) {
            performAppleSignIn()
        } else {
            showToast(message: "Sign in with apple is only available for a minimum of iOS13 users", seconds: 1.5)
    
        }
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
            self.animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 200)
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
    
    @available(iOS 13.0, *)
    func performAppleSignIn(){
      
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self

        authorizationController.performRequests()
    }
    
    @available(iOS 13.0, *)
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest{
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
        
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    

    func transitionToHome() {
        // Stop and hide indicator
        self.loginView.alpha = 1
        self.animationView.stop()
        self.animationView.alpha = 0

        print("this was your fromLogin \(LoginViewController.fromLogin)")
        if LoginViewController.fromLogin == true{
            self.performSegue(withIdentifier: "goToHomeFromLogin", sender: self)
        }else{
            self.performSegue(withIdentifier: "goToHomeFromLogin", sender: self)
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
        
        
        //show loader
        self.animationView.alpha = 1
        self.animationView.animation = Animation.named("loading")
        self.animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 200)
        self.animationView.center = self.view.center
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.loopMode = .loop
        self.animationView.play()
        self.view.addSubview(self.animationView)

        //switch views off
        loginView.alpha = 0.2
        
        
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
                            self.transitionToHome()
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
extension LoginViewController: ASAuthorizationControllerDelegate{
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    
        
        if let appleIDCredentials = authorization.credential as? ASAuthorizationAppleIDCredential{
            guard let nonce = currentNonce else{
                fatalError("Invalid State: A login call back was recieved, but no login was sent")
                showToast(message: "Oops.. we couldn't sign you in via apple, please try again", seconds: 1.3)
                
            }
            
            guard let appleIDToken = appleIDCredentials.identityToken else{
                print("unable to find identity token")
                showToast(message: "Oops.. we couldn't sign you in via apple, please try again", seconds: 1.3)
                return
            }
        
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("unable to convert token to string")
                showToast(message: "Oops.. we couldn't sign you in via apple, please try again", seconds: 1.3)
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        
            
            //show loader
            self.animationView.alpha = 1
            self.animationView.animation = Animation.named("loading")
            self.animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 200)
            self.animationView.center = self.view.center
            self.animationView.contentMode = .scaleAspectFit
            self.animationView.loopMode = .loop
            self.animationView.play()
            self.view.addSubview(self.animationView)

            //switch views off
            loginView.alpha = 0.2
            
            
            Auth.auth().signIn(with: credential){ (authDataResult, error) in
                if let user = authDataResult?.user{
                    let userId = user.uid
                    let ref = Database.database().reference().child("users")
                    
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in

                        if snapshot.hasChild(userId) {
                            print("user already exists \(userId)")
                            self.transitionToHome()

                        } else {

                            let post: [String: Any] = [
                                "name": appleIDCredentials.fullName?.givenName! ?? "",
                                "surname": appleIDCredentials.fullName?.familyName ?? "",
                                "phoneNumber": "",
                                "password": "Apple Sign In",
                                "email": appleIDCredentials.email ?? "",
                                "country": "",
                                "city": "",
                                "isAdmin": 0,
                                "paid": 0,
                                "remainingSignals": 0,
                                "verified": "true",
                                "signalsLeft": 0,
                                "version": "iOS V1"
                            ]


                            let ref = Database.database().reference().child("users").child(userId)

                            //save user's data
                            ref.setValue(post) { (err, resp) in
                                self.transitionToHome()
                                
                            }
                        }


                    })

                }else{
                    print("got here successfully check you 34567")
                    self.showToast(message: "Ooops... we couldn't sign you in", seconds: 3)
                }
            }
            
        }
    }
    
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("apple signin did not complete \(error)")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding{
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}

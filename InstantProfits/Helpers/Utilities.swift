//
//  Utilities.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 11/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textField:UITextField){
        
        //create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height, width: textField.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        
        textField.borderStyle = .none
        
        textField.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button: UIButton){
        
        //Filled rounded corner Style
        button.backgroundColor = UIColor.init(red: 252/255, green: 173/255, blue: 47/255, alpha: 1)
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }
    
    static func styleFilledButton2(_ button: UIButton){
        
        //Filled rounded corner Style
        button.backgroundColor = UIColor.init(red: 0/255, green: 234/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }
    
    
    static func styleFilledButton3(_ button: UIButton){
        
        //Filled rounded corner Style
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }

    
    static func styleFilledButtonBlack(_ button: UIButton){
        
        //Filled rounded corner Style
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }
    
    static func styleFilledButtonHollowEdge(_ button: UIButton){
        
        //Filled rounded corner Style
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 15.0
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.black.cgColor
        button.tintColor = UIColor.black
        
        
    }
    
    static func styleFilledLabel(_ label: UILabel){
        
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15.0
        label.tintColor = UIColor.white
    }
    
    static func styleFilledTextView(_ textView: UITextView){
        
        
        textView.layer.cornerRadius = 15.0
        textView.tintColor = UIColor.init(red: 0/255, green: 234/255, blue: 255/255, alpha: 1)
    }
    
    static func styleHollowLabel(_ label: UILabel){
        
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 15.0
        label.tintColor = UIColor.init(red: 0/255, green: 234/255, blue: 255/255, alpha: 1)
        label.layer.borderColor = UIColor.orange.cgColor
    }
    
    static func styleFilledLabel2(_ label: UILabel){
        
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 5.0
        label.tintColor = UIColor.init(red: 0/255, green: 234/255, blue: 255/255, alpha: 1)
        label.layer.borderColor = UIColor.black.cgColor
    }
    
    static func styleHollowButton(_ button:UIButton){
        
        //Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5.0
        button.tintColor = UIColor.black
    }
    
    
    static func styleHollowView(_ view:UIView){
        
        //Hollow rounded corner style
        view.layer.cornerRadius = 10.0
    }

    static func isPasswordValid(_ password : String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "ˆ(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}


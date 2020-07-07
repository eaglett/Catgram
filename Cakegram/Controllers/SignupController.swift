//
//  SignupController.swift
//  Cakegram
//
//  Created by Aneja Orlic on 18/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import UIKit
import FirebaseAuth
import NotificationBannerSwift

class SignupController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordRepeatField: UITextField!
    
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        if(usernameField.text!.isEmpty || emailField.text!.isEmpty || phoneField.text!.isEmpty || passwordField.text!.isEmpty){
            //if all fields are not inputed
            let banner = GrowingNotificationBanner(title: "Wrong Input",
                                                   subtitle: "All fields are required!",
                                                   leftView: nil,
                                                   rightView: nil,
                                                   style: .warning,
                                                   colors: nil)
            banner.autoDismiss = false
            banner.dismissOnTap = true
            banner.show()
        } else {
            //check if passwords are the same and 6 chars
            if(passwordField.text! == passwordRepeatField.text! && passwordField.text!.count >= 6){
                //create user
                 Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!) { authResult, error in
                                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                   let frontPage = storyboard.instantiateViewController(identifier: "Frontpage")
                                   frontPage.modalPresentationStyle = .fullScreen
                                   //redirect to the front page so the user can login
                                   self.show(frontPage, sender: self)
                               }
                //add user to db
                DatabaseManager.shared.addUser(username: usernameField.text!, email: emailField.text!, phone: phoneField.text!)
            } else {
                //if passwords don't match
                let banner = GrowingNotificationBanner(title: "Wrong Input",
                                                       subtitle: "Password needs to be at least 6 chars and match the repeated password!",
                                                       leftView: nil,
                                                       rightView: nil,
                                                       style: .warning,
                                                       colors: nil)
                banner.autoDismiss = false
                banner.dismissOnTap = true
                banner.show()
            }
        }
        
        
        
        
    }
    
}

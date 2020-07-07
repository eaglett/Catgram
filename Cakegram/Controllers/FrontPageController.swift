//
//  ViewController.swift
//  Cakegram
//
//  Created by Aneja Orlic on 18/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import UIKit
import FirebaseAuth
import NotificationBannerSwift

class FrontPageController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signupBtnPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupPage = storyboard.instantiateViewController(identifier: "Signup")
        
        show(signupPage, sender: self)
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        if(emailField.text! != "" && passwordField.text! != ""){
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] authResult, error in
              if error == nil { // success
                    
                let user = DatabaseManager.shared.getUser(email: self!.emailField.text!, completion: {user in
                    LoginSession.session.user = user
                })
                  
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let feedPage = storyboard.instantiateViewController(identifier: "TabBarController")
                    feedPage.modalPresentationStyle = .fullScreen

                    self?.show(feedPage, sender: sender)
                
              } else {
                let banner = GrowingNotificationBanner(title: "Wrong Input",
                                                       subtitle: "Email or password is incorrect!",
                                                       leftView: nil,
                                                       rightView: nil,
                                                       style: .warning,
                                                       colors: nil)
                banner.autoDismiss = false
                banner.dismissOnTap = true
                banner.show()
                }
            }
        } else {
            let banner = GrowingNotificationBanner(title: "Wrong Input",
                                                   subtitle: "Both email and password are required!",
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


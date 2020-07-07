//
//  EditProfileController.swift
//  Cakegram
//
//  Created by Aneja Orlic on 24/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import FirebaseAuth

class EditProfileController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = DatabaseManager.shared.getUser(email: LoginSession.session.user.email, completion: { user in
            self.usernameField.placeholder = user.username
            self.phoneField.placeholder = user.phone
        })
    }
    
    @IBAction func resetPasswordBtnPressed(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: LoginSession.session.user.email) { error in
            if let error = error {
                let banner = GrowingNotificationBanner(title: "Error",
                                                       subtitle: "Error occurred. Try again later.",
                                                       leftView: nil,
                                                       rightView: nil,
                                                       style: .warning,
                                                       colors: nil)
                banner.autoDismiss = false
                banner.dismissOnTap = true
                banner.show()
            } else {
                let banner = GrowingNotificationBanner(title: "Success",
                                                       subtitle: "Email has been sent. Follow the instructions to reset password",
                                                       leftView: nil,
                                                       rightView: nil,
                                                       style: .success,
                                                       colors: nil)
                banner.autoDismiss = false
                banner.dismissOnTap = true
                banner.show()
            }
        }
    }
    
    @IBAction func uploadBtnPressed(_ sender: UIButton) {
        presentPhotoActionSheet()
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        //if there were any changes to user data
        if usernameField.text! != "" || phoneField.text! != "" {
            DatabaseManager.shared.updateUser(username: usernameField.text!, phone: phoneField.text!)
        }
        
        //update user info
        DatabaseManager.shared.getUser(email: LoginSession.session.user.email) { user in
            LoginSession.session.user = user
            
            //redirect to profile
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Photo upload",
                                            message: "Do you want to select an existing photo or take a new one?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: { [weak self] _ in
                                            
        }))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in //weaks self so memory retention loop isn't created
                                                self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera () {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker () {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //called when user selects or takes a photo
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        let data = selectedImage.jpegData(compressionQuality: 0.5) as! Data
        let fileName = StorageManager.shared.generateProfileImageName()
        
        StorageManager.shared.uploadPicture(with: data, fileName: fileName, type: "PROFILE", completion: { result in
            switch result {
            case .success(let downloadUrl):
                print(downloadUrl)
            case .failure(let error):
                print(error)
            }
        })
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

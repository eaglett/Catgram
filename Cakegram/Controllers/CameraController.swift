//
//  CameraController.swift
//  Cakegram
//
//  Created by Aneja Orlic on 21/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import UIKit
import Vision
import NotificationBannerSwift

class CameraController: UIViewController{
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var previewLabel: UILabel!
    
    @IBOutlet weak var postHeaderView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var postFooterView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var tabBar: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        postPreview(hidden: true)
    
        presentPhotoActionSheet()
    }
    
    func postPreview(hidden: Bool){
        navigationBar.isHidden = hidden
        previewLabel.isHidden = hidden
        
        postHeaderView.isHidden = hidden
        imageView.isHidden = hidden
        postFooterView.isHidden = hidden
    }
    
    func setupPost(postImage: UIImage, completion: @escaping () -> ()){
        usernameLabel.text = LoginSession.session.user.username
        StorageManager.shared.getUserProfileImage(email: LoginSession.session.user.email){ image in
            self.profileImageView.image = image
        }
        
        imageView.image = postImage
        likeLabel.text = "52"
        completion()
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        postPreview(hidden: true)
        self.presentPhotoActionSheet()
    }
    
    @IBAction func publishBtnPressed(_ sender: UIButton) {
        self.uploadImage(image: imageView.image!){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let feedPage = storyboard.instantiateViewController(identifier: "TabBarController")
            feedPage.modalPresentationStyle = .fullScreen

            self.show(feedPage, sender: self)
        }
    }
    
}

extension CameraController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Photo upload",
                                            message: "Do you want to select an existing photo or take a new one?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: { [weak self] _ in
                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                let feedPage = storyboard.instantiateViewController(identifier: "TabBarController")
                                                feedPage.modalPresentationStyle = .fullScreen
                                        
                                                self?.show(feedPage, sender: self)
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
    
    func detectCat (image: UIImage){
        let formatedImage = CIImage(image: image)
        var catFound = false
        
        let detectAnimalRequest = VNRecognizeAnimalsRequest { (request, error) in
               DispatchQueue.main.async {
                   if let results = request.results?.first as? VNRecognizedObjectObservation {
                       let cats = results.labels.filter({$0.identifier == "Cat"})
                    if(cats.count > 0){
                        //cat found, set up preview
                        self.setupPost(postImage: image){
                            self.postPreview(hidden: false)
                        }
                    }
                   } else { //no cat
                        let banner = GrowingNotificationBanner(title: "No cat found",
                                                               subtitle: "Image does not contain a cat",
                                                               leftView: nil,
                                                               rightView: nil,
                                                               style: .warning,
                                                               colors: nil)
                        banner.autoDismiss = false
                        banner.dismissOnTap = true
                        banner.show()
                        self.presentPhotoActionSheet()
                }
               }
           }
           DispatchQueue.global().async {
               try? VNImageRequestHandler(ciImage: formatedImage!).perform([detectAnimalRequest])
           }
    }
    
    func uploadImage(image: UIImage, completion: @escaping () -> ()){
        let data = image.jpegData(compressionQuality: 0.5) as! Data
        let fileName = StorageManager.shared.generateImageName()
        
        StorageManager.shared.uploadPicture(with: data, fileName: fileName, type: "FEED", completion: { result in
            switch result {
            case .success(let downloadUrl):
                print(downloadUrl)
            case .failure(let error):
                print(error)
            }
        })
        
        DatabaseManager.shared.addImage(name: fileName)
        completion()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //called when user selects or takes a photo
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        //Check if it's a cat
        detectCat(image: selectedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let feedPage = storyboard.instantiateViewController(identifier: "TabBarController")
            feedPage.modalPresentationStyle = .fullScreen
    
            self.show(feedPage, sender: self)
        }
    }
    
}

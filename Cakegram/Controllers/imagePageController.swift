//
//  imagePageController.swift
//  Cakegram
//
//  Created by Aneja Orlic on 27/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import UIKit

class imagePageController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    
    var image = Image()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //likeBtn.isSelected = false
        likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //get image info from DB
         DatabaseManager.shared.getImage(name: LoginSession.session.currentImageRef.name) { currentImage in
             self.image = currentImage
             self.likeBtn.isSelected = currentImage.isImageLiked()
             self.likeLabel.text = String(currentImage.likes.count)
            
             self.usernameLabel.text = currentImage.username
             StorageManager.shared.getUserProfileImage(email: currentImage.email) { image in
                 self.profileImageView.image = image
             }
         }
        
         imageView.image = LoginSession.session.currentImage
    }
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func likeBtnPressed(_ sender: UIButton) {
        //change the state
        likeBtn.isSelected = !likeBtn.isSelected
        
        if(image.isImageLiked()){
            image.unlike()
            self.likeLabel.text = String(image.likes.count)
        } else {
            image.like()
            self.likeLabel.text = String(image.likes.count)
        }
        
    }
    
}

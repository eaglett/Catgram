//
//  ProfileController.swift
//  Cakegram
//
//  Created by Aneja Orlic on 24/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import UIKit
import FirebaseStorage

class ProfileController: UIViewController {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var profileImage: UIImage = UIImage()
    
    @IBOutlet weak var collectionView: UICollectionView!
    var imageRef = Array<StorageReference>()
    var imageDict = Dictionary<Int, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileImage = StorageManager.shared.getUserProfileImage(email: LoginSession.session.user.email, completion:  { image in
            self.imageView.image = image
        })
        
        usernameLabel.text = LoginSession.session.user.username
        
        loadData()
        
    }
    
    func loadData() {
        imageRef = Array<StorageReference>()
        imageDict = Dictionary<Int, UIImage>()
        
        StorageManager.shared.getUserImageReferences(user: LoginSession.session.user.email) {
            StorageManager.shared.getUserImages {
                
                self.imageRef = StorageManager.shared.userImageRef
                self.imageDict = StorageManager.shared.userImageDict
                
                let layout = UICollectionViewFlowLayout()
                layout.itemSize = CGSize(width: 127, height: 127)
                self.collectionView.collectionViewLayout = layout

                self.collectionView.register(FeedCollectionViewCell.nib(), forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)

                self.collectionView.delegate = self.self
                self.collectionView.dataSource = self.self
                self.collectionView.reloadData()
            }
        }
    }
    
    func reloadData(){
        imageRef = Array<StorageReference>()
        imageDict = Dictionary<Int, UIImage>()
        
        StorageManager.shared.getCatImageReferences(nbOfImages: 18){

            StorageManager.shared.getCatImages(){

                self.imageRef = StorageManager.shared.imageRef
                self.imageDict = StorageManager.shared.imageDict
                self.collectionView.reloadData()
            }
        }
    }
    
    
    @IBAction func editProfileBtnClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let feedPage = storyboard.instantiateViewController(identifier: "EditProfile")
        feedPage.modalPresentationStyle = .fullScreen

        show(feedPage, sender: sender)
    }
    
    
    @IBAction func logoutBtnPressed(_ sender: UIButton) {
        LoginSession.session.logout()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let feedPage = storyboard.instantiateViewController(identifier: "Frontpage")
        feedPage.modalPresentationStyle = .fullScreen

        show(feedPage, sender: sender)
    }
    
    
    @IBAction func onCellLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            print("long press began")
            let touchPoint = sender.location(in: sender.view)
            if let indexPath = self.collectionView.indexPathForItem(at: touchPoint) {
                // get the cell at indexPath (the one you long pressed)
                let cell = self.collectionView.cellForItem(at: indexPath) as! FeedCollectionViewCell
                print(cell.name)
                var alert = UIAlertController(title: "Do you want to delete the image?", message: nil, preferredStyle: .alert)
                
                var imageView = UIImageView(frame: CGRect(x: 60, y: 70, width: 180, height: 180))
                let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
                let width = NSLayoutConstraint(item: alert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
                alert.view.addConstraint(height)
                alert.view.addConstraint(width)
                StorageManager.shared.getImageByName(imageName: cell.name){ image in
                    imageView.image = image
                }
                
                alert.view.addSubview(imageView)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                    StorageManager.shared.deleteImageByName(imageName: cell.name){
                        self.loadData()
                    }
                    DatabaseManager.shared.deleteImage(imageName: cell.name)
                }))
                self.present(alert, animated: true)
            }
        }
        
    }
    
}

extension ProfileController: UICollectionViewDelegate {
    //picks up interactions with the cells
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //called when ever we tap one of the cells
        collectionView.deselectItem(at: indexPath, animated: true)
        
        LoginSession.session.currentImage = imageDict[indexPath.item]! //imageArray[indexPath.item]
        LoginSession.session.currentImageRef =  imageRef[indexPath.item]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imagePage = storyboard.instantiateViewController(identifier: "imagePage")
        imagePage.modalPresentationStyle = .fullScreen
        
        show(imagePage, sender: self)
    }
}

extension ProfileController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //how many cells we want to have in a section
        return imageDict.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as! FeedCollectionViewCell
        
        cell.configure(with: imageDict[indexPath.item]!, imageName: imageRef[indexPath.item].name)
    
        return cell as! UICollectionViewCell
    }

}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    //layout customatization
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 127, height: 127)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
}

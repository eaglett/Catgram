//
//  FeedController.swift
//  Cakegram
//
//  Created by Aneja Orlic on 20/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import UIKit
import FirebaseStorage

class FeedController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    var imageRef = Array<StorageReference>()
    var imageDict = Dictionary<Int, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            reloadData{}
        }
    }

    @IBAction func reloadBtnPressed(_ sender: UIButton) {
        sender.isEnabled = false
        reloadData(){
            sender.isEnabled = true
        }
    }

    func loadData() {
        imageRef = Array<StorageReference>()
        imageDict = Dictionary<Int, UIImage>()
        StorageManager.shared.getCatImageReferences(nbOfImages: 18){

            StorageManager.shared.getCatImages(){

                self.imageRef = StorageManager.shared.imageRef
                self.imageDict = StorageManager.shared.imageDict
                
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
    
    func reloadData(completion: @escaping () -> ()){
        imageRef = Array<StorageReference>()
        imageDict = Dictionary<Int, UIImage>()
        
        StorageManager.shared.getCatImageReferences(nbOfImages: 18){

            StorageManager.shared.getCatImages(){

                self.imageRef = StorageManager.shared.imageRef
                self.imageDict = StorageManager.shared.imageDict
                self.collectionView.reloadData()
                completion()
            }

        }
    }
    
}
extension FeedController: UICollectionViewDelegate {
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

extension FeedController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //how many cells we want to have in a section
        return 18
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as! FeedCollectionViewCell
    
        cell.configure(with: imageDict[indexPath.item]!, imageName: imageRef[indexPath.item].name)
    
        return cell as! UICollectionViewCell
    }

}

extension FeedController: UICollectionViewDelegateFlowLayout {
    //layout customatization
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 127, height: 127)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
}



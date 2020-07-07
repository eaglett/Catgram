//
//  FeedCollectionViewCell.swift
//  Cakegram
//
//  Created by Aneja Orlic on 21/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    var name = ""
    
    static let identifier = "FeedCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //when dequing our cell we can call this directly(instead of accessing imageView)
    public func configure(with image: UIImage, imageName: String){
        imageView.image = image
        name = imageName
    }
    
    static func nib() -> UINib {
        //registrating the cell through the nib (registrating to the Feed COntroller)
        return UINib(nibName: "FeedCollectionViewCell", bundle: nil)
    }
}

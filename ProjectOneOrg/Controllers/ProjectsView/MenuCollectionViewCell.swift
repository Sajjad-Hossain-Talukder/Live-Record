//
//  MenuCollectionViewCell.swift
//  ProjectOneOrg
//
//  Created by Xotech on 24/01/2024.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        menuImage.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04).cgColor
        menuImage.layer.shadowOpacity = 0.2
        menuImage.layer.shadowOffset = CGSize(width: 2, height: 2)
        menuImage.layer.shadowRadius = 1
        
    }

}

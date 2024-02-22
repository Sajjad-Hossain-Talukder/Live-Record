//
//  BannerCollectionViewCell.swift
//  ProjectOneOrg
//
//  Created by Xotech on 23/01/2024.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var bannerView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerView.layer.cornerRadius = 12
    }

}

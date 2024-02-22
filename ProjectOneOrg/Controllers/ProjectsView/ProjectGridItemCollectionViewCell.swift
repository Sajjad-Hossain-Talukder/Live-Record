//
//  ProjectGridItemCollectionViewCell.swift
//  ProjectOneOrg
//
//  Created by Xotech on 25/01/2024.
//

import UIKit

class ProjectGridItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var editButton: UIImageView!
    @IBOutlet weak var itemSize: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 16
       
    }

}

//
//  ProjectListItemCollectionViewCell.swift
//  ProjectOneOrg
//
//  Created by Xotech on 25/01/2024.
//

import UIKit

class ProjectListItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemSize: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
    }

}

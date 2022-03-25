//
//  ContentCollectionViewCell.swift
//  test-alabs
//
//  Created by ryan on 18.03.2022.
//

import UIKit

class ContentViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentImage: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentImage.image = nil
    }
}

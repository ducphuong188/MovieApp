//
//  CollectionViewCell.swift
//  Netflix
//
//  Created by macbook on 16/08/2023.
//

import UIKit
import SDWebImage
class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(image)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        image.frame = contentView.frame
    }
    public func confige(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        image.sd_setImage(with: url)
        
    }
    
}


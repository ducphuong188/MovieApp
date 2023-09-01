//
//  SeachUpdateTableViewCell.swift
//  Netflix
//
//  Created by macbook on 16/08/2023.
//

import UIKit

class SeachUpdateTableViewCell: UITableViewCell {
static let identifier = "SeachUpdateTableViewCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(playButton)
        contentView.addSubview(label)
        contentView.addSubview(image)
        setupConstrain()
    }
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        return button
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    required init?(coder: NSCoder) {
        fatalError()
    }
    func setupConstrain() {
        let buttonConstrain = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        let imageConstain = [
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            image.widthAnchor.constraint(equalToConstant: 100)
            ]
        let labelConstain = [
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(buttonConstrain)
        NSLayoutConstraint.activate(labelConstain)
        NSLayoutConstraint.activate(imageConstain)
    }
    func confige(with models: TitleViewModel) {
        label.text = models.titleName
        guard let url =  URL(string: "https://image.tmdb.org/t/p/w500/\(models.posterURL)") else {
            return
        }
        image.sd_setImage(with: url)
    }
}

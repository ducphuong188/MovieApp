//
//  CollectionViewInTabbleViewCell.swift
//  Netflix
//
//  Created by macbook on 13/08/2023.
//

import UIKit
protocol CollectionViewInTabbleViewCellDelegate: AnyObject {
    func collectionViewInTabbleViewCellTapCell(viewModel: TitlePreviewViewModel)
}
class CollectionViewInTabbleViewCell: UITableViewCell {
    var delegate: CollectionViewInTabbleViewCellDelegate?
    var models = [Title]()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        return collection
    }()
   static let identifier = "CollectionViewInTabbleViewCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBlue
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    func config(with models: [Title]) {
        self.models = models
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    private func downloadTitleAt(indexPath: IndexPath) {
        
    
        DataPersistenceManager.shared.downloadTitleWith(model: models[indexPath.row]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        

    }
}
extension CollectionViewInTabbleViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        guard let model = models[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.confige(with: model)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = models[indexPath.row]
        guard  let titleName = model.original_title else {return}
        guard let titleview = model.overview else {return}
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let success):
                
                let title = TitlePreviewViewModel(title: titleName, youtubeView: success, titleOverview: titleview)
                self?.delegate?.collectionViewInTabbleViewCellTapCell( viewModel: title)
                print(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        
        return config
    }
    
}

//
//  SeachVC.swift
//  Netflix
//
//  Created by macbook on 13/08/2023.
//

import UIKit

class SearchVC: UIViewController {
    var models = [Title]()
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(SeachUpdateTableViewCell.self, forCellReuseIdentifier: SeachUpdateTableViewCell.identifier)
        return tableView
    }()
    private let search: UISearchController = {
        let search = UISearchController(searchResultsController: SearchResultsViewController())
        search.searchBar.placeholder = "Search for a Movie or a Tv show"
        return search
    }()
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        title = "Search Movies"
        navigationItem.searchController = search
        navigationController?.navigationBar.tintColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        search.searchResultsUpdater = self

    }
    func getData() {
        APICaller.shared.getDiscoverMovies { result in
            switch result {
            case .success(let success):
                self.models = success
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }


}
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SeachUpdateTableViewCell.identifier, for: indexPath) as! SeachUpdateTableViewCell
        let model = models[indexPath.row]
        cell.confige(with: TitleViewModel(titleName: model.original_title!, posterURL: model.poster_path!))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = models[indexPath.row]
        
        guard let titleName = title.original_title  else {
            return
        }
        
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = PreviewVC()
                    vc.confige(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension SearchVC: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                  return
              }
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewVC()
            vc.confige(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


//
//  UpdateVC.swift
//  Netflix
//
//  Created by macbook on 13/08/2023.
//

import UIKit

class UpdateVC: UIViewController {
    var models = [Title]()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SeachUpdateTableViewCell.self, forCellReuseIdentifier: SeachUpdateTableViewCell.identifier)
        return tableView
        
    }()
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        title = "Update Movies"
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        view.addSubview(tableView)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    func getData() {
        APICaller.shared.getUpcomingMovies { result in
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
extension UpdateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SeachUpdateTableViewCell.identifier) as! SeachUpdateTableViewCell
        cell.confige(with: TitleViewModel(titleName: models[indexPath.row].original_title!, posterURL: models[indexPath.row].poster_path!))
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

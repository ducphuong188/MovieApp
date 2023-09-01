//
//  HomeVC.swift
//  Netflix
//
//  Created by macbook on 13/08/2023.
//

import UIKit
enum Section: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}
class HomeVC: UIViewController {
    private var randomTrendingMovie: Title?
    private var headerView: HeaderView?
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewInTabbleViewCell.self, forCellReuseIdentifier: CollectionViewInTabbleViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 500))
        tableView.tableHeaderView = headerView
        CreatHeaderView()
        configureNavbar()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .black
    }
    private func CreatHeaderView() {

        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let erorr):
                print(erorr.localizedDescription)
            }
        }
        


    }
    
}
extension HomeVC: UITableViewDelegate, UITableViewDataSource, CollectionViewInTabbleViewCellDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewInTabbleViewCell", for: indexPath) as! CollectionViewInTabbleViewCell
        cell.delegate = self
        switch indexPath.section {
        case Section.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { results in
                switch results {
                case .success(let success):
                    cell.config(with: success)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        case Section.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { resul in
                switch resul {
                case .success(let success):
                    cell.config(with: success)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        case Section.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let success):
                    cell.config(with: success)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        case Section.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let success):
                    cell.config(with: success)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        case Section.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let success):
                    cell.config(with: success)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .red
    }
    func collectionViewInTabbleViewCellTapCell( viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewVC()
            vc.confige(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

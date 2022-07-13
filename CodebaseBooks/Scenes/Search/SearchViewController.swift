//
//  SearchViewController.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/05.
//

import UIKit
import Alamofire
import Moya

class SearchViewController: UIViewController {
    var bookList = [Book]()
    var filteredData = [Book]()
    var searchBarWord = ""
    var searchTimer: Timer?
    let searchController = UISearchController(searchResultsController: nil)
    let service = MoyaProvider<APIService>()
    
    var isFiltering: Bool {
        let searchController = navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    private lazy var searchTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
        $0.register(SearchTableCell.self, forCellReuseIdentifier: "SearchTableCell")
    }
    
    private lazy var noLabel = UILabel().then {
        $0.text = "결과가 없습니다."
        $0.font = .systemFont(ofSize: 23, weight: .bold)
    }
    
    // MARK: - ViewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        navigationSearch()
    }
    
    //MARK: - Functions
    private func setupLayout() {
        view.addsubViews([searchTableView, noLabel])
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        noLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func navigationSearch() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search Books"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.placeholder = "검색어를 입력해보세요."
        searchController.searchResultsUpdater = self
    }
}

// MARK: - Extension (Delegate, DataSource)
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newDetailVC = NewDetailViewController()
        newDetailVC.prepareBook = self.bookList[indexPath.row]
        navigationController?.pushViewController(newDetailVC, animated: true)
    }
}

extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredData.count : self.bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as? SearchTableCell else { return UITableViewCell()}
        
        if self.isFiltering {
            if filteredData.count != 0  {
                cell.configureView(with: filteredData[indexPath.row])
                noLabel.isHidden = true
            }
        } else {
            cell.configureView(with: bookList[indexPath.row])
            noLabel.isHidden = true
        }
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        /// searchbar에 입력한 텍스트
        guard let text = searchController.searchBar.text else { return }
        searchBarWord = text
        
        noLabel.isHidden = filteredData.isEmpty ? false : true
        searchTableView.reloadData()
        searchTimer?.invalidate()
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: { [weak self] timer in            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let `self` = self else { return }
            
            // MoyaProvider를 통해 request를 실행합니다.
            self.service.request(APIService.search(query: self.searchBarWord)) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    do {
                        print("text = \(text)")
                        let books = try JSONDecoder().decode(BookModel.self, from: response.data)
                        self.bookList = books.books
                        self.filteredData = self.bookList.filter { $0.title.localizedCaseInsensitiveContains(self.searchBarWord)}
                        
                        DispatchQueue.main.async {
                            print("filteredData = \(self.filteredData)")
                            self.searchTableView.reloadData()
                        }
                    } catch(let err) {
                        print(err.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        })
    }
}


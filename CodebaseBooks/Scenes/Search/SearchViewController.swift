//
//  SearchViewController.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/05.
//

import Foundation
import UIKit
import Alamofire

class SearchViewController: UIViewController {
    
    var bookList = [Book]()
    var filteredData = [Book]()
    var searchBarWord = ""
    var searchTimer: Timer?
    let searchController = UISearchController(searchResultsController: nil)
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchTableCell.self, forCellReuseIdentifier: "SearchTableCell")
        
        return tableView
    }()
    
    private lazy var noLabel: UILabel = {
        let label = UILabel()
        label.text = "결과가 없습니다."
        label.font = .systemFont(ofSize: 23, weight: .bold)
        
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        navigationSearch()
        
    }
    
    //MARK: - Functions
    func setup() {
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
    
    func navigationSearch() {
        navigationItem.searchController = searchController
        self.navigationItem.title = "Search Books"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.placeholder = "검색어를 입력해보세요."
        searchController.searchResultsUpdater = self
//        noLabel.isHidden = true
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
        
        self.navigationController?.pushViewController(newDetailVC, animated: true)
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
                cell.setup()
                cell.configureView(with: filteredData[indexPath.row])
                self.noLabel.isHidden = true
            }
        } else {
            cell.setup()
            cell.configureView(with: bookList[indexPath.row])
            self.noLabel.isHidden = true
        }
        return cell
    }
}



extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        /// searchbar에 입력한 텍스트
        guard let text = searchController.searchBar.text else { return }
        self.searchBarWord = text
        self.noLabel.isHidden = filteredData.isEmpty ? false : true
        self.searchTableView.reloadData()
        
        self.searchTimer?.invalidate()
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: { [weak self] timer in            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let `self` = self else { return }

                AF.request("https://api.itbook.store/1.0/search/" + self.searchBarWord)
                        .validate()
                        .responseDecodable(of: BookModel.self) { data in
                        guard let books = data.value else {
                            print("responseDecodable ERROR")
                            return
                        }
                            self.bookList = books.books
                            self.filteredData = self.bookList.filter { $0.title.localizedCaseInsensitiveContains(self.searchBarWord)}
                            print("self.bookList = books.books =\(self.bookList)")
                            self.searchTableView.reloadData()
                    }
            }
        })
    }
}


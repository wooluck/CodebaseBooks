//
//  SearchViewController.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/05.
//

import Foundation
import UIKit

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
//        tableView.backgroundColor = .red
        
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
        //        searchController.searchBar.delegate = self
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
        //        return self.bookList.count
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
            cell.configureView(with: bookList[indexPath.row])
            cell.setup()
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
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: { [weak self] timer in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let `self` = self else { return }
                
                Task {
                    do {
                        let books = try await NetworkManager.shared.loadSearchBook(query: self.searchBarWord)
                        
                        self.bookList = books
                        print("bookList = \(self.bookList.count)")
                        self.filteredData = self.bookList.filter { $0.title.localizedCaseInsensitiveContains(self.searchBarWord)}
                        print("filterData = \(self.filteredData)")
                        
                        DispatchQueue.main.async {
                            self.searchTableView.reloadData()
                        }
                    } catch {
                        print("Response Error: \(error) @@ \(error.localizedDescription)")
                    }
                }
            }
        })
    }
}


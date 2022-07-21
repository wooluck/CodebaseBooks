//
//  SearchViewController.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/05.
//

import UIKit
import Alamofire
import Moya
import RxSwift
import RxCocoa
import SafariServices

class SearchViewController: UIViewController {
    var disposeBag = DisposeBag()
    var bookList = [Book]()
    var filteredData = [Book]()
    var searchBarWord = ""
    let searchController = UISearchController(searchResultsController: nil)
    let service = MoyaProvider<APIService>()
    
    // 혹시 몰라냅둠.
    //    private var isFiltering: Bool {
    //        let searchController = navigationItem.searchController
    //        let isActive = searchController?.isActive ?? false
    //        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
    //        return isActive && isSearchBarHasText
    //    }
    
    private lazy var searchTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(SearchTableCell.self, forCellReuseIdentifier: "SearchTableCell")
        $0.rowHeight = 280
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
        navigationSearch()
        writeInSeachBar()
        bindData()
        setupLayout()
    }
    
    //MARK: - Functions
    
    private func bindData() {
        // 테이블뷰 클릭시
        searchTableView.rx.modelSelected(Book.self)
            .subscribe(onNext: { [weak self] member in
                guard let self = self else { return }
                self.navigationController?.pushViewController(NewDetailViewController(member), animated: true)
            }).disposed(by: disposeBag)
    }
    
    
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
        navigationItem.title = "Search Book"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .clear
        searchController.searchBar.placeholder = "검색어를 입력해보세요."
    }
    
    private func writeInSeachBar() {
        self.noLabel.isHidden = self.filteredData.isEmpty ? false : true
        searchController.searchBar.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { text in
                self.service.request(APIService.search(query: text)) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let response):
                        do {
                            let books = try JSONDecoder().decode(BookModel.self, from: response.data)
                            self.bookList = books.books
                            self.filteredData = self.bookList.filter { $0.title.localizedCaseInsensitiveContains(text)}
                            if self.filteredData.count != 0 {
                                self.noLabel.isHidden = true
                            } else if self.filteredData.count == 0 {
                                self.noLabel.isHidden = false
                            }
                            self.bindTableView(self.filteredData)
                        } catch(let err) {
                            print(err.localizedDescription)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindTableView(_ data: [Book]) {
        self.searchTableView.dataSource = nil
        Observable.of(data)
            .bind(to: self.searchTableView.rx.items(cellIdentifier: "SearchTableCell", cellType: SearchTableCell.self)) { row, element, cell in
                cell.configureView(with: element)
                
                cell.searchLinkButton.rx.tap
                    .subscribe(onNext: {
                        let safari = Safari()
                        self.present(safari.safari(data: element.isbn13), animated: true, completion: nil)
                    }).disposed(by: self.disposeBag)
            }.disposed(by: self.disposeBag)
    }
}

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

enum cellSelect {
    case main
    case filter
}

class SearchViewController: UIViewController, UITableViewDelegate {
    var disposeBag = DisposeBag()
    var bookList = [Book]()
    let searchController = UISearchController(searchResultsController: nil)
    let service = MoyaProvider<APIService>()
    let searchViewModel = SearchViewModel()
    // input
    let inputTrigger = PublishRelay<SearchActionType>()
    // output
    var searchBookList = BehaviorRelay<[Book]>(value: [])
    
    var enumValue = PublishRelay<cellSelect>()
    
    
    private lazy var searchTableView = UITableView().then {
        $0.register(SearchEmptyTableCell.self, forCellReuseIdentifier: SearchEmptyTableCell.id)
        $0.register(SearchWritingTableCell.self, forCellReuseIdentifier: "SearchWritingTableCell")
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
        tableSelected()
        setupLayout()
        bindingViewModel()
        
        enumValue.bind(onNext: useEnum(_:))
            .disposed(by: disposeBag)
    }
    
    //MARK: - Functions
    private func bindingViewModel() {
        let request = searchViewModel.transform(input: SearchViewModel.Input.init(inputTrigger: inputTrigger))
        
        inputTrigger.accept(.first)
        
        request.searchBookList
            .bind(to: self.searchBookList)
            .disposed(by: disposeBag)
        enumValue.accept(.main)
        
        searchController.searchBar.rx.text 
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.inputTrigger.accept(.searchBarClick($0 ?? ""))
            }).disposed(by: disposeBag)
        
        
        request.searchFilterBookList
            .bind(to: self.searchBookList)
            .disposed(by: self.disposeBag)
        enumValue.accept(.filter)
        self.searchTableView.delegate = nil

    }
    
    private func useEnum(_ type: cellSelect) {
        switch type {
        case .main:
            self.searchBookList
                .bind(to: searchTableView.rx.items(cellIdentifier: SearchEmptyTableCell.id, cellType: SearchEmptyTableCell.self)) { row, element, cell in
                    cell.configureView(with: element)
                    cell.searchLinkButton.rx.tap
                        .subscribe(onNext: {
                            let safari = Safari()
                            self.present(safari.safari(data: element.isbn13), animated: true, completion: nil)
                        }).disposed(by: self.disposeBag)
                }.disposed(by: disposeBag)
            
        case .filter:
            self.searchBookList
                .bind(to: searchTableView.rx.items(cellIdentifier: "SearchWritingTableCell", cellType: SearchWritingTableCell.self)) { row, element, cell in
                    cell.configureView(with: element)
                }.disposed(by: disposeBag)
        }
    }
    
    
    private func tableSelected() {
        // 테이블뷰 클릭시
        searchTableView.rx.modelSelected(Book.self)
            .subscribe(onNext: { [weak self] member in
                guard let self = self else { return }
                self.navigationController?.pushViewController(NewDetailViewController(member), animated: true)
            }).disposed(by: disposeBag)
    }
    
    
    private func setupLayout() {
        view.addsubViews([searchTableView, noLabel])
        self.searchTableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        noLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func navigationSearch() {
        navigationItem.searchController = searchController
        //        searchTableView.tableHeaderView = searchController.searchBar
        navigationItem.title = "Search Book"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .clear
        searchController.searchBar.placeholder = "검색어를 입력해보세요."
    }
}

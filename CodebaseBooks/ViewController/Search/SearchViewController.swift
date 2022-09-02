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
    var searchFilterBookList = BehaviorRelay<[Book]>(value: [])
    
    
    private lazy var searchTableView = UITableView().then {
        $0.register(SearchEmptyTableCell.self, forCellReuseIdentifier: SearchEmptyTableCell.id)
        //        $0.register(SearchWritingTableCell.self, forCellReuseIdentifier: "SearchWritingTableCell")
        $0.rowHeight = 280
    }
    private lazy var searchFilterTableView = UITableView().then {
        //        $0.register(SearchEmptyTableCell.self, forCellReuseIdentifier: SearchEmptyTableCell.id)
        $0.register(SearchWritingTableCell.self, forCellReuseIdentifier: "SearchWritingTableCell")
        $0.rowHeight = 150
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
    }
    
    //MARK: - Functions
    private func bindingViewModel() {
        let request = searchViewModel.transform(input: SearchViewModel.Input.init(inputTrigger: inputTrigger))
        
        inputTrigger.accept(.first)
        
        request.searchBookList
            .bind(to: self.searchBookList)
            .disposed(by: disposeBag)
        
//        self.searchBookList
//            .bind(to: searchTableView.rx.items(cellIdentifier: SearchEmptyTableCell.id, cellType: SearchEmptyTableCell.self)) { row, element, cell in
//                cell.configureView(with: element)
//                cell.searchLinkButton.rx.tap
//                    .subscribe(onNext: {
//                        let safari = Safari()
//                        self.present(safari.safari(data: element.isbn13), animated: true, completion: nil)
//                    }).disposed(by: self.disposeBag)
//            }.disposed(by: disposeBag)
//
        
        searchController.searchBar.rx.text
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.inputTrigger.accept(.searchBarClick($0 ?? ""))
                
                // 기존 테이블 없애고, 그럼 바인드 되잇으니까 데이터 사라지고
//                self.searchBookList = BehaviorRelay<[Book]>(value: [])
//                self.searchBookList.accept([])
                
                request.searchFilterBookList
                    .bind(to: self.searchFilterBookList)
                    .disposed(by: self.disposeBag)
                
                self.searchFilterTableView.delegate = nil

                self.searchFilterBookList
                    .bind(to: self.searchFilterTableView.rx.items(cellIdentifier: "SearchWritingTableCell", cellType: SearchWritingTableCell.self)) { row, element, cell in
                        cell.configureView(with: element)

                    }.disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
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
        view.addsubViews([searchTableView, searchFilterTableView, noLabel])
        searchBookList.subscribe(onNext: { text in
            if text.count != 0 {
                self.searchTableView.snp.makeConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide)
                    $0.bottom.equalToSuperview()
                    $0.leading.trailing.equalToSuperview().inset(20)
                }
            } else if text.count == 0 {
                self.searchFilterTableView.snp.makeConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide)
                    $0.bottom.equalToSuperview()
                    $0.leading.trailing.equalToSuperview().inset(20)
                }
            }
        }).disposed(by: self.disposeBag)
        
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

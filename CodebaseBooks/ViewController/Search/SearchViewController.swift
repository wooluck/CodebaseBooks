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
    var filteredData = BehaviorRelay<[Book]>(value: [])
    let searchController = UISearchController(searchResultsController: nil)
    let service = MoyaProvider<APIService>()
    
    let searchViewModel = SearchViewModel()
    let inputTrigger = PublishRelay<SearchActionType>()
    var searchBookList = BehaviorRelay<[Book]>(value: [])
    
    
    private lazy var searchTableView = UITableView().then {
        $0.register(SearchEmptyTableCell.self, forCellReuseIdentifier: SearchEmptyTableCell.id)
        $0.register(SearchWritingTableCell.self, forCellReuseIdentifier: "SearchWritingTableCell")
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
        bindData()
        bindingViewModel()
        
    }
    
    
    //MARK: - Functions
    private func bindingViewModel() {
        let request = searchViewModel.transform(input: SearchViewModel.Input.init(inputTrigger: inputTrigger.asObservable()))
        
        
        self//.setupDI(relay: inputTrigger)
            .setupDI(observable: request.searchBookList)
    }
    
    private func bindData() {
        searchController.searchBar.rx.text
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.inputTrigger.accept(.normal($0 ?? ""))
                
            }).disposed(by: disposeBag)
        
//        let text = searchController.searchBar.rx.text
//            .map { value in
//
//                .normal("") }
//            .bind(to: inputTrigger)
    }
    
    
    @discardableResult
    func setupDI(relay: PublishRelay<SearchActionType>) -> Self {
        inputTrigger.bind(to: relay).disposed(by: disposeBag)
        return self
    }
    
    @discardableResult
    func setupDI(observable: Observable<[Book]>) -> Self {
        observable
            .bind(to: searchTableView.rx.items(cellIdentifier: SearchEmptyTableCell.id, cellType: SearchEmptyTableCell.self)) { row, element, cell in
                cell.configureView(with: element)
            }.disposed(by: disposeBag)
        return self
    }
    
    
    
    
    
    
    private func bindEmptyTableView(_ data: BehaviorRelay<[Book]>) {
        data
            .asDriver(onErrorJustReturn: [])
            .drive(self.searchTableView.rx.items(cellIdentifier: SearchEmptyTableCell.id, cellType: SearchEmptyTableCell.self)) { row, element, cell in
                print("오지도않음2222 ")
                cell.configureView(with: element)
                //                cell.searchLinkButton.rx.tap
                //                    .subscribe(onNext: {
                //                        let safari = Safari()
                //                        self.present(safari.safari(data: element.isbn13), animated: true, completion: nil)
                //                    }).disposed(by: self.disposeBag)
            }.disposed(by: self.disposeBag)
        
    }
    
    private func bindTableView(_ data: [Book]) {
        self.searchTableView.dataSource = nil
        Observable.of(data)
            .bind(to: self.searchTableView.rx.items(cellIdentifier: "SearchWritingTableCell", cellType: SearchWritingTableCell.self)) { row, element, cell in
                cell.configureView(with: element)
                
                cell.searchLinkButton.rx.tap
                    .subscribe(onNext: {
                        let safari = Safari()
                        self.present(safari.safari(data: element.isbn13), animated: true, completion: nil)
                    }).disposed(by: self.disposeBag)
            }.disposed(by: self.disposeBag)
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
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            //            if self.filteredData.count == 0 {
            //                $0.leading.trailing.equalToSuperview().inset(20)
            //            } else {
            //                $0.leading.trailing.equalToSuperview()
            //            }
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

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
    let isRxFiltering = PublishSubject<Bool>()
    
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
        
        
//        let isRxFiltering = PublishRelay<Bool>()
//        isRxFiltering
//            .bind(onNext: {_ in
//                if self.searchController.isActive && ((self.searchController.searchBar.text?.isEmpty) != nil) {
//                    self.isRxFiltering.onNext(true)
//
//                } else {
//                    self.isRxFiltering.onNext(false)
//                }
//            }).disposed(by: disposeBag)
        
        
//            . subscribe {
//                if self.searchController.isActive && ((self.searchController.searchBar.text?.isEmpty) != nil) {
//                    self.isRxFiltering.onNext(true)
//                } else {
//                    self.isRxFiltering.onNext(false)
//                }
//            }.disposed(by: disposeBag)
        
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
                            print("filteredData, noLabel -->> \(self.filteredData) || \(self.noLabel.isHidden)")
                            
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
                
                self.isRxFiltering
                    .bind(onNext: {_ in
                        if self.searchController.isActive && ((self.searchController.searchBar.text?.isEmpty) != nil) {
                            self.isRxFiltering.onNext(true)
                            print("isRxFiltering ---> \(self.isRxFiltering.onNext)")
                            cell.configureView(with: self.filteredData[row])
                            self.noLabel.isHidden = false
                            
                        } else {
                            self.isRxFiltering.onNext(false)
                            cell.configureView(with: element)
                            self.noLabel.isHidden = true
                        }
                    }).disposed(by: self.disposeBag)
                
//                cell.configureView(with: element)
                print("element : ->>>> \(element)")
                
//                let ps = PublishSubject<Bool>()
//                ps.onNext( {
//
//                })
                
//                    ps.bind(onNext: { _ in
//                    if self.searchController.isActive && ((self.searchController.searchBar.text?.isEmpty) != nil) {
//                        cell.configureView(with: self.filteredData[row])
//                        self.noLabel.isHidden = true
//                    } else {
//                        cell.configureView(with: element)
//                        self.noLabel.isHidden = true
//                    }
//                }).disposed(by: self.disposeBag)
                
//                Observable<Bool>.create { bool in
//                    // 검색을 시작하면,
//                    if self.searchController.isActive && ((self.searchController.searchBar.text?.isEmpty) != nil) {
//                        bool.onNext(true)
//                    } else {
//                        bool.onNext(false)
//                    }
//                    return Disposables.create()
//                    // 이제 데이터변화를 감지하며 실행한다.
//                }.subscribe(onNext: { bool in
//                    // 프린트문이 한번밖에 안찍힌다. 옵저버는 계속 실시간으로 지켜보는거 아닌가 ?
//                    print("onNext bool --> \(bool)")
//                    if bool == true {
//                        cell.configureView(with: self.filteredData[row])
//                        self.noLabel.isHidden = true
//                    } else if bool == false {
//                        cell.configureView(with: element)
//                        self.noLabel.isHidden = true
//                    }
//                }).disposed(by: self.disposeBag)
                
                
//                self.isRxFiltering
//                    .bind(onNext: {_ in
//                        if self.searchController.isActive && ((self.searchController.searchBar.text?.isEmpty) != nil) {
//                            self.isRxFiltering.onNext(true)
//                            print("isRxFiltering ---> \(self.isRxFiltering.onNext)")
//                            cell.configureView(with: self.filteredData[row])
//                            self.noLabel.isHidden = false
//
//                        } else {
//                            self.isRxFiltering.onNext(false)
//                            cell.configureView(with: element)
//                            self.noLabel.isHidden = true
//                        }
//                    }).disposed(by: self.disposeBag)
                
                
                
//                self.isRxFiltering
//                    .bind(onNext: {_ in
//                        if self.searchController.isActive && ((self.searchController.searchBar.text?.isEmpty) != nil) {
//                            self.isRxFiltering.onNext(true)
//                            print("isRxFiltering ---> \(self.isRxFiltering.onNext)")
//                            cell.configureView(with: self.filteredData[row])
//                            self.noLabel.isHidden = false
//
//                        } else {
//                            self.isRxFiltering.onNext(false)
//                            cell.configureView(with: element)
//                            self.noLabel.isHidden = true
//                        }
//                    }).disposed(by: self.disposeBag)
//
//                self.isRxFiltering
//                    .onNext(<#T##element: Bool##Bool#>)
//                    if self.filteredData.count != 0  {
//                        cell.configureView(with: self.filteredData[row])
//                        self.noLabel.isHidden = true
//                    }
//                } else {
//                    cell.configureView(with: element)
//                    self.noLabel.isHidden = true
//                }
                
                
                
//                if self.isRxFiltering  {
//                    if self.filteredData.count != 0  {
//                        cell.configureView(with: self.filteredData[row])
//                        self.noLabel.isHidden = true
//                    }
//                } else {
//                    cell.configureView(with: element)
//                    self.noLabel.isHidden = true
//                }
                cell.searchLinkButton.rx.tap
                    .subscribe(onNext: {
                        let safari = Safari()
                        self.present(safari.safari(data: element.isbn13), animated: true, completion: nil)
                    }).disposed(by: self.disposeBag)
            }.disposed(by: self.disposeBag)
    }
}

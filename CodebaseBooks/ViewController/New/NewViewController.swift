//
//  NewViewController.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/05.
//

import UIKit
import Alamofire
import Moya
import Then
import RxSwift
import RxCocoa
import SafariServices

class NewViewController: UIViewController {
    var disposeBag = DisposeBag()
    let inputTrigger = PublishRelay<NewActionType>()
    let clickBookTrigger = PublishRelay<Bool>()
    let newViewModel = NewViewModel()
    lazy var newView = NewView()
    
    // make Moya provder
    let service = MoyaProvider<APIService>()

    // MARK: - ViewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        navigationSet()
//        readBooks()
//        refreshSetting()
        bindData()
        
    }
    
    // MARK: - Functions
    
    private func setupLayout() {
        view.addSubview(newView)
        
        newView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
//    private func refreshSetting() {
//        refreshControl.endRefreshing() // 초기화 - refresh 종료
//        newTableView.refreshControl = refreshControl
//
//        let refreshLoading = PublishRelay<Bool>()
//        refreshControl.rx.controlEvent(.valueChanged)
//            .observe(on: MainScheduler.instance)
//            .bind(onNext: {
//                self.newTableView.dataSource = nil
////                self.readBooks()
//                refreshLoading.accept(false)
//            }).disposed(by: disposeBag)
//
//        refreshLoading
//            .bind(to: refreshControl.rx.isRefreshing)
//            .disposed(by: disposeBag)
//    }
    
//    private func readBooks() {
//        // MoyaProvider를 통해 request를 실행합니다.
//        service.request(APIService.new) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                do {
//                    let books = try JSONDecoder().decode(BookModel.self, from: response.data)
//                    self.bindTableView(data: books.books)
//                } catch(let err) {
//                    print("error : \(err)")
//                    self.alertShow()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
//    private func bindTableView(data: [Book]) {
//        Observable.of(data)
//            .bind(to: newTableView.rx.items(cellIdentifier: "NewTableCell", cellType: NewTableCell.self)) { row, element, cell in
//                cell.configureView(with: element)
//                cell.newLinkButton.rx.tap
//                    .subscribe(onNext: {
//                        self.present(SafariView(path: element.isbn13), animated: true, completion: nil)
//                    }).disposed(by: self.disposeBag)
//            }.disposed(by: disposeBag)
//    }
    
//    private func alertShow() {
//        let alert = UIAlertController(title: "알림", message: "API 호출 실패하였습니다.", preferredStyle: UIAlertController.Style.alert)
//        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
//        alert.addAction(cancelAction)
//        self.present(alert, animated: false)
//    }
    
//    private func setupLayout() {
//        view.addSubview(newTableView)
//        newTableView.snp.makeConstraints {
//            $0.top.bottom.equalToSuperview()
//            $0.leading.trailing.equalToSuperview().inset(20)
//        }
////        self.newTableView.scrollIndicatorInsets = .zero
//    }
    
    private func navigationSet() {
        navigationItem.title = "New Books"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // ViewModel에서 받아온 데이터 View로 넘겨줄게 ~
    private func bindData() {
        let request = newViewModel.transform(input: NewViewModel.Input.init(inputTrigger: inputTrigger))
        print("@@@@@@@@@@@@@@@ \(request)")
        newView.bookLoadDI(relay: request.newBookRelay)
        
        inputTrigger.accept(.tt)
        
        newView
            .setupDI(relay: inputTrigger)
            
        
        // MARK: ROUTE
        self.routeDI(observable: request.navigateToDetail)
    }
    
    @discardableResult
    func routeDI<T>(observable: Observable<T>) -> Self {
        if let ob = observable as? Observable<Book> {
            ob.subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                let detailVC = NewDetailViewController($0)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }).disposed(by: disposeBag)
        }
        return self
    }
}








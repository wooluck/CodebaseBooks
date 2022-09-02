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
        bindData()
    }
    
    // MARK: - Functions
    
    private func setupLayout() {
        view.addSubview(newView)
        newView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func navigationSet() {
        navigationItem.title = "New Books"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // ViewModel에서 받아온 데이터 View로 넘겨줄게 ~
    private func bindData() {
        let request = newViewModel.transform(input: NewViewModel.Input.init(inputTrigger: inputTrigger))
        
        inputTrigger.accept(.normal)
        
        newView.bookLoadDI(relay: request.newBookRelay)
        
        newView.setupDI(relay: inputTrigger)
            
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
}








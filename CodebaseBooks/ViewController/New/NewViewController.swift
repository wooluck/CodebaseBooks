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
    
    // make Moya provder
    let service = MoyaProvider<APIService>()
    
    private var refreshControl = UIRefreshControl()
    
    private lazy var newTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(NewTableCell.self, forCellReuseIdentifier: "NewTableCell")
        $0.rowHeight = 280
    }
    
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
        readBooks()
        refreshSetting()
        bindData()
    }
    
    // MARK: - Functions
    private func refreshSetting() {
        refreshControl.endRefreshing() // 초기화 - refresh 종료
        refreshControl.backgroundColor = UIColor.clear
        newTableView.refreshControl = refreshControl
        
        let refreshLoading = PublishRelay<Bool>()
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: {
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                    refreshLoading.accept(false)
                }
            }).disposed(by: disposeBag)
        
        refreshLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func readBooks() {
        // MoyaProvider를 통해 request를 실행합니다.
        service.request(APIService.new) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let books = try JSONDecoder().decode(BookModel.self, from: response.data)
                    self.bindTableView(data: books.books)
                } catch(let err) {
                    print("error : \(err)")
                    self.alertShow()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func bindTableView(data: [Book]) {
        Observable.of(data)
            .bind(to: newTableView.rx.items(cellIdentifier: "NewTableCell", cellType: NewTableCell.self)) { row, element, cell in
                cell.configureView(with: element)
                cell.newLinkButton.rx.tap
                    .subscribe(onNext: {
                        let safari = Safari()
                        self.present(safari.safari(data: element), animated: true, completion: nil)
                    }).disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
    }
    
    private func alertShow() {
        let alert = UIAlertController(title: "알림", message: "API 호출 실패하였습니다.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: false)
    }
    
    private func setupLayout() {
        view.addSubview(newTableView)
        newTableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func navigationSet() {
        navigationItem.title = "New Books"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bindData() {
        //tableView.rx.modelSelected : 선택된 Cell 위치의 Model 을 전달한다.
        newTableView.rx.modelSelected(Book.self)
            .subscribe(onNext: { [weak self] member in
                guard let self = self else { return }
                self.navigationController?.pushViewController(NewDetailViewController(member), animated: true)
            }).disposed(by: disposeBag)
    }
}


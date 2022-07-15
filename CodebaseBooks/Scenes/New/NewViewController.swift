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
        $0.rx.setDelegate(self)
            .disposed(by: disposeBag)
        $0.register(NewTableCell.self, forCellReuseIdentifier: "NewTableCell")
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
        cellClicked()
    }
    
    // MARK: - Functions
    @objc func refresh(refresh: UIRefreshControl) {
        print("refreshTable")
        DispatchQueue.main.async() {
            self.newTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func refreshSetting() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.backgroundColor = UIColor.clear
        self.newTableView.refreshControl = refreshControl
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.refresh(refresh: self.refreshControl)
    }

    private func readBooks() {
        // MoyaProvider를 통해 request를 실행합니다.
        service.request(APIService.new) { [weak self] result in
            guard let self = self else { return }
            // Result<Response, MoyaError>
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
                            let bookUrl = URL(string: "https://itbook.store/books/" + element.isbn13)
                            let bookSafariView: SFSafariViewController = SFSafariViewController(url: bookUrl as! URL)
                            self.present(bookSafariView, animated: true, completion: nil)
                            })
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
    
    private func cellClicked() {
        //tableView.rx.modelSelected : 선택된 Cell 위치의 Model 을 전달한다.
        newTableView.rx.modelSelected(Book.self)
            .subscribe(onNext: { [weak self] member in
                guard let self = self else { return }
                self.navigationController?.pushViewController(NewDetailViewController(member), animated: true)
            }).disposed(by: disposeBag)
    }
    
}

// MARK: - Extension (Delegate, DataSource)
extension NewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let newDetailVC = NewDetailViewController()
//        newDetailVC.prepareBook = self.bookList[indexPath.row]
//        navigationController?.pushViewController(newDetailVC, animated: true)
//    }
}



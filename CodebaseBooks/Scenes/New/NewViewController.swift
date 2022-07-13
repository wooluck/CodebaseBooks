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

class NewViewController: UIViewController {
    var bookList = [Book]()
    
    // make Moya provder
    let service = MoyaProvider<APIService>()
    
    private var refreshControl = UIRefreshControl()
    
    private lazy var newTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
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
       
        
        
    }
    
    // MARK: - Functions
    @objc func refresh(refresh: UIRefreshControl) {
        print("refreshTable")
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 02) {
            self.newTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func refreshSetting() {
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
            print("result: @@@ \(result)")
            switch result {
            case .success(let response):
                do {
                    print("success: \(response.description)")
                    let books = try JSONDecoder().decode(BookModel.self, from: response.data)
                    self.bookList = books.books
                    DispatchQueue.main.async {
                        self.newTableView.reloadData()
                    }
                } catch(let err) {
                    print("error : \(err)")
                    self.alertShow()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func alertShow() {
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
    
    func navigationSet() {
        navigationItem.title = "New Books"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Extension (Delegate, DataSource)
extension NewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newDetailVC = NewDetailViewController()
        newDetailVC.prepareBook = self.bookList[indexPath.row]
        navigationController?.pushViewController(newDetailVC, animated: true)
    }
}

extension NewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableCell", for: indexPath) as? NewTableCell else { return UITableViewCell()}
        cell.configureView(with: bookList[indexPath.row])
        return cell
    }
}


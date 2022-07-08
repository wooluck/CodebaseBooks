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
    }
    
    // MARK: - Functions
    private func readBooks() {
        // MoyaProvider를 통해 request를 실행합니다.
        service.request(APIService.new) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let books = try JSONDecoder().decode(BookModel.self, from: response.data)
                    self.bookList = books.books
                    DispatchQueue.main.async {
                        self.newTableView.reloadData()
                    }
                } catch(let err) {
                    print(err.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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


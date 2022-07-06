//
//  NewViewController.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/05.
//

import Foundation
import UIKit

class NewViewController: UIViewController {
    
    var bookList = [Book]()
    
    var newApi = "https://api.itbook.store/1.0/new"
    
    private lazy var newTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NewTableCell.self, forCellReuseIdentifier: "NewTableCell")
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationSet()
        ApiTake()
    }
    
    // MARK: - Functions
    func setupView() {
        
        view.addsubViews([newTableView])
        
        newTableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func navigationSet() {
        self.navigationItem.title = "New Books"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func ApiTake() {
        Task {
            do {
                let books = try await NetworkManager.shared.loadBook()
                
                self.bookList = books
                
                DispatchQueue.main.async {
                    self.newTableView.reloadData()
                }
            }catch {
                print("Response Error: \(error) @@ \(error.localizedDescription)")
            }
        }
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

        self.navigationController?.pushViewController(newDetailVC, animated: true)
    }
}

extension NewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableCell", for: indexPath) as? NewTableCell else { return UITableViewCell()}
        
        cell.selectionStyle = .none
        cell.setup()
        cell.configureView(with: bookList[indexPath.row])
        
        
        return cell
    }
    
}


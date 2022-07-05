//
//  NewViewController.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/05.
//

import Foundation
import UIKit

class NewViewController: UIViewController {
    
    private var newTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
//        tableView.delegate = self
//        tableView.dataSource = self
        
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        newTableView.delegate = self
//        newTableView.dataSource = self
    }
}




// MARK: - Extension (Delegate, DataSource)
//extension NewViewController: UITableViewDelegate {
//    
//}
//
//extension NewViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//}


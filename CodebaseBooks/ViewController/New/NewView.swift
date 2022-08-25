//
//  NewView.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/08/24.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift

class NewView: UIView {
    var disposeBag = DisposeBag()
    let dataRelay = BehaviorRelay<[Book]>(value: [])
    
    private var refreshControl = UIRefreshControl()
    
    private lazy var newTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(NewTableCell.self, forCellReuseIdentifier: "NewTableCell")
        $0.rowHeight = 280
        $0.flashScrollIndicators()
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bindTableView()
        refreshSetting()
//        navigationSet()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - FUNCTION
    func setupDI(relay: BehaviorRelay<[Book]>) {
        relay.bind(to: self.dataRelay)
            .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        addSubview(newTableView)
        newTableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
//        self.newTableView.scrollIndicatorInsets = .zero
    }
    
    private func bindTableView() {
        dataRelay.asDriver(onErrorJustReturn: [])
            .drive(newTableView.rx.items) { table, row, item in
                guard let cell = table.dequeueReusableCell(withIdentifier: "NewTableCell") as? NewTableCell else { return UITableViewCell() }
                cell.configureView(with: item)
                return cell
            }.disposed(by: disposeBag)
    }
    
    private func refreshSetting() {
        refreshControl.endRefreshing() // 초기화 - refresh 종료
        newTableView.refreshControl = refreshControl
        
        let refreshLoading = PublishRelay<Bool>()
        refreshControl.rx.controlEvent(.valueChanged)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                self.newTableView.dataSource = nil
//                self.readBooks()
                refreshLoading.accept(false)
            }).disposed(by: disposeBag)
        
        refreshLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
//    private func navigationSet() {
//        navigationItem.title = "New Books"
//        navigationController?.navigationBar.prefersLargeTitles = true
//    }
}

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
    let refreshLoading = PublishRelay<Bool>()
    
    let action = PublishRelay<NewActionType>()
    
    private var refreshControl = UIRefreshControl()
    
    lazy var newTableView = UITableView().then {
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
        bindData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - FUNCTION
    // ViewController에서 Book 데이터를 받아와
    func bookLoadDI(relay: BehaviorRelay<[Book]>) {
        relay.bind(to: self.dataRelay)
            .disposed(by: disposeBag)
    }

    /// User Input
    @discardableResult
    func setupDI(relay: PublishRelay<NewActionType>) -> Self {
        action.bind(to: relay).disposed(by: disposeBag)
        return self
    }
    
//    @discardableResult
//    func setupSafafiDI(relay: PublishRelay<NewActionType>) -> Self {
//        action.bind(to: relay).disposed(by: disposeBag)
//        return self
//    }
    
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
    
    func bindData() {
        newTableView.rx.modelSelected(Book.self)
            .subscribe(onNext: { [weak self] member in
                guard let self = self else { return }
                self.action.accept(.select(member))
            }).disposed(by: self.disposeBag)
    }
    
    private func refreshSetting() {
//        refreshControl.endRefreshing() // 초기화 - refresh 종료
        newTableView.refreshControl = refreshControl
        
        
        refreshControl.rx.controlEvent(.valueChanged)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                self.refreshLoading.accept(false)
            }).disposed(by: disposeBag)
        
        refreshLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
//    func bindSafariData() {
//        let newTableCell = NewTableCell()
//        newTableCell.newLinkButton.rx.tap
//            .subscribe(onNext: { [weak self]
//                guard let self = self else { return }
//                self.action.accept(.refresh(<#T##Book#>))
//            })
//    }
}

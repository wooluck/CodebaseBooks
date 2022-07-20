//
//  NewDetailViewController.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/06.
//

import UIKit
import Alamofire
import Moya
import Then
import RxSwift
import RxCocoa
import SafariServices

class NewDetailViewController: UIViewController {
    var disposeBag = DisposeBag()
    let service = MoyaProvider<APIService>()
    private let DATA_KEY = "Saved Data"
    private var textData: String?
    let defaults = UserDefaults.standard
    
    init(_ detailData: Book) {
        super.init(nibName: nil, bundle: nil)
        readBooks(data: detailData)
        linkButtonClicked(data: detailData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var detailView = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    private lazy var detailImageView = UIImageView()
    
    private lazy var detailTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private lazy var detailSubTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private lazy var detailIsbn13Label = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
    }
    
    private lazy var detailPriceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
    }
    
    private lazy var detailLinkButton = UIButton().then {
        $0.setTitleColor(.blue, for: .normal)
        $0.backgroundColor = .white
    }
    
    private lazy var detailSeperateView = UIView().then {
        $0.backgroundColor = .systemGray3
    }
    
    private lazy var detailTextView = UITextView().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.text = "내용을 입력하세요."
        
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.systemGray2.cgColor
        $0.layer.borderWidth = 1
        //        $0.delegate = self
    }
    
    // MARK: - viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailTextView.text = defaults.string(forKey: "textData")
    }
    
    // MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setLayoutContentView()
        
        // MARK: (Test)
        detailTextView.rx.didChange
            .subscribe(onNext : {
                self.textData = self.detailTextView.text ?? "no Data in textData"
                self.defaults.set(self.textData, forKey: "textData")
            }).disposed(by: disposeBag)
        
    }
    
    // MARK: - Functions
    private func setLayoutContentView() {
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        navigationItem.title = "Detail Book"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func readBooks(data: Book) {
        guard let imageURL = URL(string: data.image) else { return }
                    self.detailImageView.load(url: imageURL)
                    self.detailTitleLabel.text = data.title
                    self.detailSubTitleLabel.text = data.subtitle
                    self.detailIsbn13Label.text = data.isbn13
                    self.detailPriceLabel.text = data.price
                    self.detailLinkButton.setTitle(data.url, for: .normal)
    }
    private func linkButtonClicked(data: Book) {
        detailLinkButton.rx.tap
            .subscribe(onNext: {
                self.present(SafariView.init(path: data.isbn13), animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }
    
    
    private func setupLayout() {
        view.addsubViews([detailView, detailTitleLabel, detailSubTitleLabel, detailIsbn13Label, detailPriceLabel, detailLinkButton, detailSeperateView, detailTextView])
        detailView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        detailView.addSubview(detailImageView)
        detailImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(detailView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(105)
        }
        
        detailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(detailView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        detailSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(detailTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        detailIsbn13Label.snp.makeConstraints {
            $0.top.equalTo(detailSubTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        detailPriceLabel.snp.makeConstraints {
            $0.top.equalTo(detailIsbn13Label.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        detailLinkButton.snp.makeConstraints {
            $0.top.equalTo(detailPriceLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        detailSeperateView.snp.makeConstraints {
            $0.top.equalTo(detailLinkButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        detailTextView.snp.makeConstraints {
            $0.top.equalTo(detailSeperateView.snp.bottom).offset(15)
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
}


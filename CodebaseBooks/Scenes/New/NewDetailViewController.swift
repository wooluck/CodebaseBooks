//
//  NewDetailViewController.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/06.
//

import Foundation
import UIKit
import Alamofire

class NewDetailViewController: UIViewController {
    
    var prepareBook: Book? {
        didSet {
            print(prepareBook)
        }
    }
    
    var detailBook: BookDetail?
    
    
    private lazy var detailView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        
        return view
    }()
    
    private lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var detailTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    private lazy var detailSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    private lazy var detailIsbn13Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        
        return label
    }()
    
    private lazy var detailPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        
        return label
    }()
    
    private lazy var detailLinkButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        
        return button
    }()
    
    private lazy var detailSeperateView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        
        return view
    }()
    
    private lazy var detailTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20, weight: .medium)
        textView.text = "내용을 입력하세요."
        textView.textColor = .placeholderText
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.systemGray2.cgColor
        textView.layer.borderWidth = 1
        
        textView.delegate = self
        
        return textView
    }()
    
    // MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        fetchSearchBooks(isbn13: self.prepareBook?.isbn13 ?? "nil")
        setupLayout()
        navigationSet()

        self.view.backgroundColor = .white
    }
    
    // MARK: - Functions
    func setupLayout() {
        
        view.addsubViews([detailView, detailTitleLabel, detailSubTitleLabel, detailIsbn13Label, detailPriceLabel, detailLinkButton, detailSeperateView, detailTextView])

        detailView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        detailView.addsubViews([detailImageView])
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
    
    func navigationSet() {
        self.navigationItem.title = "Detail Book"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func fetchSearchBooks(isbn13: String) {
        AF.request("https://api.itbook.store/1.0/books/" + isbn13)
            .validate()
            .responseDecodable(of: BookDetail.self) { data in
            guard let books = data.value else {
                print("responseDecodable ERROR")
                return
            }
                self.detailBook = books
                let imageURL = URL(string: self.detailBook?.image ?? "nil")
                self.detailImageView.load(url: imageURL!)
                self.detailTitleLabel.text = self.detailBook?.title
                self.detailSubTitleLabel.text = self.detailBook?.subtitle
                self.detailIsbn13Label.text = self.detailBook?.isbn13
                self.detailPriceLabel.text = self.detailBook?.price
                self.detailLinkButton.setTitle(self.detailBook?.url, for: .normal)
                
                
            }
    }
    
}

// MARK: - Extension (Delegate, DataSource)
extension NewDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .placeholderText else { return }
        textView.textColor = .label
        textView.text = nil
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요."
            textView.textColor = .placeholderText
        }
    }
}

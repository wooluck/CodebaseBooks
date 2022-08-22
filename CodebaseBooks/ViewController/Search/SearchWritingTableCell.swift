//
//  SearchEmptyTableCell.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/08/22.
//

import UIKit
import Kingfisher
import Then
import RxSwift
import RxCocoa

class SearchWritingTableCell: UITableViewCell{
    
    var preparebook: Book?
    
    private var searchImageView = UIImageView()
    
    private lazy var searchView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var searchTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private lazy var searchSubTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    private lazy var searchIsbn13Label = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
    }
    
    private lazy var searchPriceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    lazy var searchLinkButton = UIButton().then {
        $0.setTitleColor(.blue, for: .normal)
        $0.backgroundColor = .white
    }
    
    // MARK: - layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    // MARK: - Functions
    private func setupLayout() {
        contentView.addsubViews([searchImageView, searchView])
        searchImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(120)
            $0.width.equalTo(100)
        }
        searchView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalTo(searchImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
        }
        
        searchView.addsubViews([searchTitleLabel, searchSubTitleLabel, searchIsbn13Label, searchPriceLabel, searchLinkButton])
        searchTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            
        }
        searchSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(searchTitleLabel.snp.bottom).offset(-2)
            $0.bottom.equalTo(searchIsbn13Label.snp.top).offset(-5)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            
        }
        searchIsbn13Label.snp.makeConstraints {
            $0.bottom.equalTo(searchPriceLabel.snp.top).offset(-5)
            $0.leading.equalToSuperview()
        }
        searchPriceLabel.snp.makeConstraints {
            $0.bottom.equalTo(searchLinkButton.snp.top)
            $0.leading.equalToSuperview()
        }
        searchLinkButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
            
        }
    }
    
    func configureView(with bookModel: Book) {
        // 이미지 불러오기
        if let url = URL(string: bookModel.image) {
            searchImageView.load(url: url)
            let imageData = try! Data(contentsOf: url)
            searchImageView.image = UIImage(data: imageData)
        } else {
            print("Image URL Not Failed")
        }
        searchTitleLabel.text = bookModel.title
        searchSubTitleLabel.text = bookModel.subtitle
        searchIsbn13Label.text = bookModel.isbn13
        searchPriceLabel.text = bookModel.price.USDToKRW()
        searchLinkButton.setTitle(bookModel.url, for: .normal)
        selectionStyle = .none
    }
}

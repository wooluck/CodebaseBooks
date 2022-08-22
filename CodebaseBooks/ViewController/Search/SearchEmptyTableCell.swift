//
//  SearchTableCell.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/06.
//

import UIKit
import Kingfisher
import Then
import RxSwift
import RxCocoa

class SearchEmptyTableCell: UITableViewCell {
    
    var preparebook: Book?
    
    private var searchImageView = UIImageView()
    
    public lazy var searchLinkButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        $0.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        $0.setImage(UIImage(systemName: "link.circle"), for: .normal)
    }
    
    private lazy var searchView = UIView().then {
        $0.backgroundColor = .systemGray4
    }
    
    private lazy var searchTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
    }
    
    private lazy var searchSubTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.textAlignment = .center
    }
    
    private lazy var searchIsbn13Label = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textAlignment = .center
    }
    
    private lazy var searchPriceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
    }
    // MARK: - layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayoutContentView()
        setupLayout()
    }
    
    // MARK: - Functions
    private func setupLayout() {
        
        contentView.addsubViews([searchImageView, searchLinkButton, searchView])
        searchImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(105)
            $0.height.equalTo(150)
        }
        searchLinkButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(15)
            $0.leading.equalTo(searchImageView.snp.trailing).offset(60)
        }
        searchView.snp.makeConstraints{
            $0.top.equalTo(searchImageView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchView.addsubViews([searchTitleLabel, searchSubTitleLabel, searchIsbn13Label, searchPriceLabel])
        searchTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(10)
        }
        searchSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(searchTitleLabel.snp.bottom).offset(-5)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(searchIsbn13Label.snp.top).offset(-5)
        }
        searchIsbn13Label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            if searchSubTitleLabel.text == "" {
                $0.bottom.equalTo(searchPriceLabel.snp.top).offset(-10)
            } else {
                $0.bottom.equalTo(searchPriceLabel.snp.top).offset(-5)
            }
        }
        searchPriceLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            if searchSubTitleLabel.text == "" {
                $0.bottom.equalToSuperview().inset(16)
            } else {
                $0.bottom.equalToSuperview().inset(7)
            }
        }
    }
    
    /// 테이블 뷰 셀 사이의 간격, 그림자, 셀 둥글게
    private func setupLayoutContentView() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemGray5
    }
    
    /// 가져온 데이터 mapping
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
        selectionStyle = .none
    }
}





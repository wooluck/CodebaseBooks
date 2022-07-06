//
//  SearchTableCell.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/06.
//

import Foundation
import UIKit
import Kingfisher

class SearchTableCell: UITableViewCell {
    
    var preparebook: Book?

    private var searchImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()
    
    private lazy var searchLinkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "link.circle"), for: .normal)
        
        return button
    }()
    
    private lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        
        return view
    }()
    
    private lazy var searchTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "제목 없음"
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var searchSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "내용 없음"
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var searchIsbn13Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.text = "123123123"
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var searchPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "$100"
        label.textAlignment = .center
        
        return label
    }()
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .systemGray5
        viewSizeAndLayer()
    }
    
    // MARK: - Functions
    func setup() {
        setupLayout()
    }
    
    func setupLayout() {
        contentView.addsubViews([searchImageView , searchLinkButton ,searchView])
        
        searchImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
//            $0.bottom.equalTo(searchView.snp.top)
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
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(searchIsbn13Label.snp.top).offset(-5)
        }
        searchIsbn13Label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(searchPriceLabel.snp.top).offset(-5)
        }
        searchPriceLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(7)
        }
    }
    
    /// 테이블 뷰 셀 사이의 간격, 그림자, 셀 둥글게
    func viewSizeAndLayer() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true
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
        searchPriceLabel.text = bookModel.price
        
        selectionStyle = .none
    }
    
    
    
}





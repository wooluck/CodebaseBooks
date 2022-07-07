//
//  NewTableCell.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/05.
//

import Foundation
import UIKit
import SnapKit

class NewTableCell: UITableViewCell {
    
    private var newImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var newLinkButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.setImage(UIImage(systemName: "link.circle"), for: .normal)
        
        return button
    }()
    
    private lazy var newView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        
        return view
    }()
    
    private lazy var newTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var newSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var newIsbn13Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var newPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        backgroundColor = .systemGray5
        viewSizeAndLayer()
        
    }
    
    
    
    // MARK: - Functions
    func setup() {
        setupLayout()
    }
    
    func setupLayout() {
//        contentView.addsubViews([newImageView , newLinkButton ,newView])
        contentView.addSubViewMap([newImageView, newLinkButton, newView])
        
        newImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(105)
            $0.height.equalTo(150)
        }
        newLinkButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(15)
            $0.leading.equalTo(newImageView.snp.trailing).offset(60)
        }
        
        newView.snp.makeConstraints{
            $0.top.equalTo(newImageView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
//            $0.bottom.equalToSuperview().offset(-20)
        }
        
        newView.addsubViews([newTitleLabel, newSubTitleLabel, newIsbn13Label, newPriceLabel])
        
        newTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
        }
        newSubTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(newIsbn13Label.snp.top).offset(-5)
        }
        newIsbn13Label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(newPriceLabel.snp.top).offset(-5)
        }
        newPriceLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(7)
        }
    }
    
    /// 테이블 뷰 셀 사이의 간격, 그림자, 셀 둥글게
    func viewSizeAndLayer() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))

        // cell 자체내에 넣으면 안되고 contentView에 넣어야됨
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true
        
        
//        self.layer.cornerRadius = 30
//        self.layer.masksToBounds = true
//        self.backgroundColor = .yellow
        
        contentView.backgroundColor = .systemGray5

    }
    
    /// 데이터 가져오기
    func configureView(with bookModel: Book) {

            // 이미지 불러오기
        if let url = URL(string: bookModel.image) {
            newImageView.load(url: url)
            let imageData = try! Data(contentsOf: url)
            newImageView.image = UIImage(data: imageData)
        } else {
            print("Image URL Not Failed")
        }
       
        newTitleLabel.text = bookModel.title
        newSubTitleLabel.text = bookModel.subtitle
        newIsbn13Label.text = bookModel.isbn13
        newPriceLabel.text = bookModel.price.USDToKRW()
        
        selectionStyle = .none
    }
    
    
    
}





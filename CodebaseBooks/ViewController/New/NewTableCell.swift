//
//  NewTableCell.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/05.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import SafariServices
//import NSOBject_RX

class NewTableCell: UITableViewCell {
    public lazy var newImageView = UIImageView()
    
    public lazy var newLinkButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        $0.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        $0.setImage(UIImage(systemName: "link.circle"), for: .normal)
    }
    
    public lazy var newView = UIView().then {
        $0.backgroundColor = .systemGray4
    }
    
    public lazy var newTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
    }
    
    public lazy var newSubTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.textAlignment = .center
    }
    
    public lazy var newIsbn13Label = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textAlignment = .center
    }
    
    public lazy var newPriceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayoutContentView()
        setupLayout()
    }
    
    // MARK: - Functions

    private func setupLayout() {
        contentView.addsubViews([newImageView, newLinkButton, newView])
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
    private func setupLayoutContentView() {
        selectionStyle = .none
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        
        // cell 자체내에 넣으면 안되고 contentView에 넣어야됨
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemGray5
    }
    
    /// 데이터 가져오기
    public func configureView(with bookModel: Book) {
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
    }
}





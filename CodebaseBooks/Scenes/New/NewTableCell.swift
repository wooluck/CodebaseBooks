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
    
    private var newView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private var newImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "can")
        imageView.image = image
        
        return imageView
    }()
    
    private var newTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.text = "제목 없음"
        
        return label
    }()
    
    private var newSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.text = "내용 없음"
        
        return label
    }()
    
    private var newIsbn13Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0)
        label.text = "123123123"
        
        return label
    }()
    
    private var newPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.text = "$100"
        
        return label
    }()
    
    
    
    // MARK: - Functions
    func setup() {
        setupLayout()
    }
    
    func setupLayout() {
        addsubViews([newView])
        newView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        newView.addsubViews([newImageView, newTitleLabel, newSubTitleLabel, newIsbn13Label, newPriceLabel])
        newImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(5)
        }
        newTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(newImageView.snp.bottom).offset(5)
        }
        newSubTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(newIsbn13Label.snp.top).offset(5)
        }
        newIsbn13Label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(newPriceLabel.snp.top).offset(5)
        }
        newPriceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
        }
        
        
    }
    
    
    
}





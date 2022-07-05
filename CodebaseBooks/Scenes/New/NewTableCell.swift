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
        
        return label
    }()
    
    private var newSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        
        return label
    }()
    
    private var newIsbn13Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0)
        
        return label
    }()
    
    private var newPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        
        return label
    }()
    
    
    
    // MARK: - Functions
    func setup() {
        
    }
    
    func setupLayout() {
        addSubview(newView)
        newView.snp.makeConstraints {
            $0.height.equalTo(130)
        }
        
        //addsubViews([newPriceLabel, newIsbn13Label])
        [
            newPriceLabel,newIsbn13Label
        ].forEach(<#T##body: (UILabel) throws -> Void##(UILabel) throws -> Void#>)
//        addSubview(<#T##view: UIView##UIView#>)
        
//        addsubViews([newPriceLabel, newIsbn13Label])
    }
    
    
    
}

extension UIView {
//    func addsubViews(_ view: [UIView]) {
//        view.forEach { addSubview($0) }
//    }
    
    
}




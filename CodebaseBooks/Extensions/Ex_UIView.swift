//
//  Ex_UIView.swift
//  CodebaseBooks
//
//  Created by luck woo on 2022/07/05.
//

import Foundation
import UIKit

extension UIView {
    func addsubViews(_ view: [UIView]) {
        view.forEach { addSubview($0) }
    }
    
//    func addsubViews(_ mappingView: [UIView]) {
//        mappingView.map { addSubview($0) }
//    }
}

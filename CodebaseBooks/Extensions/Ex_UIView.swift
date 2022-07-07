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
}

extension UIView {
    func addSubViewMap(_ view: [UIView]) {
        view.map { return addSubview($0) }
    }
}

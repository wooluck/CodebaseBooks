//
//  Ex_ConstraintMakerRelatable.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/07.
//

import Foundation
import SnapKit
import UIKit

extension ConstraintMakerRelatable {

    public func equalToSafeArea(_ view: UIView, _ file: String = #file, _ line: UInt = #line) -> ConstraintMakerEditable {
        if #available(IOS 11.0 ,*) {
            return self.equalTo(view.safeAreaLayoutGuide, file, line)
        }
        return self.equalToSuperview()
    }
}







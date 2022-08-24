//
//  ViewModelType.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/08/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

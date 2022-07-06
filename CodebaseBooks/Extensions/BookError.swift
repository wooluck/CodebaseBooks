//
//  BookError.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/06.
//

import Foundation

enum BookError: Error {
    case invalidUrl
    case invalidRequest
    case invalidData
    case invalidBookData
    case invalidResponse
    case invalidResponseNum
    case newVCResultFailure
}

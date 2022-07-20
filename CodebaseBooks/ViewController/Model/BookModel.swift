//
//  BookModel.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/06.
//

import Foundation

struct BookModel: Codable {
    let error: String
    let total: String
    let page: String?
    var books: [Book]
}
struct Book: Codable {
    var title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}


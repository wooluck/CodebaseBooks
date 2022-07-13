//
//  APIService.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/08.
//

import Foundation
import Moya

// APIServcie가 제공하는 기능 열거
enum APIService {
    case new
    case datail(isbn13: String)
    case search(query: String)
    case fail
}

// TargetType 정의 ( 기본적인 네트워킹 레이러를 구축)
extension APIService: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.itbook.store/1.0/") else {
            fatalError()
        }
        return url
    }
    
    var path: String {
        switch self {
        case .new:                          return "new"
        case .datail(let isbn13):           return "books/\(isbn13)"
        case .search(let query):            return "search/\(query)"
        case .fail:                          return "fail"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        default:       return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

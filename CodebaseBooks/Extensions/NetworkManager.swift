//
//  NetworkManager.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/06.
//

import Foundation

enum HttpMethod: String {
    case get
    case delete
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    var book : Book?
    
    // New
    func loadBook() async throws -> [Book] {
        let books: [Book] = try await withCheckedThrowingContinuation({ continuation in
            
            getBookList(apiURL: "https://api.itbook.store/1.0/new", httpMethod: .get) { result in
                switch result  {
                case .success(let data):
                    continuation.resume(returning: data)
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
        return books
    }
    
    // Detail
    func loadDetailBook(isbn13: String) async throws -> BookDetail {
        let books: BookDetail = try await withCheckedThrowingContinuation({ continuation in
            getDetailBookList(apiURL: "https://api.itbook.store/1.0/books/" + isbn13, httpMethod: .get) { result in
                
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
        return books
    }
    
    // Search
    func loadSearchBook(query: String) async throws -> [Book] {
        let books: [Book] = try await withCheckedThrowingContinuation({ continuation in
            getSearchBookList(apiURL: "https://api.itbook.store/1.0/search/" + query, httpMethod: .get) { result in
                
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
        return books
    }
    
    
    // MARK: NewAPI
    func getBookList(apiURL: String, httpMethod: HttpMethod, completion: @escaping (Result<[Book], BookError>) -> Void) {
        guard let url = URL(string: apiURL) else {
            print("url Error : \(apiURL)")
            completion(.failure(.invalidUrl))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            guard let bookData = try? JSONDecoder().decode(BookModel.self, from: data) else {
                completion(.failure(.invalidBookData))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            switch response.statusCode {
            case (200...299):
                completion(.success(bookData.books))
            default:
                completion(.failure(.invalidResponseNum))
            }
        }
        dataTask.resume()
    }
    
    // MARK: DetailAPI
    
    func getDetailBookList(apiURL: String, httpMethod: HttpMethod, completion: @escaping (Result<BookDetail, BookError>) -> Void) {
        guard let url = URL(string: apiURL) else {
            print("url Error: \(apiURL)")
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            guard let bookData = try? JSONDecoder().decode(BookDetail.self, from: data) else {
                completion(.failure(.invalidBookData))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            switch response.statusCode {
            case (200...299):
                completion(.success(bookData))
            default:
                completion(.failure(.invalidResponseNum))
            }
        }
        dataTask.resume()
    }
    
    
    // MARK: SearchAPI
    
    func getSearchBookList(apiURL: String, httpMethod: HttpMethod, completion: @escaping (Result<[Book], BookError>) -> Void) {
        guard let url = URL(string: apiURL) else {
            print("url Error: \(apiURL)")
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            guard let bookData = try? JSONDecoder().decode(BookModel.self, from: data) else {
                completion(.failure(.invalidBookData))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            switch response.statusCode {
            case (200...299):
                completion(.success(bookData.books))
            default:
                completion(.failure(.invalidResponseNum))
            }
        }
        dataTask.resume()
    }
}
    
    
    
    
    
    
    
    

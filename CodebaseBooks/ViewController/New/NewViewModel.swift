//
//  NewViewModel.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/08/16.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

enum NewActionType {
    case tt
    case select(Book)
}

class NewViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    // make Moya provder
    private let service = MoyaProvider<APIService>()
    private let newBookRelay = BehaviorRelay<[Book]>(value: [])
    
    private let detailBook = PublishRelay<Book>()
    
    struct Input {
        var inputTrigger: PublishRelay<NewActionType>
    }
    struct Output {
        var newBookRelay: BehaviorRelay<[Book]>
        let navigateToDetail: Observable<Book>
    }
    
    func transform(input: Input) -> Output {
//        input.inputTrigger
//            .bind(onNext: { [weak self]_ in
//                self?.readBooks()
//            }).disposed(by: disposeBag)
        
        input.inputTrigger.bind(onNext: actionForButton(_:)).disposed(by: disposeBag)
        
        return Output(newBookRelay: newBookRelay,
                      navigateToDetail: detailBook.asObservable())
    }
    
    private func actionForButton(_ type: NewActionType) {
        switch type {
        case .select(let book):
            detailBook.accept(book)
        case .tt:
            readBooks()
            print("data Load")
        }
    }
    
    private func readBooks() {
        // MoyaProvider를 통해 request를 실행합니다.
        service.request(APIService.new) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let books = try JSONDecoder().decode(BookModel.self, from: response.data)
                    var newsBookData = books.books
                    
                    for books in newsBookData {
                        let title = books.title
                        let subtitle = books.subtitle
                        let isbn13 = books.isbn13
                        let price = books.price
                        let image = books.image
                        let url = books.url
                        
                        newsBookData.append(Book(title: title, subtitle: subtitle, isbn13: isbn13, price: price, image: image, url: url))
                    }
                    self.newBookRelay.accept(newsBookData)

                } catch(let err) {
                    print("error : \(err)")
//                    self.alertShow()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}













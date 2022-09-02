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
    case normal
    case select(Book)
//    case refresh(Book)
}

class NewViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    // make Moya provider
    private let service = MoyaProvider<APIService>()
    
    private let newBookRelay = BehaviorRelay<[Book]>(value: [])
    private let detailBook = PublishRelay<Book>()
    private let enterSafafi = PublishRelay<Book>()
    
    struct Input {
        var inputTrigger: PublishRelay<NewActionType>
    }
    struct Output {
        var newBookRelay: BehaviorRelay<[Book]>
        let navigateToDetail: Observable<Book>
//        var linkButtonClicked: Observable<Book>
    }
    
    func transform(input: Input) -> Output {
        input.inputTrigger.bind(onNext: actionForButton(_:)).disposed(by: disposeBag)
        
        return Output(newBookRelay: newBookRelay,
                      navigateToDetail: detailBook.asObservable())
    }
    
    private func actionForButton(_ type: NewActionType) {
        switch type {
        case .select(let book):
            detailBook.accept(book)
        case .normal:
            readBooks()
//        case .refresh:
//            print("reFresh")
        }
    }
    
    private func readBooks() {
        // MoyaProvider를 통해 request를 실행합니다.
        service.request(APIService.new) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                do {
                    let books = try JSONDecoder().decode(BookModel.self, from: response.data)
                    var newsBookData: [Book] = []
                    newsBookData.append(contentsOf: books.books)
                    
                    self.newBookRelay.accept(newsBookData)
                    
                } catch  {
                    print(NewMessage.Error.APIFailerMessage)
                    //                    self.alertShow()
                }
            case .failure:
                print(NewMessage.Error.APIFailerMessage)
            }
        }
    }
}













//
//  SearchViewModel.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/08/16.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

/*
 1. 사용자가 입력한 텍스트의 값을 VM로 전송
 2. VM에서 텍스트의 값(트리거)을 통해서 API Request
 3. Response값을 OUPTUT으로 전송 -> VC으로 전송
 4. VC에서 OUPTUT의 값이 빈값이면. 라벨 숨김처리해제, 값이 있으면 라벨 숨김처리 및 Cell 바인딩
 
 */

enum SearchActionType {
    case first
    case searchBarClick(String)
}

class SearchViewModel: ViewModelType {
    private var disposeBag = DisposeBag()
    // make Moya provider
    private let service = MoyaProvider<APIService>()
    
    struct Input {
        var inputTrigger: PublishRelay<SearchActionType>
    }
    
    struct Output {
        var searchBookList: BehaviorRelay<[Book]>
        var searchFilterBookList: BehaviorRelay<[Book]>
    }
    
    private var searchBookList = BehaviorRelay<[Book]>(value: [])
    private let searchFilterBookList = BehaviorRelay<[Book]>(value: [])
    
    func transform(input: Input) -> Output {
        
        input.inputTrigger
            .bind(onNext: inputActionTrigger(_:))
            .disposed(by: disposeBag)
        
        return Output(searchBookList: searchBookList,
                      searchFilterBookList: searchFilterBookList
        )
    }
    
    private func inputActionTrigger(_ type: SearchActionType) {
        switch type {
        case .first:
            firstScene()
        case .searchBarClick(let text):
            writeInSeachBar(text)
        }
    }
    
    private func firstScene() {
        self.service.request(APIService.new) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let books = try JSONDecoder().decode(BookModel.self, from: response.data)
                    
                    self.searchBookList
                        .accept(books.books)
                    
                } catch {
                    print(NewMessage.Error.APIFailerMessage)
                }
            case .failure:
                print(NewMessage.Error.APIFailerMessage)
            }
        }
    }
    
    private func writeInSeachBar(_ text: String) {
        if text == "" {
            self.service.request(APIService.new) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    do {
                        let books = try JSONDecoder().decode(BookModel.self, from: response.data)
                        self.searchFilterBookList.accept(books.books)
                        
                    } catch {
                        print(NewMessage.Error.APIFailerMessage)
                    }
                case .failure:
                    print(NewMessage.Error.APIFailerMessage)
                }
            }
        } else {
            self.service.request(APIService.search(query: text)) { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let response):
                    do {
                        let books = try JSONDecoder().decode(BookModel.self, from: response.data)
                        self.searchFilterBookList.accept(books.books)
                    } catch {
                        print(NewMessage.Error.APIFailerMessage)
                    }
                case .failure:
                    print(NewMessage.Error.APIFailerMessage)
                }
            }
            
        }
    }
}




//
//  SearchViewModel.swift
//  BookApp
//
//  Created by MJ Dev on 5/12/25.
//

import Foundation
import RxSwift
import RxRelay

final class SearchViewModel {
    
    private let networkManager: NetworkManager
    private let disposeBag = DisposeBag()
    private(set) var fetchedBooks = PublishSubject<[Book]>()
    var item: [Book] = []
    init(networkManager: NetworkManager = .init()) {
        self.networkManager = networkManager
    }
    
    func fetchBooks(query: String) {
        Task {
            await networkManager.fetch(query: query)
                .subscribe(onSuccess: {[weak self] (data: BookResponse) in
                    self?.fetchedBooks.onNext(data.documents)
                    self?.item = data.documents
                }, onFailure: { error in
                    print(error.localizedDescription)
                }).disposed(by: disposeBag)
        }
    }
    
}

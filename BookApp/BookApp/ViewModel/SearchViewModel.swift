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
    private(set) var fetchedBooks = BehaviorSubject<[Book]>(value: [])
    private(set) var recentBooks = BehaviorSubject<[Book]>(value: [])
    
    var fetchedBooksArray: [Book] {
        guard let books = try? fetchedBooks.value() else { return [] }
        return books
    }
    
    var recentBooksArray: [Book] {
        guard let books = try? recentBooks.value() else { return [] }
        return books
    }
    
    init(networkManager: NetworkManager = .init()) {
        self.networkManager = networkManager
    }
    
    func fetchBooks(query: String) {
        Task {
            await networkManager.fetch(query: query)
                .subscribe(onSuccess: {[weak self] (data: BookResponse) in
                    self?.fetchedBooks.onNext(data.documents)
                }, onFailure: { error in
                    print(error.localizedDescription)
                }).disposed(by: disposeBag)
        }
    }
    
    func appendRecentBook(_ book: Book) {
        var recentBook = book
        recentBook.isRecent = true
        if recentBooksArray.contains(recentBook) { return }
        recentBooks.onNext(recentBooksArray + [recentBook])
    }
    
}

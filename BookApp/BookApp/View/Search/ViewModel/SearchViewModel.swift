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
    
    // 데이터 불러오기
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
    // 최근기록 추가
    func appendRecentBook(_ book: inout Book) {
        // DiffableDataSource에서 셀은 고유해야하므로 isRecent 값 변경하여 저장, 다른곳에선 안쓰인다.
        book.isRecent = true
        
        // 이미 최근 기록에 있는지 판단
        if recentBooksArray.contains(book) {
            // 가장 첫번째에 존재하면 재배치 과정 스킵
            if recentBooksArray[0] == book { return }
            // 이미 최근기록에 있지만 첫번째에 배치되어 있지 않다면 첫번째로 재배치
            var currentRecentBooks = self.recentBooksArray
            for i in 0..<currentRecentBooks.count {
                if book == currentRecentBooks[i] {
                    currentRecentBooks.remove(at: i)
                    break
                }
            }
            recentBooks.onNext([book] + currentRecentBooks)
            return
        }
        // 최근기록에 없다면 추가
        recentBooks.onNext([book] + recentBooksArray)
    }
    
}

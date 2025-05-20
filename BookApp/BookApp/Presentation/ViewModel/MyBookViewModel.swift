//
//  MyBookViewModel.swift
//  BookApp
//
//  Created by MJ Dev on 5/12/25.
//

import Foundation
import RxSwift

final class MyBookViewModel {
    
    private let coreDataManager = CoreDataManager()
    var myBooks = BehaviorSubject<[Book]>(value: [])
    
    private let coreDataReadUseCase: CoreDataReadUseCase
    private let coreDataDeleteUseCase: CoreDataDeleteUseCase
    private let coreDataDeleteAllUseCase: CoreDataDeleteAllUseCase
    
    init(
        coreDataReadUseCase: CoreDataReadUseCase,
        coreDataDeleteUseCase: CoreDataDeleteUseCase,
        coreDataDeleteAllUseCase: CoreDataDeleteAllUseCase
    ) {
        self.coreDataReadUseCase = coreDataReadUseCase
        self.coreDataDeleteUseCase = coreDataDeleteUseCase
        self.coreDataDeleteAllUseCase = coreDataDeleteAllUseCase
        fetchMyBooks()
    }
    
    // 코어데이터에 저장된 담긴 책 데이터 불러오기
    func fetchMyBooks() {
        let myBooks = coreDataReadUseCase.execute(for: .myBook)
        self.myBooks.onNext(myBooks)
    }
    
    // 코어데이터에 저장된 담긴 책 데이터 모두 삭제
    func deleteAllBooks() {
        coreDataDeleteAllUseCase.execute(for: .myBook)
        fetchMyBooks()
    }
    // 코어데이터에 저장된 데이터에서 파라미터로 입력받은 데이터 삭제
    func deleteBook(book: Book) {
        coreDataDeleteUseCase.execute(for: .myBook, to: book)
        fetchMyBooks()
    }
}

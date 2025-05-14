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
    
    init() {
        fetchMyBooks()
    }
    
    // 코어데이터에 저장된 담긴 책 데이터 불러오기
    func fetchMyBooks() {
        self.myBooks.onNext(coreDataManager.read())
    }
    
    // 코어데이터에 저장된 담긴 책 데이터 모두 삭제
    func deleteAllBooks() {
        coreDataManager.deleteAll()
        fetchMyBooks()
    }
    // 코어데이터에 저장된 데이터에서 파라미터로 입력받은 데이터 삭제
    func deleteBook(book: Book) {
        coreDataManager.delete(book: book)
        fetchMyBooks()
    }
}

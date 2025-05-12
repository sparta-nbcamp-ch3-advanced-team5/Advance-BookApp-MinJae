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
    
    func fetchMyBooks() {
        self.myBooks.onNext(coreDataManager.read())
    }
    
    func deleteAllBooks() {
        coreDataManager.deleteAll()
        fetchMyBooks()
    }
    
    func deleteBook(book: Book) {
        coreDataManager.delete(book: book)
        fetchMyBooks()
    }
}

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
    var myBooks = PublishSubject<[Book]>()
    
    init() {
        fetchMyBooks()
    }
    
    func fetchMyBooks() {
        self.myBooks.onNext(coreDataManager.read())
    }
}

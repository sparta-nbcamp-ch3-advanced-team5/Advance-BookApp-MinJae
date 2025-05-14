//
//  BookDetailViewModel.swift
//  BookApp
//
//  Created by MJ Dev on 5/12/25.
//

import Foundation

final class BookDetailViewModel {
    var item: Book
    private let coreDataManager = CoreDataManager()
    
    init(item: Book) {
        self.item = item
    }
    
    func saveBook() {
        coreDataManager.create(to: item)
    }
}

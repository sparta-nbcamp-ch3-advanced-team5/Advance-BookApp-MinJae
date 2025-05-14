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
        if duplicationValidation() { return }
        coreDataManager.create(to: item)
    }
    
    private func duplicationValidation() -> Bool {
        let currentSavedData = coreDataManager.read()
        let newBook = Book(title: item.title,
                           authors: item.authors,
                           price: item.price,
                           description: nil,
                           imageURL: nil,
                           isRecent: false)
        return currentSavedData.contains(newBook)
    }
}

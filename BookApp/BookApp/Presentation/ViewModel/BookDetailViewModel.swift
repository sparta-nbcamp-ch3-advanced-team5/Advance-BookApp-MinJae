//
//  BookDetailViewModel.swift
//  BookApp
//
//  Created by MJ Dev on 5/12/25.
//

import Foundation

final class BookDetailViewModel {
    
    var item: Book
    private let coreDataReadUseCase: CoreDataReadUseCase
    private let coreDataCreateUseCase: CoreDataCreateUseCase
    
    init(item: Book,
         coreDataReadUseCase: CoreDataReadUseCase,
         coreDataCreateUseCase: CoreDataCreateUseCase
    ) {
        self.item = item
        self.coreDataReadUseCase = coreDataReadUseCase
        self.coreDataCreateUseCase = coreDataCreateUseCase
    }
    
    // 책 코어데이터에 저장
    func saveBook() {
        if duplicationValidation() { return }
        coreDataCreateUseCase.execute(for: .myBook, to: item)
    }
    // 담긴 책에 이미 저장되어 있는지 판단
    private func duplicationValidation() -> Bool {
        let currentSavedData = coreDataReadUseCase.execute(for: .myBook)
        let newBook = Book(title: item.title,
                           authors: item.authors,
                           price: item.price,
                           description: nil,
                           imageURL: nil,
                           isRecent: false)
        return currentSavedData.contains(newBook)
    }
}

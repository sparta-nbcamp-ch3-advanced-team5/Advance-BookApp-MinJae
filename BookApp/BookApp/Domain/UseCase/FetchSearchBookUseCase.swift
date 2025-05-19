//
//  FetchSearchBookUseCase.swift
//  BookApp
//
//  Created by MJ Dev on 5/19/25.
//

import Foundation
import RxSwift

final class FetchSearchBookUseCase {
    private let repository: FetchSearchBookRepository
    
    init(repository: FetchSearchBookRepository) {
        self.repository = repository
    }
    
    func execute(query: String,
                page: Int) async -> Single<BookResponse> {
        return await repository.fetchSearchBook(query: query, page: page)
    }
}

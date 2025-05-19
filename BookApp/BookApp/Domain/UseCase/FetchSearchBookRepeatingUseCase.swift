//
//  FetchSearchBookRepeating.swift
//  BookApp
//
//  Created by MJ Dev on 5/19/25.
//

import Foundation
import RxSwift

final class FetchSearchBookRepeatingUseCase {
    
    private let repository: FetchSearchBookRepository
    
    init(repository: FetchSearchBookRepository) {
        self.repository = repository
    }
    
    func excute() async -> Single<BookResponse> {
        return await repository.fetchSearchBookRepeat()
    }
}

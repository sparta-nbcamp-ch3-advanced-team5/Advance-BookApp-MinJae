//
//  CoreDataDeleteUseCase.swift
//  BookApp
//
//  Created by MJ Dev on 5/19/25.
//

import Foundation

final class CoreDataDeleteUseCase {
    private let repository: CoreDataRepository
    
    init(repository: CoreDataRepository) {
        self.repository = repository
    }
    
    func execute(for entityModel: CoreDataEntity, to item: Book) {
        repository.delete(for: entityModel, item: item)
    }
}

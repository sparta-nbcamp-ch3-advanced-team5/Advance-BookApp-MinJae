//
//  CoreDataDeleteAllUseCase.swift
//  BookApp
//
//  Created by MJ Dev on 5/19/25.
//

import Foundation

final class CoreDataDeleteAllUseCase {
    private let repository: CoreDataRepository
    
    init(repository: CoreDataRepository) {
        self.repository = repository
    }
    
    func execute(for entityModel: CoreDataEntity) {
        repository.deleteAll(for: entityModel)
    }
}

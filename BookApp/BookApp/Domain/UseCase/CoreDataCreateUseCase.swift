//
//  CoreDataCreateUseCase.swift
//  BookApp
//
//  Created by MJ Dev on 5/19/25.
//

import Foundation

final class CoreDataCreateUseCase {
    private let repository: CoreDataRepository
    
    init(repository: CoreDataRepository) {
        self.repository = repository
    }
    
    func execute(for entityModel: CoreDataEntity, to item: Book) {
        repository.create(for: entityModel, to: item)
    }
}

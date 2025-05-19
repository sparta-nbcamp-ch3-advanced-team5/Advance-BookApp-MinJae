//
//  CoreDataRepositoryImpl.swift
//  BookApp
//
//  Created by MJ Dev on 5/19/25.
//

import Foundation

final class CoreDataRepositoryImpl: CoreDataRepository {
    
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func create(for entityModel: CoreDataEntity, to item: Book) {
        coreDataManager.create(for: entityModel, to: item)
    }
    
    func read(for entityModel: CoreDataEntity) -> [Book] {
        return coreDataManager.read(for: entityModel)
    }
    
    func delete(for entityModel: CoreDataEntity, item: Book) {
        coreDataManager.delete(for: entityModel, item: item)
    }
    
    func deleteAll(for entityModel: CoreDataEntity) {
        coreDataManager.deleteAll(for: entityModel)
    }
    
    
}

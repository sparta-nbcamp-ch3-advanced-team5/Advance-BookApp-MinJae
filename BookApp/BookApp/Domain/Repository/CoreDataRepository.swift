//
//  CoreDataRepository.swift
//  BookApp
//
//  Created by MJ Dev on 5/19/25.
//

import Foundation

protocol CoreDataRepository {
    func create(for entityModel: CoreDataEntity, to item: Book)
    func read(for entityModel: CoreDataEntity) -> [Book]
    func delete(for entityModel: CoreDataEntity, item: Book)
    func deleteAll(for entityModel: CoreDataEntity)
}

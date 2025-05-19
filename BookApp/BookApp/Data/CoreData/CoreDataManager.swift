//
//  CoreDataManager.swift
//  BookApp
//
//  Created by MJ Dev on 5/12/25.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    // CREATE
    func create<T: Decodable>(for entityModel: CoreDataEntity,
                to item: T) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityModel.entityName, in: context) else { return }
        let newItem = NSManagedObject(entity: entity, insertInto: context)
        let mirror = Mirror(reflecting: item)
        let keys = entityModel.object.keys
        mirror.children.forEach { child in
            if let label = child.label, keys.contains(label) {
                if let authors = child.value as? [String] {
                    newItem.setValue(authors.joined(separator: ", "), forKey: EntityKeyTransfer.transfer(label))
                } else {
                    newItem.setValue(child.value, forKey: EntityKeyTransfer.transfer(label))
                }
            }
        }
        
        do {
            try context.save()
        } catch {
            print("CoreDataManager Create error")
        }
    }
    
    // READ
    func read(for entityModel: CoreDataEntity) -> [Book] {
        
        guard let entityType = entityModel.object.type as? NSManagedObject.Type else { return [] }
        
        let keys = entityModel.object.keys
        
        do {
            let books = try context.fetch(entityType.fetchRequest())
            var result = [Book]()
            if let datas = books as? [NSManagedObject] {
                for element in datas {
                    var data = [String: Any]()
                    keys.map{
                        let key = EntityKeyTransfer.transfer($0)
                        data[key] = element.value(forKey: key)
                    }
                    if let title = data["title"] as? String,
                       let authors = data["authors"] as? String,
                       let price = data["price"] as? Int
                    {
                        result.append(
                            Book(title: title,
                                 authors: authors.components(separatedBy: ", "),
                                 price: price,
                                 description: data["descriptionString"] as? String ?? nil,
                                 imageURL: data["imageURLString"] as? String ?? nil,
                                 isRecent: true
                                )
                        )
                    }
                }
            }
            return result
        } catch {
            print("READ ERROR")
            return []
        }
    }
    
    // DELETE
    func delete(for entityModel: CoreDataEntity, item: Book) {
        guard let entityType = entityModel.object.type as? NSManagedObject.Type else { return }
        
        let request = entityType.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", item.title)
        
        do {
            let result = try context.fetch(request)
            
            for element in result {
                guard let unwrapped = element as? NSManagedObject else { continue }
                context.delete(unwrapped)
            }
            try context.save()
        } catch {
            print("CoreDataManager Delete error")
        }
    }
    
    // DELETE ALL
    func deleteAll(for entityModel: CoreDataEntity) {
        guard let entityType = entityModel.object.type as? NSManagedObject.Type else { return }
        do {
            let result = try context.fetch(entityType.fetchRequest())
            for element in result {
                guard let unwrapped = element as? NSManagedObject else { continue }
                context.delete(unwrapped)
            }
            try context.save()
        } catch {
            print("CoreDataManager Delete All error")
        }
    }
    
}

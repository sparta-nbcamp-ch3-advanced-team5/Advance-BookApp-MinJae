//
//  CoreDataManager.swift
//  BookApp
//
//  Created by MJ Dev on 5/12/25.
//

import UIKit
import CoreData

enum CoreDatakey {
    static let bookEntityName = "MyBook"
}

final class CoreDataManager {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    // CREATE
    func create(to book: Book) {
        guard let entity = NSEntityDescription.entity(forEntityName: CoreDatakey.bookEntityName, in: context) else { return }
        let newBook = NSManagedObject(entity: entity, insertInto: context)
        newBook.setValue(book.title, forKey: "title")
        newBook.setValue(book.authors.joined(separator: ", "), forKey: "author")
        newBook.setValue(book.price, forKey: "price")
        
        do {
            try context.save()
        } catch {
            print("CoreDataManager Create error")
        }
    }
    
    // READ
    func read() -> [Book] {
        do {
            let books = try context.fetch(MyBook.fetchRequest())
            var result = [Book]()
            for element in books {
                guard let title = element.title,
                      let author = element.author
                else {
                    continue
                }
                result.append(Book(title: title,
                                   authors: author.components(separatedBy: " ,"),
                                   price: Int(element.price),
                                   description: nil,
                                   imageURL: nil)
                )
            }
            return result
        } catch {
            print("CoreDataManager Read error")
            return []
        }
    }
    
    // DELETE
    func delete(book: Book) {
        let request = MyBook.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", book.title)
        
        do {
            let result = try context.fetch(request)
            
            for element in result {
                context.delete(element)
            }
            try context.save()
        } catch {
            print("CoreDataManager Delete error")
        }
    }
    
    // DELETE ALL
    func deleteAll() {
        do {
            let result = try context.fetch(MyBook.fetchRequest())
            for element in result {
                context.delete(element)
            }
            try context.save()
        } catch {
            print("CoreDataManager Delete All error")
        }
    }
    
}

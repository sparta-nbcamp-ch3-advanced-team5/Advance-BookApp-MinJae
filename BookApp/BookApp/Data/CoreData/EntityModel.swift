//
//  EntityModel.swift
//  BookApp
//
//  Created by MJ Dev on 5/15/25.
//

import Foundation
import CoreData

// 코어데이터 엔티티 이름
enum CoreDataEntity {
    case myBook
    case recentBook
    
    var entityName: String {
        switch self {
        case .myBook:
            return "MyBook"
        case .recentBook:
            return "RecentBook"
        }
    }
    
    var object: any Entityable {
        switch self {
        case .myBook:
            return MyBookCoreDataModelImpl()
        case .recentBook:
            return RecentBookCoreDataModelImpl()
        }
    }
}

// MyBook 엔티티 키
enum MyBookKey: String, CaseIterable {
    case title
    case authors
    case price
}

enum RecentBookKey: String, CaseIterable {
    case title
    case authors
    case price
    case description
    case imageURL
}

struct EntityKeyTransfer {
    static func transfer(_ key: String) -> String {
        switch key {
        case "title":
            return "title"
        case "authors":
            return "authors"
        case "price":
            return "price"
        case "description":
            return "descriptionString"
        case "imageURL":
            return "imageURLString"
        default:
            return ""
        }
    }
}

protocol Entityable {
    associatedtype Model: NSManagedObject
    var type: Model.Type { get set }
    var keys: [String] { get }
    var entityName: String { get }
}

struct MyBookCoreDataModelImpl: Entityable {
    typealias Model = MyBook
    var type = MyBook.self
    var keys: [String] {
        return MyBookKey.allCases.map{ $0.rawValue }
    }
    var entityName: String {
        return CoreDataEntity.myBook.entityName
    }
}

struct RecentBookCoreDataModelImpl: Entityable {
    typealias Model = RecentBook
    var type = RecentBook.self
    var keys: [String] {
        return RecentBookKey.allCases.map{ $0.rawValue }
    }
    var entityName: String {
        return CoreDataEntity.recentBook.entityName
    }
}

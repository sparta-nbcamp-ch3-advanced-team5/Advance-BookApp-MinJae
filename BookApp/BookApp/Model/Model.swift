//
//  Model.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import Foundation

struct BookResponse: Hashable, Decodable {
    let documents: [Book]
    let meta: Meta
}

struct Book: Hashable, Decodable {
    let title: String
    let authors: [String]
    let price: Int
    let description: String?
    let imageURL: String?
    var isRecent: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case title, authors
        case price = "sale_price"
        case description = "contents"
        case imageURL = "thumbnail"
    }
}

struct Meta: Hashable, Decodable {
    let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
    }
}

//
//  Model.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import Foundation

struct Book: Hashable, Decodable {
    let title: String
    let authors: [String]
    let price: Int
    let description: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case title, authors
        case price = "sale_price"
        case description = "contents"
        case imageURL = "thumbnail"
    }
}

struct BookResponse: Hashable, Decodable {
    let documents: [Book]
}

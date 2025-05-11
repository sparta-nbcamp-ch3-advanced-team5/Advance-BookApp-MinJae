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
    let description: String = ""
    let imageURL: String = ""
    
    enum CordingKeys: String, CodingKey {
        case title
        case authors = "authors"
        case price = "sale_price"
        case description = "contents"
        case imageURL = "thumbnail"
    }
}

struct BookResponse: Decodable {
    let documents: [Book]
}

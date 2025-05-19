//
//  BookResponseDTO.swift
//  BookApp
//
//  Created by MJ Dev on 5/19/25.
//

import Foundation

struct BookResponseDTO: Hashable, Decodable {
    let documents: [BookDTO]
    let meta: Meta
}

struct BookDTO: Hashable, Decodable {
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


extension BookResponseDTO {
    func toEntity() -> BookResponse {
        return BookResponse(documents: documents.map{ $0.toEntity() }, meta: meta)
    }
}

extension BookDTO {
    func toEntity() -> Book {
        return Book(
            title: title,
            authors: authors,
            price: price,
            description: description,
            imageURL: imageURL,
            isRecent: isRecent
        )
    }
}

//
//  FetchSearchBookRepository.swift
//  BookApp
//
//  Created by MJ Dev on 5/19/25.
//

import Foundation
import RxSwift

protocol FetchSearchBookRepository {
    func fetchSearchBook(query: String, page: Int) async -> Single<BookResponse>
    func fetchSearchBookRepeat() async -> Single<BookResponse>
}

//
//  FetchSearchBookRepositoryImpl.swift
//  BookApp
//
//  Created by MJ Dev on 5/19/25.
//

import Foundation
import RxSwift

final actor FetchSearchBookRepositoryImpl: FetchSearchBookRepository {
    
    var query: String = ""
    var page: Int = 0
    
    func fetchSearchBookRepeat() async -> Single<BookResponse> {
        page += 1
        return await networkManager.fetch(query: query, page: page)
    }
    
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchSearchBook(query: String, page: Int) async -> Single<BookResponse> {
        self.query = query
        self.page = page
        return await networkManager.fetch(query: query, page: page)
    }
}

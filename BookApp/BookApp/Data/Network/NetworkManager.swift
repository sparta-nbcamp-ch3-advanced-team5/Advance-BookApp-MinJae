//
//  NetworkManager.swift
//  BookApp
//
//  Created by MJ Dev on 5/12/25.
//

import Foundation
import Alamofire
import RxSwift

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case dataFetchError
    case serverError(Int)
    case unknown
}

final class NetworkManager {
    
    
    func fetch<T: Decodable>(query: String, page: Int) async -> Single<T> {
        return Single.create { observer in
            Task {
                var urlComponents = URLComponents()
                urlComponents.scheme = "https"
                urlComponents.host = "dapi.kakao.com"
                urlComponents.path = "/v3/search/book"
                urlComponents.queryItems = [
                    URLQueryItem(name: "query", value: query),
                    URLQueryItem(name: "page", value: String(page))
                ]
                guard let url = urlComponents.url else {
                    observer(.failure(NetworkError.invalidURL))
                    return
                }
                
                var urlRequest = URLRequest(url: url)
                urlRequest.setValue(self.apiKey, forHTTPHeaderField: "Authorization")
                
                let session = Session.default
                let request = session.request(urlRequest)
                
                let response = await request.serializingDecodable(T.self).response
                
                guard let statusCode = response.response?.statusCode,
                      (200..<300).contains(statusCode) else {
                    observer(.failure(NetworkError.serverError(response.response?.statusCode ?? 0)))
                    return
                }
                
                guard let data = response.data else {
                    observer(.failure(NetworkError.dataFetchError))
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(decoded))
                } catch {
                    observer(.failure(NetworkError.decodingError))
                    return
                }
                
            }
            return Disposables.create()
        }
    }
}

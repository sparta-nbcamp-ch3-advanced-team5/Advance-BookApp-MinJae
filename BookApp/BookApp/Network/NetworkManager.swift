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
    
    func fetch<T: Decodable>(urlString: String) async -> Single<T> {
        return Single.create { observer in
            Task {
                guard let url = URL(string: urlString) else {
                    observer(.failure(NetworkError.invalidURL))
                    return
                }
                let urlRequest = URLRequest(url: url)
                
                guard let (data, response) = try? await AF.session.data(for: urlRequest) else {
                    observer(.failure(NetworkError.dataFetchError))
                    return
                }
                
                let res = response as? HTTPURLResponse
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                      (200..<300).contains(statusCode) else {
                    observer(.failure(NetworkError.serverError(res?.statusCode ?? 0)))
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

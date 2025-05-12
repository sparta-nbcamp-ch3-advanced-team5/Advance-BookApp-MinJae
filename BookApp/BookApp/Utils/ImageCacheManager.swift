//
//  ImageCacheManager.swift
//  BookApp
//
//  Created by MJ Dev on 5/12/25.
//

import UIKit
import Alamofire

final class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    private init() {}
    
    var cache = NSCache<NSString, UIImage>()
    
    func image(urlString: String) async throws -> UIImage? {
        
        let nsString = NSString(string: urlString)
        
        guard let url = URL(string: urlString) else {
            throw(NetworkError.invalidURL)
        }
        
        guard cache.object(forKey: nsString) == nil else {
            return cache.object(forKey: nsString)
        }
        
        let session = Session(configuration: .default)
        let request = session.request(url)
        
        let response = await request.serializingData().response
        
        guard let statusCode = response.response?.statusCode,
              (200..<300).contains(statusCode) else {
            throw(NetworkError.serverError(response.response?.statusCode ?? 0))
        }
        guard let data = response.data,
              let image = UIImage(data: data) else {
            throw(NetworkError.decodingError)
        }
        cache.setObject(image, forKey: nsString)
        return image
    }
}

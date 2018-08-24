//
//  URLSession+Requester.swift
//  KitsuAnime
//
//  Created by  LaptopGCampos on 8/15/18.
//  Copyright © 2018 ApplaudoStudios. All rights reserved.
//

import JustNetworking

enum APICustomError: Error {
    case unknown
}

extension URLSession: APIRequester {
    public func execute<T>(_ request: T, response: @escaping (APIResult<T.APIResponse>) -> Void) where T: APIRequest {
        self.dataTask(with: request.urlRequest, completionHandler: { data, _, error in
            guard let data = data else {
                response(.failure(error ?? APICustomError.unknown))
                return
            }
            do {
                let objectParsed = try request.requestParser(data)
                response(.success(objectParsed))
            } catch {
                response(.failure(error))
            }
        }).resume()
    }
}

//
//  AmiiboRequest.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import JustNetworking

enum AmiiboRequest {
    
    static func amiibo<T: Decodable>(router: AmiiboRouter,
                                     decoder: JSONDecoder = JSONDecoder(),
                                     compose: RequestBuilder = identity) -> BaseRequest<T> {
        
        return BaseRequest<T>.makeRequest(type: T.self,
                                          router: router,
                                          decoder: decoder,
                                          compose: compose)
    }
}

 func add(parameters: [String:String]) -> RequestBuilder {
    return { request in
        
        guard let url = request.url else {
            return request
        }
        
        var request = request
        let queryItems =  parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        request.url = components?.url
        return request
    }
    
}

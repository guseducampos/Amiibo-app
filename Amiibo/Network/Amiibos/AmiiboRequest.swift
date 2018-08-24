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

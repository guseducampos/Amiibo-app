//
//  AmiiboRequest.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import Foundation
import JustNetworking

enum TypeRequest {
    
    static func type<T: Decodable>(route: TypeRouter,
                                   decoder: JSONDecoder = JSONDecoder(),
                                   compose: @escaping RequestBuilder = identity) -> BaseRequest<AmiiboResponse<T>> {
        return BaseRequest<AmiiboResponse<T>>.makeRequest(type: AmiiboResponse<T>.self,
                                          router: route,
                                          decoder: decoder,
                                          compose: compose)
    }
}

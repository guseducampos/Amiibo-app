//
//  BaseRequest+Builder.swift
//  KitsuAnime
//
//  Created by  LaptopGCampos on 8/20/18.
//  Copyright © 2018 ApplaudoStudios. All rights reserved.
//

import JustNetworking

extension BaseRequest {

    static func makeRequest<T: Decodable>(type: T.Type,
                                          router: Router,
                                          decoder: JSONDecoder,
                                          compose: @escaping RequestBuilder) -> BaseRequest<T> {
        let requestFactory = RequestFactory(router: router, requestBuilder: compose)
        return BaseRequest<T>(requestFactory: requestFactory, decoder: decoder)
    }

    static func makeRequest<T>(type: T.Type,
                               router: Router,
                               parser: @escaping (Data) throws -> T ,
                               compose: RequestBuilder = identity) -> BaseRequest<T> {
        let requestFactory = RequestFactory(router: router)
        return BaseRequest<T>(requestFactory: requestFactory) { data -> T in
            try parser(data)
        }
    }
}

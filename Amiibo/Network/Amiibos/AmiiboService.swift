//
//  AmiiboService.swift
//  Amiibo
//
//  Created by Gustavo Campos on 9/10/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import RxSwift
import JustNetworking

struct AmiiboService {
    
    private let network: API
    
    init(network: APIRequester) {
        self.network = API(requester: network)
    }
    
    func fetchAmiibos() -> Observable<[Amiibo]> {
        return network.rx.execute(AmiiboRequest.amiibo(router: .all))
    }
}

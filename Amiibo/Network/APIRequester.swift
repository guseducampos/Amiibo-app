//
//  APIRequester.swift
//  KitsuAnime
//
//  Created by  LaptopGCampos on 8/15/18.
//  Copyright © 2018 ApplaudoStudios. All rights reserved.
//

import JustNetworking
import RxSwift

class API {

    private let requester: APIRequester

    init(requester: APIRequester) {
        self.requester = requester
    }

    func execute<T: APIRequest>(_ request: T, response: @escaping RequestResponse<T.APIResponse>) {
        requester.execute(request, response: response)
    }
}

extension API: ReactiveCompatible {}

extension Reactive where Base: API {

    func execute<T: APIRequest>(_ request: T) -> Observable<T.APIResponse> {
        return Observable<T.APIResponse>.create {[base = self.base] observer -> Disposable in
            base.execute(request) { result in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                
            }
        }
    }
}

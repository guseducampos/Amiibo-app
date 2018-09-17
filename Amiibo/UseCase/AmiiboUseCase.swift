//
//  AmiiboRepository.swift
//  Amiibo
//
//  Created by Gustavo Campos on 9/10/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import RxSwift
import Realm
import RealmSwift
import JustNetworking

protocol AmiiboUseCase {
    
    func fetchAmiibos() -> Observable<[Amiibo]>
    
    func searchAmiibos(_ text: String) -> Observable<[Amiibo]> 
}

struct AmiiboPlatformUseCase: AmiiboUseCase {
    
    let api: API
    let reachabilityService: ReachabilityService
    
    static var useCase: AmiiboPlatformUseCase {
        return AmiiboPlatformUseCase(requester: URLSession.shared, reachabilityService: try! DefaultReachabilityService())
    }
    
    init(requester: APIRequester, reachabilityService: ReachabilityService) {
        self.api = API(requester: requester)
        self.reachabilityService = reachabilityService
    }
    
    func fetchAmiibos() -> Observable<[Amiibo]> {
        return  reachabilityService.reachability.flatMap { reachabiityStatus -> Observable<[Amiibo]> in
            if reachabiityStatus.reachable {
                return self.getAmiibos()
            } else {
                return self.getAmiibosFromCache()
            }
        }
    }
    
    func searchAmiibos(_ text: String) -> Observable<[Amiibo]> {
        return reachabilityService.reachability.flatMap {  reachabiityStatus -> Observable<[Amiibo]> in
            if reachabiityStatus.reachable {
                return self.getAmiibos(compose: add(parameters: ["name": text]))
            } else {
                return self.searchAmiibosFromCacheBy(character: text)
            }
        }
    }
    
    private func save(amiibos: [Amiibo]) -> Observable<Void> {
        return Observable.create({ observer -> Disposable in
            let realm = try! Realm()
            try? realm.write {
                realm.add(amiibos.map { $0.realmObject() }, update: true)
            }
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    private func getAmiibos(compose: @escaping RequestBuilder = identity) -> Observable<[Amiibo]>  {
        return api.rx.execute(AmiiboRequest.amiibo(router: .all, compose: compose)).flatMap {  amiiboResponse -> Observable<[Amiibo]>  in
            return self.save(amiibos: amiiboResponse.amiibo ).map { amiiboResponse.amiibo }
        }
    }
    
    private func  getAmiibosFromCache() -> Observable<[Amiibo]>  {
        return Observable.create({ observer -> Disposable in
            let realm = try! Realm()
            let amiibos = realm.objects(RealmAmiibo.self)
            observer.onNext(Array(amiibos).map { $0.domainObject() })
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    private func searchAmiibosFromCacheBy(character: String) -> Observable<[Amiibo]>  {
        return Observable.create({ observer -> Disposable in
            let realm = try! Realm()
            let amiibos = realm.objects(RealmAmiibo.self).filter("name BEGINSWITH %@", character)
            observer.onNext(Array(amiibos).map { $0.domainObject() })
            observer.onCompleted()
            return Disposables.create()
        })
    }
}

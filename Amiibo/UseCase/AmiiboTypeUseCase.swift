//
//  AmiiboTypeRepository.swift
//  Amiibo
//
//  Created by Gustavo Campos on 9/10/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import RxSwift
import RealmSwift
import Realm
import JustNetworking

protocol TypeUseCase {
    
    func fetchTypes() -> Observable<[Type]> 
}

struct AmiiboTypePlatformUseCase: TypeUseCase {
    
    let api: API
    let reachabilityService: ReachabilityService
    
    static var useCase: AmiiboTypePlatformUseCase {
        return AmiiboTypePlatformUseCase(requester: URLSession.shared, reachabilityService: try! DefaultReachabilityService())
    }
    
    init(requester: APIRequester, reachabilityService: ReachabilityService) {
        self.api = API(requester: requester)
        self.reachabilityService = reachabilityService
    }
    
    func fetchTypes() -> Observable<[Type]>  {
        return reachabilityService.reachability.flatMap { status -> Observable<[Type]> in
            if status.reachable {
                return self.getTypes()
            } else {
                return self.getTypesFromCache()
            }
        }
    }
    
    private func getTypes() -> Observable<[Type]> {
        return api.rx.execute(TypeRequest.type(route: .all)).flatMap {  amiiboResponse in
            return  self.save(amiiboType: amiiboResponse.amiibo).map { amiiboResponse.amiibo  }
        }
    }
    
    private func getTypesFromCache() -> Observable<[Type]> {
        return Observable.create({ observer -> Disposable in
            let realm = try! Realm()
            let types = realm.objects(RealmAmiiboType.self)
            observer.onNext(Array(types).map { $0.domainObject() })
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    private func save(amiiboType type: [Type]) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let realm = try! Realm()
            try? realm.write {
                realm.add(type.map { $0.realmObject() }, update: true)
            }
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        })
    }
}

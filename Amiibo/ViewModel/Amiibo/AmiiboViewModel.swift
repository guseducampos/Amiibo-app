//
//  AmiiboViewModel.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import RxSwift
import Realm
import RealmSwift
import JustNetworking

struct AmiiboType: Codable {
    var type: Type
    var items: [Amiibo]
}

protocol AmiiboViewModelOutputs {
    
    var showTypes: Observable<[AmiiboType]> { get }
}

protocol AmiiboViewModelType {
    
    var outputs: AmiiboViewModelOutputs { get }
}

final class AmiiboViewModel: AmiiboViewModelType, AmiiboViewModelOutputs  {
    
    // MARK: Properties
    private let realm: Realm
    private let reachability: ReachabilityService
    private let network: API
    
    // MARK: Initializer
    init(requester: APIRequester = URLSession.shared, realm: Realm, reachability: ReachabilityService) {
        self.network = API(requester: requester)
        self.realm = realm
        self.reachability = reachability
    }
    
    // MARK: Protocol implementation
    lazy var showTypes: Observable<[AmiiboType]>  = {
        self.reachability.reachability.flatMap { status -> Observable<[AmiiboType]> in
            if status.reachable {
                return self.combined()
            } else {
                return self.getFromCache()
            }
        }
    }()
    
    var outputs: AmiiboViewModelOutputs {
        return self
    }
    
    // MARK: functions
   private func getTypes() -> Observable<[Type]> {
        return network.rx.execute(TypeRequest.type(route: .all))
    }
    
    private func getAmiibos() -> Observable<[Amiibo]> {
        return network.rx.execute(AmiiboRequest.amiibo(router: .all))
    }
    
    private func combined() -> Observable<[AmiiboType]> {
        return getTypes().flatMap { types in
            self.getAmiibos().map { $0.groupBy(types:types )  }
            }.flatMap {
                self.save($0)
        }
    }
    
    private func getFromCache() -> Observable<[AmiiboType]> {
        return Observable.create({ observer -> Disposable in
            try? self.realm.write {
                let objects = self.realm.objects(RealmObject<[AmiiboType]>.self).first?.decode() ?? []
                observer.onNext(Array(objects))
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }
    
    private func save(_ object: [AmiiboType]) -> Observable<[AmiiboType]> {
        return Observable.create({ observer -> Disposable in
            try? self.realm.write {
                self.realm.add(RealmObject(value: object), update: true)
                observer.onNext(object)
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }
}

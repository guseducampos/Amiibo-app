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

struct AmiiboType {
    var type: Type
    var items: [(type: Type, items: [Amiibo])]
}

protocol AmiiboViewModelOutputs {
    
    var showTypes: Observable<[AmiiboType]> { get }
}

protocol AmiiboViewModelType {
    
    var outputs: AmiiboViewModelOutputs { get }
}

final class AmiiboViewModel: AmiiboViewModelType, AmiiboViewModelOutputs  {
    
    // MARK: Properties
    private let reachability: ReachabilityService
    private let network: API
    
    // MARK: Initializer
    init(requester: APIRequester = URLSession.shared, reachability: ReachabilityService) {
        self.network = API(requester: requester)
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
   private func getTypes() -> Observable<AmiiboResponse<[Type]>> {
        return network.rx.execute(TypeRequest.type(route: .all))
    }
    
    private func getAmiibos() -> Observable<AmiiboResponse<[Amiibo]>> {
        return network.rx.execute(AmiiboRequest.amiibo(router: .all))
    }
    
    private func combined() -> Observable<[AmiiboType]> {
        return getTypes().flatMap { types in
            self.getAmiibos().map { (types: types.amiibo, amiibos: $0.amiibo )  }
            }.flatMap {
                self.save(types: $0.types, amiibos: $0.amiibos)
        }
    }
    
    private func getFromCache() -> Observable<[AmiiboType]> {
        return Observable.create({ observer -> Disposable in
            let realm = try! Realm()
            let types = Array(realm.objects(Type.self))
            let objects = Array(realm.objects(Amiibo.self)).groupBy(types: types)
            observer.onNext(objects)
            observer.onCompleted()
            return Disposables.create()
        }).subscribeOn(MainScheduler.instance)
    }
    
    private func save(types: [Type], amiibos: [Amiibo]) -> Observable<[AmiiboType]> {
        return Observable.create({ observer -> Disposable in
            let realm = try! Realm()
            try? realm.write {
                realm.add(types, update: true)
                realm.add(amiibos, update: true)
            }
            observer.onNext(amiibos.groupBy(types: types))
            observer.onCompleted()
            return Disposables.create()
        }).subscribeOn(MainScheduler.instance)
    }
}

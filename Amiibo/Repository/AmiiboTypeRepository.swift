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

struct AmiiboTypeRepository {
    
    func save(amiiboType type: [Type], on scheduler: SchedulerType = MainScheduler.instance) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let realm = try! Realm()
            try? realm.write {
                realm.add(type, update: true)
            }
            return Disposables.create()
        }).observeOn(scheduler)
    }
    
    func getAmiiboType(on scheduler: SchedulerType = MainScheduler.instance) -> Observable<[Type]> {
        return Observable.create({ (observer) -> Disposable in
            let realm = try! Realm()
            let amiibos = Array(realm.objects(Type.self))
            observer.onNext(amiibos)
            observer.onCompleted()
            return Disposables.create()
        }).observeOn(scheduler)
    }
}

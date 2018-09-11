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

struct AmiiboRepository {
    
    func save(amiibos: [Amiibo], on scheduler: SchedulerType = MainScheduler.instance) -> Observable<Void> {
        return Observable.create({ observer -> Disposable in
            let realm = try! Realm()
            try? realm.write {
                realm.add(amiibos, update: true)
            }
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }).observeOn(scheduler)
    }
    
    func getAmiibos(on scheduler: SchedulerType = MainScheduler.instance) -> Observable<[Amiibo]>  {
        return Observable.create({ observer -> Disposable in
            let realm = try! Realm()
            let amiibos = Array(realm.objects(Amiibo.self))
            observer.onNext(amiibos)
            observer.onCompleted()
            return Disposables.create()
        }).observeOn(scheduler)
    }
}

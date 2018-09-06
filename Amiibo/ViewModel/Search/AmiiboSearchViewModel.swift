//
//  AmiiboSearchViewModel.swift
//  Amiibo
//
//  Created by Gustavo Campos on 8/28/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import RxSwift
import RxCocoa
import JustNetworking
import Realm
import RealmSwift

protocol AmiiboSearchViewModelInput {
    
    func searchAmiibos(_ text: String)
}


protocol AmiiboSearchViewModelOutputs {
    
    var showAmiibos: Observable<[Amiibo]> { get }
}

protocol AmiiboSearchViewModelType {
    
    var input: AmiiboSearchViewModelInput { get }
    
    var output: AmiiboSearchViewModelOutputs { get }
}


final class AmiiboSearchViewModel: AmiiboSearchViewModelType,AmiiboSearchViewModelInput,AmiiboSearchViewModelOutputs {
    
    // MARK: Properties
    private let reachability: ReachabilityService
    private let network: API
    
    // MARK: Initializer
    init(requester: APIRequester = URLSession.shared, reachability: ReachabilityService) {
        self.network = API(requester: requester)
        self.reachability = reachability
    }
    
    var input: AmiiboSearchViewModelInput {
        return self
    }
    
    var output: AmiiboSearchViewModelOutputs {
        return self
    }
    
    lazy var showAmiibos: Observable<[Amiibo]> = {
        searchText.asObservable().skip(1).flatMapLatest { text in
            return self.searchAmiibos(text)
        }
    }()
    
    private var searchText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func searchAmiibos(_ text: String) {
        searchText.accept(text)
    }
    
    private func searchAmiibos(_ text: String) -> Observable<[Amiibo]> {
        return reachability.reachability.flatMap { reachability -> Observable<[Amiibo]> in
            if reachability.reachable {
                return self.network.rx.execute(AmiiboRequest.amiibo(router: .all, compose: add(parameters: ["character": text])))
            } else {
                return self.searchAmiibosOnCache(text: text)
            }
        }
    }
    
    private func searchAmiibosOnCache(text: String) -> Observable<[Amiibo]> {
       return Observable.create { observer -> Disposable in
            let realm = try! Realm()
            let amiibos = realm.objects(Amiibo.self).filter("character like '%@'", text)
            observer.onNext(Array(amiibos))
            observer.onCompleted()
            return Disposables.create()
        }.observeOn(MainScheduler.instance)
    }
}

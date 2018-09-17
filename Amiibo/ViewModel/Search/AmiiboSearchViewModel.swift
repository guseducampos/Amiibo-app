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
    private var searchText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var input: AmiiboSearchViewModelInput {
        return self
    }
    
    var output: AmiiboSearchViewModelOutputs {
        return self
    }
 
    var showAmiibos: Observable<[Amiibo]> 
    
    // MARK: Initializer
    init(dependencies: AmiiboViewModelDependencies) {
        showAmiibos = searchText.skip(1).flatMapLatest  { text in
            dependencies.amiiboUseCase.searchAmiibos(text).catchErrorJustReturn([])
        }
    }
    
    // MARK: Functions
    func searchAmiibos(_ text: String) {
        searchText.accept(text)
    }
}

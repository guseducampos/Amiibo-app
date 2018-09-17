//
//  AmiiboViewModel.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import RxSwift
import RxCocoa
import Realm
import RealmSwift
import JustNetworking

struct AmiiboType {
    var type: Type
    var items: [(type: Type, items: [Amiibo])]
}

protocol AmiiboViewModelInput {
    func viewDidLoad()
}


protocol AmiiboViewModelOutputs {
    
    var showTypes: Observable<[AmiiboType]> { get }
}

protocol AmiiboViewModelType {
    
    var inputs: AmiiboViewModelInput { get }
    var outputs: AmiiboViewModelOutputs { get }
}

final class AmiiboViewModel: AmiiboViewModelType,AmiiboViewModelInput, AmiiboViewModelOutputs {
    
    
    // MARK: Initializer
    init(dependencies: AmiiboViewModelDependencies) {
        
        self.showTypes = viewDidLoadProperty.skip(1).flatMap { 
            dependencies.amiiboTypeRepository.fetchTypes()
            }.flatMap { types in
                dependencies.amiiboUseCase.fetchAmiibos().map { $0.groupBy(types: types) }
         }
    }
    
    // MARK: Properties
    var viewDidLoadProperty = BehaviorRelay(value: ())
    
    // MARK: Protocol implementation
    var showTypes: Observable<[AmiiboType]> 
    var inputs: AmiiboViewModelInput {
        return self
    }
    
    var outputs: AmiiboViewModelOutputs {
        return self
    }
    func viewDidLoad() {
        viewDidLoadProperty.accept(())
    }

}

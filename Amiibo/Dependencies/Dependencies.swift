//
//  Dependencies.swift
//  Amiibo
//
//  Created by Gustavo Campos on 9/17/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//


struct AmiiboViewModelDependencies {
    let amiiboUseCase: AmiiboUseCase
    let amiiboTypeRepository: TypeUseCase
    
    static var production: AmiiboViewModelDependencies {
        return AmiiboViewModelDependencies(amiiboUseCase: AmiiboPlatformUseCase.useCase, amiiboTypeRepository: AmiiboTypePlatformUseCase.useCase)
    }
}

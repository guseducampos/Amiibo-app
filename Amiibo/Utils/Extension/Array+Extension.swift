//
//  Array+Extension.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import Foundation

extension Array where Element == Amiibo {
    
    func groupBy(types: [Type]) -> [AmiiboType] {
       return types.map { `type` in
            return (type: type, Amiibos: self.filter { $0.type == type.name })
        }.map(AmiiboType.init)
    }
}

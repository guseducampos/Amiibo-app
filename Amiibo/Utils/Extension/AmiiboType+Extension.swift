//
//  AmiiboType+Extension.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import RxDataSources

extension AmiiboType: SectionModelType {
    
    init(original: AmiiboType, items: [Amiibo]) {
        self = original
        self.items = items
    }
}

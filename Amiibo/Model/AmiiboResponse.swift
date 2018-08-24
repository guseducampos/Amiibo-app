//
//  AmiiboResponse.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import Foundation

struct AmiiboResponse<T: Decodable>: Decodable {
    
    let amiibo: T
}

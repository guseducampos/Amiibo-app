//
//  AmiiboRouter.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import Foundation
import JustNetworking

enum AmiiboRouter: Router {

    case all
    
    var route: Route {
        return Route(path: "/amiibo", method: .get)
    }
    
}

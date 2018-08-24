//
//  CategoryRouter.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import JustNetworking

enum TypeRouter: Router {
    case all
    
    var route: Route {
        switch self {
        case .all:
            return Route(path: "/type", method: .get)
        }
    }
}

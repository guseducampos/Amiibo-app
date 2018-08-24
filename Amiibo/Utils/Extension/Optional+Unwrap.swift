//
//  Optional+Unwrap.swift
//  KitsuAnime
//
//  Created by  LaptopGCampos on 8/15/18.
//  Copyright © 2018 ApplaudoStudios. All rights reserved.
//

import Foundation

extension Optional {

    func unwrap(orFail message: @autoclosure () -> String) -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
             // swiftlint:disable:next fatal_error
            fatalError(message())
        }
    }
}

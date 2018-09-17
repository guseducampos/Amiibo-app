//
//  RealmObject.swift
//  KitsuAnime
//
//  Created by  LaptopGCampos on 8/21/18.
//  Copyright © 2018 ApplaudoStudios. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol RealmRepresentable {
    
    associatedtype RealmObject: Object
    
    func realmObject() -> RealmObject 
}


protocol DomainRepresentable {
    
    associatedtype Object
    
    func domainObject() -> Object
}

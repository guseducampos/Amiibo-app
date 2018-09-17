//
//  Amiibo.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

struct Amiibo: Decodable, RealmRepresentable {
    
    let name: String
    let amiiboSeries: String
    let character: String
    let gameSeries: String
    let head: String
    let image: String
    let tail: String 
    let type: String 
    
    func realmObject() -> RealmAmiibo {
        let realmAmiibo = RealmAmiibo()
        realmAmiibo.name = name
        realmAmiibo.amiiboSeries = amiiboSeries
        realmAmiibo.character = character
        realmAmiibo.gameSeries = gameSeries
        realmAmiibo.head = head
        realmAmiibo.image = image
        realmAmiibo.tail = tail
        realmAmiibo.type = type
        return realmAmiibo
    }
}

class RealmAmiibo: Object, DomainRepresentable {
    
    @objc dynamic var name: String = ""
    @objc dynamic var amiiboSeries: String = ""
    @objc dynamic var character: String = ""
    @objc dynamic var gameSeries: String = ""
    @objc dynamic var head: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var tail: String = ""
    @objc dynamic var type: String = ""
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "tail"
    }
    
    func domainObject() -> Amiibo {
        return Amiibo(name: name,
                      amiiboSeries: amiiboSeries, 
                      character: character,
                      gameSeries: gameSeries, 
                      head: head, 
                      image: image, 
                      tail: tail, 
                      type: type)
    }
}

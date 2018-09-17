//
//  Category.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import Realm
import RealmSwift


struct Type: Decodable, RealmRepresentable {
    
    let key: String
    let name: String
    
    func realmObject() -> RealmAmiiboType {
        let amiiboType = RealmAmiiboType()
        amiiboType.key = key
        amiiboType.name = name
        return amiiboType
    }
}

class RealmAmiiboType: Object, Decodable, DomainRepresentable {
    
    @objc dynamic var key: String = ""
    @objc dynamic var name: String = ""
    
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
        return "key"
    }
    
    enum CodingKeys: String, CodingKey {
        case key
        case name
    }
    
    public required convenience init (from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key =  try container.decode(String.self, forKey: .key)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func domainObject() -> Type {
        return Type(key: self.key, name: self.name)
    }
}

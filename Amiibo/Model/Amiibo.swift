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

class Amiibo: Object, Decodable {
    
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
    
    enum CodingKeys: String, CodingKey {
        case amiiboSeries
        case character
        case gameSeries
        case head
        case image
        case tail
        case type
    }
    
    public required convenience init (from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amiiboSeries = try container.decode(String.self, forKey: .amiiboSeries)
        character = try container.decode(String.self, forKey: .character)
        gameSeries = try container.decode(String.self, forKey: .gameSeries)
        head = try container.decode(String.self, forKey: .head)
        image = try container.decode(String.self, forKey: .image)
        tail  = try container.decode(String.self, forKey: .tail)
        type = try container.decode(String.self, forKey: .type)
    }
}

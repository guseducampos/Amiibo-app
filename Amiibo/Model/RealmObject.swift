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

class RealmObject<T: Codable>: Object {

    @objc dynamic var data: Data? = nil

    func decode(using decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.data else {
            return nil
        }
        return try? decoder.decode(T.self, from: data)
    }
    
    func setValue(_ value: T, using encoder: JSONEncoder = JSONEncoder()) {
        data = try? encoder.encode(value)
    }

    init(value: T, using encoder: JSONEncoder = JSONEncoder()) {
        super.init()
        self.data = try? encoder.encode(value)
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    required init() {
        super.init()
    }

    override static func primaryKey() -> String? {
        return "data"
    }
}

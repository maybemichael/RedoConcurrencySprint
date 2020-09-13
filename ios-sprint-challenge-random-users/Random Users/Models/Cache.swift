//
//  Cache.swift
//  Random Users
//
//  Created by Michael McGrath on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var cache = Dictionary<Key, Value>()
    let queueAnon = DispatchQueue(label: "QueueAnon")
    
    func setValue(for key: Key, value: Value) {
        queueAnon.async {
            self.cache.updateValue(value, forKey: key)
        }
    }
    
    func getValue(for key: Key) -> Value? {
        queueAnon.sync {
            return self.cache[key]
        }
    }
    
    func clearCache() {
        queueAnon.async {
            self.cache.removeAll()
        }
    }
}

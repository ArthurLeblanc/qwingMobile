//
//  genericDecode.swift
//  ProjetV0
//
//  Created by user164566 on 3/15/20.
//  Copyright © 2020 user164566. All rights reserved.
//

import Foundation
import SwiftyJSON

struct genericDecode {
    /* TODO Trouver comment faire de l'introspection en swift
    func decode<T> (cls: T, json: JSON) -> [T]? {
        var a : UInt32
        var list : [T]
        for obj in json.arrayValue {
            var dict: [String: Any] = class_copyPropertyList(type(of: cls), &a)
            for i in dict.count {
                if (obj[dict.keys[i]] === Array) {
                    guard let dict[i] = decode(cls: Class(dict.keys[i]), json: obj[dict.keys[i]]) else { return }
                } else {
                    guard let dict[i] = obj[dict.keys[i]] else { return }
                }
            }
            list.append(T(dict))
        }
        return list
     }*/
}

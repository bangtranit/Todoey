//
//  Item.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/19.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parrentCatalog = LinkingObjects(fromType: Catalog.self, property: "items")
}

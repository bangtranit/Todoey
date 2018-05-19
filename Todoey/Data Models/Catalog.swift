//
//  Catalog.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/19.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import Foundation
import RealmSwift
class Catalog: Object {
   @objc dynamic var name : String = ""
    let items = List<Item>()
}

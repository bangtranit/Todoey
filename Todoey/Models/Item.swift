//
//  Item.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/16.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit

class ItemObj: NSObject, Encodable, Decodable {
    
    var title : String = ""
    var done : Bool = false
    init(title_str: String, done_status: Bool){
        title = title_str
        done = done_status
    }
}

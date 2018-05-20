//
//  DateHelper.swift
//  Todoey
//
//  Created by Tran Thanh Bang on 2018/05/20.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit

class DateHelper: NSObject {
    private static let sharedInstance = DateHelper()
    class var sharedDateHelper : DateHelper {
        return sharedInstance
    }
    
    func formatStringToDate(dateString: String, format : NSString) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format as String?
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    func getCurrentDate() -> Date{
        let date = Date()
        return date
    }
}

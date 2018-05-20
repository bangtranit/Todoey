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
    
//    func formatStringToDate(dateString: String, format : NSString) -> NSDate{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format as String?
//        if guard let date = dateFormatter.date(from: dateString){
//            return date
//        } else {
//            fatalError("ERROR: Date conversion failed due to mismatched format.")
//            return getCurrentDate()
//        }
//    }

    func getCurrentDate() -> Date{
        let date = Date()
        return date
    }
}

//
//  Detail.swift
//  weedshop
//
//  Created by Devubha Manek on 04/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class OrderDetail: NSObject, NSCoding
{
    
    var detail_date: Date
    var detail_Number: String = ""
    var detail_Total: String = ""
    
    struct keyDetail
    {
        static let date = "date"
        static let number = "orderNumber"
        static let total = "orderTotal"
    }
    
    init(date: Date, number: String, total: String)
    {
        self.detail_date = date
        self.detail_Number = number
        self.detail_Total = total
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let date = aDecoder.decodeObject(forKey: keyDetail.date) as! Date
        let number = aDecoder.decodeObject(forKey: keyDetail.number) as! String
        let total = aDecoder.decodeObject(forKey: keyDetail.total) as! String
        
        self.init(date: date, number: number, total: total)
        
    }
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(detail_date, forKey: keyDetail.date)
        aCoder.encode(detail_Number, forKey: keyDetail.number)
        aCoder.encode(detail_Total, forKey: keyDetail.total)
        
    }
}

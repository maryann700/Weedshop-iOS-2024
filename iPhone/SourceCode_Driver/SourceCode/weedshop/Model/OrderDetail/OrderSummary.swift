//
//  OrderSummary.swift
//  weedshop
//
//  Created by Devubha Manek on 04/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//


import UIKit

class OrderSummary: NSObject, NSCoding
{
    
    var items: String = ""
    var delivaryCharge: String = ""
    var orderTotal: String = ""
    
    struct keyOrderSummary
    {
        static let items = "items"
        static let delivaryCharge = "deliverycharge"
        static let orderTotal = "orderTotal"
    }
    
    init(item: String, number: String, total: String)
    {
        self.items = item
        self.delivaryCharge = number
        self.orderTotal = total
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let item = aDecoder.decodeObject(forKey: keyOrderSummary.items) as! String
        let deliveryCharge = aDecoder.decodeObject(forKey: keyOrderSummary.delivaryCharge) as! String
        let total = aDecoder.decodeObject(forKey: keyOrderSummary.orderTotal) as! String
        
        self.init(item: item, number: deliveryCharge, total: total)
        
    }
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(items, forKey: keyOrderSummary.items)
        aCoder.encode(delivaryCharge, forKey: keyOrderSummary.delivaryCharge)
        aCoder.encode(orderTotal, forKey: keyOrderSummary.orderTotal)
        
    }
}

//
//  Product.swift
//  weedshop
//
//  Created by Devubha Manek on 28/03/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class Product_notify: NSObject, NSCoding
{
    
    
    var delivery_address: String = ""
    var delivery_distance: String = ""
    var delivery_latitude: String = ""
    var delivery_longitude: String = ""
    var delivery_time: String = ""
    
    var driver_address: String = ""
    var driver_id: String = ""
    var driver_latitude: String = ""
    var driver_longitude: String = ""
    var final_total: String = ""
    var id: String = ""
    
    var order_code: String = ""
    var order_date: String = ""
    var request_timeout: String = ""
    var status :String = ""
    var store_id :String = ""
    var user_id :String = ""

    
    struct keyProduct
    {
        static let delivery_address = "delivery_address"
        static let delivery_distance: String = "delivery_distance"
        static let delivery_latitude: String = "delivery_latitude"
        static let delivery_longitude: String = "delivery_longitude"
        static let delivery_time = "delivery_time"
       
        static let driver_address: String = "driver_address"
        static let driver_id: String = "driver_id"
        static let driver_latitude: String = "driver_latitude"
        static let driver_longitude: String = "driver_longitude"
         static let final_total: String = "final_total"
        
        static let id: String = "id"
        
        static let order_code: String = "order_code"
        static let order_date: String = "order_date"
        static let request_timeout: String = "request_timeout"
        static let status: String = "status"
        static let store_id: String = "store_id"
        static let user_id: String = "user_id"
        
       
    }
    
    init(delivery_address: String, delivery_distance: String, delivery_latitude: String, delivery_longitude: String, delivery_time: String, driver_address: String, driver_id: String, driver_latitude: String, driver_longitude: String,final_total:String, id: String, order_code: String, order_date: String,request_timeout: String,status: String,store_id: String,user_id: String )
    {
        self.delivery_address = delivery_address
        self.delivery_distance = delivery_distance
        self.delivery_latitude = delivery_latitude
        self.delivery_longitude = delivery_longitude
        self.delivery_time = delivery_time
        
        self.driver_address = driver_address
        self.driver_id = driver_id
        self.driver_latitude = driver_latitude
        self.driver_longitude = driver_longitude
        self.final_total = final_total
        self.id = id
        
        self.order_code = order_code
        self.order_date = order_date
        self.request_timeout = request_timeout
        self.status = status
        self.store_id = store_id
        self.user_id = user_id
       
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let delivery_address = aDecoder.decodeObject(forKey: keyProduct.delivery_address) as? String
        let delivery_distance = aDecoder.decodeObject(forKey: keyProduct.delivery_distance) as? String
        let delivery_latitude = aDecoder.decodeObject(forKey: keyProduct.delivery_latitude) as? String
        let delivery_longitude = aDecoder.decodeObject(forKey: keyProduct.delivery_longitude) as? String
        let delivery_time = aDecoder.decodeObject(forKey: keyProduct.delivery_time) as? String
        let driver_address = aDecoder.decodeObject(forKey: keyProduct.driver_address) as? String
        let driver_id = aDecoder.decodeObject(forKey: keyProduct.driver_id) as? String
        let driver_latitude = aDecoder.decodeObject(forKey: keyProduct.driver_latitude) as? String
        let driver_longitude = aDecoder.decodeObject(forKey: keyProduct.driver_longitude) as? String
        let final_total = aDecoder.decodeObject(forKey: keyProduct.final_total) as? String
        let id = aDecoder.decodeObject(forKey: keyProduct.id) as? String
        let order_code = aDecoder.decodeObject(forKey: keyProduct.order_code) as? String
        let order_date = aDecoder.decodeObject(forKey: keyProduct.order_date) as? String
        let request_timeout = aDecoder.decodeObject(forKey: keyProduct.request_timeout) as? String
        let status = aDecoder.decodeObject(forKey: keyProduct.status) as? String
        let store_id = aDecoder.decodeObject(forKey: keyProduct.store_id) as? String
        let user_id = aDecoder.decodeObject(forKey: keyProduct.user_id) as? String
        
        self.init(delivery_address: delivery_address!, delivery_distance: delivery_distance!,delivery_latitude: delivery_latitude!,                  delivery_longitude: delivery_longitude!,delivery_time: delivery_time!,driver_address: driver_address!,driver_id: driver_id!,driver_latitude: driver_latitude!,driver_longitude: driver_longitude!,final_total:final_total!,id: id!,order_code: order_code!,                  order_date: order_date!,request_timeout: request_timeout!,status: status!,store_id: store_id!,user_id: user_id!)
    }
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(delivery_address, forKey: keyProduct.delivery_address)
        aCoder.encode(delivery_distance, forKey: keyProduct.delivery_distance)
        aCoder.encode(delivery_latitude, forKey: keyProduct.delivery_latitude)
        aCoder.encode(delivery_longitude, forKey: keyProduct.delivery_longitude)
        aCoder.encode(delivery_time, forKey: keyProduct.delivery_time)
        aCoder.encode(driver_address, forKey: keyProduct.driver_address)
        aCoder.encode(driver_id, forKey: keyProduct.driver_id)
        aCoder.encode(driver_latitude, forKey: keyProduct.driver_latitude)
        aCoder.encode(driver_longitude, forKey: keyProduct.driver_longitude)
        aCoder.encode(final_total, forKey: keyProduct.final_total)
        aCoder.encode(id, forKey: keyProduct.id)
        aCoder.encode(order_code, forKey: keyProduct.order_code)
        aCoder.encode(order_date, forKey: keyProduct.order_date)
        aCoder.encode(request_timeout, forKey: keyProduct.request_timeout)
        aCoder.encode(status, forKey: keyProduct.status)
        aCoder.encode(store_id, forKey: keyProduct.store_id)
        aCoder.encode(user_id, forKey: keyProduct.user_id)
      
        
    }
}



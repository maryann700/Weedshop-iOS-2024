//
//  Shops.swift
//  weedshop
//
//  Created by Devubha Manek on 28/03/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class CurrentOrderDetail : NSObject, NSCoding
{
    
    var id: String = ""
    var order_code: String = ""
    var user_id: String = ""
    var driver_id: String = ""
    var store_id: String = ""
    var order_date: String = ""
    var final_total: String = ""
    var status: String = ""
    var delivery_name: String = ""
    var delivery_phone: String = ""
    var delivery_address: String = ""
    var delivery_latitude: String = ""
    var delivery_longitude: String = ""
    var driver_name: String = ""
    var car_number: String = ""
    var car_brand: String = ""
    var mobile: String = ""
    var driver_latitude: String = ""
    var driver_longitude: String = ""
    var driver_address: String = ""
    var store_latitude: String = ""
    var store_longitude: String = ""
    var store_address: String = ""
    var store_owner: String = ""
    var store_name: String = ""
    var store_distance: String = ""
    var delivery_distance: String = ""
    var store_time: String = ""
    var delivery_time: String = ""
    var store_image: String = ""
    var store_image_url: String = ""
    var user_image: String = ""
    var user_image_url: String = ""

    struct CurrentOrderDetail
    {
        static let id = "id"
        static let order_code = "order_code"
        static let user_id = "user_id"
        static let driver_id = "driver_id"
        static let store_id = "store_id"
        static let store_image = "store_image"
        static let store_image_url = "store_image_url"
        static let user_image = "user_image"
        static let user_image_url = "user_image_url"
        
        static let order_date = "order_date"
        static let final_total = "final_total"
        static let status = "status"
        static let delivery_name = "delivery_name"
        static let delivery_phone = "delivery_phone"
        static let delivery_address = "delivery_address"
        static let delivery_latitude = "delivery_latitude"
        static let delivery_longitude = "delivery_longitude"
        static let driver_name = "driver_name"
        static let car_number = "car_number"
        static let car_brand = "car_brand"
        static let mobile = "mobile"
        static let driver_latitude = "driver_latitude"
        static let driver_longitude = "driver_longitude"
        static let driver_address = "driver_address"
        static let store_latitude = "store_latitude"
        static let store_longitude = "store_longitude"
        static let store_address = "store_address"
        static let store_owner = "store_owner"
        static let store_name = "store_name"
        static let store_distance = "store_distance"
        static let delivery_distance = "delivery_distance"
        static let store_time = "store_time"
        static let delivery_time = "delivery_time"
    }
    
    init(id: String,order_code: String,user_id: String,  driver_id: String,  store_id: String,  order_date: String,  final_total: String, status: String, delivery_name: String, delivery_phone: String, delivery_address: String, delivery_latitude: String, delivery_longitude: String, driver_name: String, car_number: String,  car_brand: String, mobile: String, driver_latitude: String ,  driver_longitude: String ,driver_address:String, store_latitude: String ,store_longitude: String , store_address: String , store_owner: String , store_name: String ,store_distance: String ,  delivery_distance: String , store_time: String ,  delivery_time: String,  user_image: String,  user_image_url: String,  store_image_url: String,  store_image: String)
    {
        
        self.id = id
        self.order_code = order_code
        self.user_id = user_id
        self.driver_id = driver_id
        self.store_id = store_id
        self.order_date = order_date
        self.final_total = final_total
        self.status = status
        self.delivery_name = delivery_name
        self.delivery_phone = delivery_phone
        self.delivery_address = delivery_address
        

        
        self.delivery_latitude = delivery_latitude
        self.delivery_longitude = delivery_longitude
        
        self.driver_name = driver_name
        self.car_number = car_number
        self.car_brand = car_brand
        self.mobile = mobile

        
        self.driver_latitude = driver_latitude
        self.driver_longitude = driver_longitude
        self.driver_address = driver_address
        
        self.store_latitude = store_latitude
        self.store_longitude = store_longitude
        

        
        self.store_address = store_address
        self.store_owner = store_owner
        self.store_name = store_name
        self.store_distance = store_distance
        
        self.delivery_distance = delivery_distance
        self.store_time = store_time
        self.delivery_time = delivery_time
        
        
        self.store_image = store_image
        self.store_image_url = store_image_url
        self.user_image = user_image
        self.user_image_url = user_image_url
    }
    required convenience init?(coder aDecoder: NSCoder)
    {
        let id = aDecoder.decodeObject(forKey: CurrentOrderDetail.id) as? String
        let order_code = aDecoder.decodeObject(forKey: CurrentOrderDetail.order_code) as? String
        let user_id = aDecoder.decodeObject(forKey: CurrentOrderDetail.user_id) as? String
        let driver_id = aDecoder.decodeObject(forKey: CurrentOrderDetail.driver_id) as? String
        let store_id = aDecoder.decodeObject(forKey: CurrentOrderDetail.store_id) as? String
        let order_date = aDecoder.decodeObject(forKey: CurrentOrderDetail.order_date) as? String
        let final_total = aDecoder.decodeObject(forKey: CurrentOrderDetail.final_total) as? String
        let status = aDecoder.decodeObject(forKey: CurrentOrderDetail.status) as? String
        
        let delivery_name = aDecoder.decodeObject(forKey: CurrentOrderDetail.delivery_name) as? String
        let delivery_phone = aDecoder.decodeObject(forKey: CurrentOrderDetail.delivery_phone) as? String
        let delivery_address = aDecoder.decodeObject(forKey: CurrentOrderDetail.delivery_address) as? String
        let delivery_latitude = aDecoder.decodeObject(forKey: CurrentOrderDetail.delivery_latitude) as? String
        let delivery_longitude = aDecoder.decodeObject(forKey: CurrentOrderDetail.delivery_longitude) as? String
        
        let driver_name = aDecoder.decodeObject(forKey: CurrentOrderDetail.driver_name) as? String
        let car_number = aDecoder.decodeObject(forKey: CurrentOrderDetail.car_number) as? String
        let car_brand = aDecoder.decodeObject(forKey: CurrentOrderDetail.car_brand) as? String
        let mobile = aDecoder.decodeObject(forKey: CurrentOrderDetail.mobile) as? String
        let driver_latitude = aDecoder.decodeObject(forKey: CurrentOrderDetail.driver_latitude) as? String
        let driver_longitude = aDecoder.decodeObject(forKey: CurrentOrderDetail.driver_longitude) as? String
        let driver_address = aDecoder.decodeObject(forKey: CurrentOrderDetail.driver_address) as? String
        
        let store_latitude = aDecoder.decodeObject(forKey: CurrentOrderDetail.store_latitude) as? String
        let store_longitude = aDecoder.decodeObject(forKey: CurrentOrderDetail.store_longitude) as? String
        let store_address = aDecoder.decodeObject(forKey: CurrentOrderDetail.store_address) as? String
        let store_owner = aDecoder.decodeObject(forKey: CurrentOrderDetail.store_owner) as? String
        let store_name = aDecoder.decodeObject(forKey: CurrentOrderDetail.store_name) as? String
        let store_distance = aDecoder.decodeObject(forKey: CurrentOrderDetail.store_distance) as? String
        
        let delivery_distance = aDecoder.decodeObject(forKey: CurrentOrderDetail.delivery_distance) as? String
        let store_time = aDecoder.decodeObject(forKey: CurrentOrderDetail.store_time) as? String
        let delivery_time = aDecoder.decodeObject(forKey: CurrentOrderDetail.delivery_time) as? String
        
        
        let store_image = aDecoder.decodeObject(forKey: CurrentOrderDetail.store_image) as? String
        let store_image_url = aDecoder.decodeObject(forKey: CurrentOrderDetail.store_image_url) as? String
        let user_image = aDecoder.decodeObject(forKey: CurrentOrderDetail.user_image) as? String
        let user_image_url = aDecoder.decodeObject(forKey: CurrentOrderDetail.user_image_url) as? String

        self.init( id: id!, order_code : order_code!,user_id : user_id!,driver_id : driver_id!,store_id : store_id!,order_date : order_date!,final_total : final_total!,status :status!, delivery_name : delivery_name!,delivery_phone : delivery_phone!,delivery_address : delivery_address!,delivery_latitude : delivery_latitude!,delivery_longitude : delivery_longitude!,driver_name : driver_name!,car_number : car_number!,car_brand : car_brand!,mobile : mobile!, driver_latitude : driver_latitude!, driver_longitude : driver_longitude!,driver_address : driver_address!, store_latitude : store_latitude!,  store_longitude : store_longitude!, store_address : store_address!,   store_owner : store_owner!, store_name : store_name!, store_distance : store_distance!,  delivery_distance : delivery_distance!,  store_time : store_time!,  delivery_time : delivery_time!,  user_image : user_image!,  user_image_url : user_image_url!,  store_image_url : store_image_url!,  store_image : store_image!)
    }
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(id, forKey: CurrentOrderDetail.id)
        aCoder.encode(order_code, forKey: CurrentOrderDetail.order_code)
        aCoder.encode(user_id, forKey: CurrentOrderDetail.user_id)
        aCoder.encode(driver_id, forKey: CurrentOrderDetail.driver_id)
        aCoder.encode(store_id, forKey: CurrentOrderDetail.store_id)
        aCoder.encode(order_date, forKey: CurrentOrderDetail.order_date)
        aCoder.encode(final_total, forKey: CurrentOrderDetail.final_total)
        aCoder.encode(status, forKey: CurrentOrderDetail.status)
        aCoder.encode(delivery_name, forKey: CurrentOrderDetail.delivery_name)
        aCoder.encode(delivery_phone, forKey: CurrentOrderDetail.delivery_phone)
        aCoder.encode(delivery_address, forKey: CurrentOrderDetail.delivery_address)
        aCoder.encode(delivery_latitude, forKey: CurrentOrderDetail.delivery_latitude)
        aCoder.encode(delivery_longitude, forKey: CurrentOrderDetail.delivery_longitude)
        aCoder.encode(driver_name, forKey: CurrentOrderDetail.driver_name)
        aCoder.encode(car_number, forKey: CurrentOrderDetail.car_number)
        aCoder.encode(car_brand, forKey: CurrentOrderDetail.car_brand)
        aCoder.encode(mobile, forKey: CurrentOrderDetail.mobile)
        aCoder.encode(driver_latitude, forKey: CurrentOrderDetail.driver_latitude)
        aCoder.encode(driver_longitude, forKey: CurrentOrderDetail.driver_longitude)
        aCoder.encode(driver_address, forKey: CurrentOrderDetail.driver_address)
        aCoder.encode(store_latitude, forKey: CurrentOrderDetail.store_latitude)
        aCoder.encode(store_longitude, forKey: CurrentOrderDetail.store_longitude)
        aCoder.encode(store_address, forKey: CurrentOrderDetail.store_address)
        aCoder.encode(store_owner, forKey: CurrentOrderDetail.store_owner)
        aCoder.encode(store_name, forKey: CurrentOrderDetail.store_name)
        aCoder.encode(store_distance, forKey: CurrentOrderDetail.store_distance)
        aCoder.encode(delivery_distance, forKey: CurrentOrderDetail.delivery_distance)
        aCoder.encode(store_time, forKey: CurrentOrderDetail.store_time)
        aCoder.encode(delivery_time, forKey: CurrentOrderDetail.delivery_time)
        aCoder.encode(store_image, forKey: CurrentOrderDetail.store_image)
        aCoder.encode(store_image_url, forKey: CurrentOrderDetail.store_image_url)
        aCoder.encode(user_image, forKey: CurrentOrderDetail.user_image)
        aCoder.encode(user_image_url, forKey: CurrentOrderDetail.user_image_url)
    }
}

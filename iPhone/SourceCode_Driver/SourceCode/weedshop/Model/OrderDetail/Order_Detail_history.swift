//
//  OrderSummary.swift
//  weedshop
//
//  Created by Devubha Manek on 04/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//


import UIKit

class Order_Detail_history: NSObject
{
    
    
    var id: String = ""
    var order_code: String = ""
    var user_id: String = ""
    var driver_id: String = ""
    var store_id: String = ""
    var address_id: String = ""
    var delivery_name: String = ""
    var delivery_phone: String = ""
    var delivery_address: String = ""
    var delivery_latitude: String = ""
    var delivery_longitude: String = ""
    var sub_total: String = ""
    var delivery_charge: String = ""
    var final_total: String = ""
    var order_date = Date()
    var status: String = ""
    var sent_request: String = ""
    var pickup: String = ""
    var collect_payment: String = ""
    var shop_name: String = ""
    var shop_owner: String = ""
    var shop_address: String = ""
    var shop_phone: String = ""
    var total_products: String = ""
    var products = [productHistoryDetail]()
    
    override init() {
        order_date =  Date()
    }
    init(id: String, order_code: String, user_id: String, driver_id: String, store_id: String, address_id: String, delivery_name: String, delivery_phone: String, delivery_address: String, delivery_latitude: String, delivery_longitude: String, sub_total: String, delivery_charge: String, final_total: String, order_date: Date, status: String, sent_request: String, pickup: String, collect_payment: String,shop_name: String,shop_owner: String,shop_address: String,shop_phone: String, total_products: String, products: [productHistoryDetail])
    {
        
        self.id = id
        self.order_code = order_code
        self.user_id = user_id
        self.driver_id = driver_id
        self.store_id = store_id
        self.address_id = address_id
        self.delivery_name = delivery_name
        self.delivery_phone = delivery_phone
        self.delivery_address = delivery_address
        self.delivery_latitude = delivery_latitude
        self.delivery_longitude =  delivery_longitude
        self.sub_total = sub_total
        self.delivery_charge = delivery_charge
        self.final_total = final_total
        self.order_date =  order_date
        self.status = status
        self.sent_request = sent_request
        self.pickup = pickup
        self.collect_payment = collect_payment
        self.shop_name = shop_name
        self.shop_owner = shop_owner
        self.shop_address = shop_address
        self.shop_phone = shop_phone
        self.total_products =  total_products
        self.products = products
        
    }
    
    
}

//
//  OrderHistory.swift
//  weedshop
//
//  Created by Devubha Manek on 31/03/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class OrderHistory: NSObject
{
    
    var id: String = ""
    var order_code: String = ""
    var user_id: String = ""
    var driver_id: String = ""
    var store_id: String = ""
    var final_total: String = ""
    var order_date =  Date()
    var status: String = ""
    var store_name: String = ""
    var store_image: String = ""
    var user_name: String = ""
    var user_image: String = ""
    
    var user_image_url: String = ""
    var store_image_url: String = ""
    var Product_history1 = [Product_history]()
    var total_time: String = ""
    override init() {
        order_date =  Date()
    }
    
    init(id: String, order_code: String, user_id: String, driver_id: String, store_id: String, final_total: String, order_date: Date, status: String, store_name: String, store_image: String, user_name: String, user_image: String, user_image_url: String, store_image_url: String, Product_history: [Product_history],total_time: String)
    {
        self.id = id
        self.order_code = order_code
        self.user_id = user_id
        self.driver_id = driver_id
        self.store_id = store_id
        self.final_total = final_total
        self.order_date = order_date
        self.status = status
        self.store_name = store_name
        self.store_image = store_image
        self.user_name = user_name
        self.user_image = user_image
        self.user_image_url = user_image_url
        self.store_image_url = store_image_url
        self.Product_history1 = Product_history
        self.total_time = total_time
    }

}


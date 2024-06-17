//
//  Detail.swift
//  weedshop
//
//  Created by Devubha Manek on 04/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class productHistoryDetail: NSObject
{
    
    
    var order_id: String = ""
    var product_id: String = ""
    var product_name: String = ""
    var price: String = ""
    var quantity: String = ""
    var attribute_description: String = ""
    var image: String = ""
    var image_url: String = ""
    var type: String = ""
    var color: String = ""


    
    init(order_id: String, product_id: String, product_name: String, price: String,  quantity: String, attribute_description: String, image: String, image_url: String, type: String, color: String)
    {
        self.order_id = order_id
        self.product_id = product_id
        self.product_name = product_name
        self.price = price
        self.quantity = quantity
        self.attribute_description = attribute_description
        self.image = image
        self.image_url = image_url
        self.type = type
        self.color = color
    }
    
   
}

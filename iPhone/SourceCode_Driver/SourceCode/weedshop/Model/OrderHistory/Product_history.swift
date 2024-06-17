//
//  OrderHistory.swift
//  weedshop
//
//  Created by Devubha Manek on 31/03/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class Product_history: NSObject
{
    var product_id: String = ""
    var product_name: String = ""
 
    init(product_id: String, product_name: String)
    {
        self.product_id = product_id
        self.product_name = product_name
    }

}


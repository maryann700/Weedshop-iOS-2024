//
//  Address.swift
//  weedshop
//
//  Created by Devubha Manek on 27/03/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit


class Address: NSObject, NSCoding
{
    var persionName: String = ""
    var Shop_name: String = ""
    var phonenumber: String = ""
    var address: String = ""
    var isSelected: Bool = false
    
    struct keyAddress
    {
        static let name = "name"
        static let Shop_name = "Shop_name"
        static let phoneNumber = "phoneNumber"
        static let address = "address"
        static let isSelected = "isSelected"
    }
    
    init(name: String,Shop_name:String, phoneNumber: String, address: String, isSelected: Bool)
    {
        self.persionName = name
        self.Shop_name = Shop_name
        self.phonenumber = phoneNumber
        self.address = address
        self.isSelected = isSelected
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(persionName, forKey: keyAddress.name)
        aCoder.encode(Shop_name, forKey: keyAddress.Shop_name)
        aCoder.encode(phonenumber, forKey: keyAddress.phoneNumber)
        aCoder.encode(address, forKey: keyAddress.address)
        aCoder.encode(isSelected, forKey: keyAddress.isSelected)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        
        let name = aDecoder.decodeObject(forKey: keyAddress.name) as! String
        let Shop_name = aDecoder.decodeObject(forKey: keyAddress.Shop_name) as! String
        let phonenumber = aDecoder.decodeObject(forKey: keyAddress.phoneNumber) as! String
        let address = aDecoder.decodeObject(forKey: keyAddress.address) as! String
        let isSelected = aDecoder.decodeObject(forKey: keyAddress.isSelected) as! Bool
        
        self.init(name: name ,Shop_name:Shop_name ,phoneNumber: phonenumber, address: address, isSelected: isSelected)
        
    }
}

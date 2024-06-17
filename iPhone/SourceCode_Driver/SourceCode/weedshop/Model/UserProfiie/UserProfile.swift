//
//  UserProfile.swift
//  weedshop
//
//  Created by Devubha Manek on 27/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit


class UserProfile: NSObject, NSCoding
{
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var birthdate: String = ""
    var image: String = ""
    var mobile: String = ""
    var address: String = ""
    var identification_id: String = ""
    var car_number: String = ""
    var car_brand: String = ""
    var image_url: String = ""
    
    
    struct KeyUserProfile
    {
        static let id = "id"
        static let name = "name"
        static let email = "email"
        static let birthdate = "birthdate"
        static let image = "image"
        static let mobile = "mobile"
        static let address = "address"
        static let identification_id = "identification_id"
        static let car_number = "car_number"
        static let car_brand = "car_brand"
        static let image_url = "image_url"
    }
    
    override init() {
        
    }
    
    init(id: String, name: String, email: String, birthdate: String, image: String, mobile: String, address: String, identification_id: String,  car_number: String,  car_brand: String,  image_url: String)
    {
        self.id = id
        self.name = name
        self.email = email
        self.birthdate = birthdate
        self.image = image
        self.mobile = mobile
        self.address = address
        self.identification_id = identification_id
        self.car_number = car_number
        self.car_brand = car_brand
        self.image_url = image_url
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(id, forKey: KeyUserProfile.id)
        aCoder.encode(name, forKey: KeyUserProfile.name)
        aCoder.encode(email, forKey: KeyUserProfile.email)
        aCoder.encode(birthdate, forKey: KeyUserProfile.birthdate)
        aCoder.encode(mobile, forKey: KeyUserProfile.mobile)
        aCoder.encode(image, forKey: KeyUserProfile.image)
        aCoder.encode(address, forKey: KeyUserProfile.address)
        aCoder.encode(identification_id, forKey: KeyUserProfile.identification_id)
        aCoder.encode(car_number, forKey: KeyUserProfile.car_number)
        aCoder.encode(car_brand, forKey: KeyUserProfile.car_brand)
        aCoder.encode(image_url, forKey: KeyUserProfile.image_url)
        
    }
    required convenience init?(coder aDecoder: NSCoder)
    {
        let id = aDecoder.decodeObject(forKey: KeyUserProfile.id) as? String
        let name = aDecoder.decodeObject(forKey: KeyUserProfile.name) as? String
        let email = aDecoder.decodeObject(forKey: KeyUserProfile.email) as? String
        let birthdate = aDecoder.decodeObject(forKey: KeyUserProfile.birthdate) as? String
        let image = aDecoder.decodeObject(forKey: KeyUserProfile.image) as? String
        let mobile = aDecoder.decodeObject(forKey: KeyUserProfile.mobile) as? String
        let address = aDecoder.decodeObject(forKey: KeyUserProfile.address) as? String
        let identification_id = aDecoder.decodeObject(forKey: KeyUserProfile.identification_id) as? String
        let car_number = aDecoder.decodeObject(forKey: KeyUserProfile.car_number) as? String
        let car_brand = aDecoder.decodeObject(forKey: KeyUserProfile.car_brand) as? String
        let image_url = aDecoder.decodeObject(forKey: KeyUserProfile.image_url) as? String
        
          self.init(id: id!, name: name!, email: email!, birthdate: birthdate!, image: image!, mobile: mobile!, address: address!, identification_id: identification_id!,  car_number: car_number!,  car_brand: car_brand!,  image_url: image_url!)
    }
}

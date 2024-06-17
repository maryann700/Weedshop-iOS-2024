//
//  UserInfo.swift
//  weedshop
//
//  Created by Devubha Manek on 06/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit


class driverInfo: NSObject, NSCoding
{
    var driver_id: String = ""
    var driver_name: String = ""
    var driver_email: String = ""
    var driver_password: String = ""
    var driver_zipcode: String = ""
    var driver_mobile: String = ""
    var driver_verification_code: String = ""
    var driver_identification_id: String = ""
    var driver_identification_photo: String = ""
    var driver_recommendation_photo: String = ""
    var driver_created_date: String = ""
    var driver_token: String = ""
    var driver_status: String = ""
    var driver_adminRejectReason: String = ""
    var driver_adminApproved: String = ""
    var driver_address: String = ""
    var driver_birthdate: String = ""
    var driver_car_brand: String = ""
    var driver_car_document: String = ""
    var driver_car_number: String = ""
    var driver_image: String = ""
    var driver_verifymsg: String = ""
   
    struct KeyDriverInfo
    {
        static let DriverID = "id"
        static let name = "name"
        static let email = "email"
        static let password = "password"
        static let zipcode = "zipcode"
        static let mobile = "mobile"
        static let verification_code = "verification_code"
        static let identification_id = "identification_id"
        static let identification_photo = "identification_photo"
        static let created_date = "created_date"
        static let token = "token"
        static let status = "status"
        static let adminRejectReason = "adminRejectReason"
        static let adminApproved = "adminApproved"
        static let address = "address"
        static let birthdate = "birthdate"
        static let car_brand = "car_brand"
        static let car_document = "letcar_document"
        static let car_number = "car_number"
        static let image = "image"
        static let verifymsg = "verifymsg"
        
    }
    
    override init() {
        
    }
    
    init(id: String, name: String, email: String, password: String, zipcode: String, mobile: String, verification_code: String, identification_id: String, identification_photo: String, created_date: String, token: String, status: String, adminRejectReason: String, adminApproved: String, address: String, birthdate: String , car_brand: String   , car_document: String, car_number: String  , image: String, verifymsg: String
        )
    {
        self.driver_id = id
        self.driver_name = name
        self.driver_email = email
        self.driver_password = password
        self.driver_zipcode = zipcode
        self.driver_mobile = mobile
        self.driver_verification_code = verification_code
        self.driver_identification_id = identification_id
        self.driver_identification_photo = identification_photo
        self.driver_created_date = created_date
        self.driver_token = token
        self.driver_status = status
        self.driver_adminRejectReason = adminRejectReason
        self.driver_adminApproved = adminApproved
        self.driver_address = address
        self.driver_birthdate = birthdate
        self.driver_car_brand = car_brand
        self.driver_car_document = car_document
        self.driver_car_number = car_number
        self.driver_image = image
        self.driver_verifymsg = verifymsg
        
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(driver_id, forKey: KeyDriverInfo.DriverID)
        aCoder.encode(driver_name, forKey: KeyDriverInfo.name)
        aCoder.encode(driver_email, forKey: KeyDriverInfo.email)
        aCoder.encode(driver_password, forKey: KeyDriverInfo.password)
        aCoder.encode(driver_zipcode, forKey: KeyDriverInfo.zipcode)
        aCoder.encode(driver_mobile, forKey: KeyDriverInfo.mobile)
        aCoder.encode(driver_verification_code, forKey: KeyDriverInfo.verification_code)
        aCoder.encode(driver_identification_id, forKey: KeyDriverInfo.identification_id)
        aCoder.encode(driver_identification_photo, forKey: KeyDriverInfo.identification_photo)
        aCoder.encode(driver_created_date, forKey: KeyDriverInfo.created_date)
        aCoder.encode(driver_token, forKey: KeyDriverInfo.token)
        aCoder.encode(driver_status, forKey: KeyDriverInfo.status)
        aCoder.encode(driver_adminRejectReason, forKey: KeyDriverInfo.adminRejectReason)
        aCoder.encode(driver_adminApproved, forKey: KeyDriverInfo.adminApproved)
        aCoder.encode(driver_address, forKey: KeyDriverInfo.address)
        aCoder.encode(driver_birthdate, forKey: KeyDriverInfo.birthdate)
        aCoder.encode(driver_car_brand, forKey: KeyDriverInfo.car_brand)
        aCoder.encode(driver_car_document, forKey: KeyDriverInfo.car_document)
        aCoder.encode(driver_car_number, forKey: KeyDriverInfo.car_number)
        aCoder.encode(driver_image, forKey: KeyDriverInfo.image)
        aCoder.encode(driver_verifymsg, forKey: KeyDriverInfo.verifymsg)

    }
    
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let id = aDecoder.decodeObject(forKey: KeyDriverInfo.DriverID) as? String
        let name = aDecoder.decodeObject(forKey: KeyDriverInfo.name) as? String
        let email = aDecoder.decodeObject(forKey: KeyDriverInfo.email) as? String
        let password = aDecoder.decodeObject(forKey: KeyDriverInfo.password) as? String
        let zipcode = aDecoder.decodeObject(forKey: KeyDriverInfo.zipcode) as? String
        let mobile = aDecoder.decodeObject(forKey: KeyDriverInfo.mobile) as? String
        let verification_code = aDecoder.decodeObject(forKey: KeyDriverInfo.verification_code) as? String
        let identification_id = aDecoder.decodeObject(forKey: KeyDriverInfo.identification_id) as? String
        let identification_photo = aDecoder.decodeObject(forKey: KeyDriverInfo.identification_photo) as? String
        let created_date = aDecoder.decodeObject(forKey: KeyDriverInfo.created_date) as? String
        let token = aDecoder.decodeObject(forKey: KeyDriverInfo.token) as? String
        let status = aDecoder.decodeObject(forKey: KeyDriverInfo.status) as? String
        let adminRejectReason = aDecoder.decodeObject(forKey: KeyDriverInfo.adminRejectReason) as? String
        let adminApproved = aDecoder.decodeObject(forKey: KeyDriverInfo.adminApproved) as? String
        let address = aDecoder.decodeObject(forKey: KeyDriverInfo.address) as? String
        let birthdate = aDecoder.decodeObject(forKey: KeyDriverInfo.birthdate) as? String
        let car_brand = aDecoder.decodeObject(forKey: KeyDriverInfo.car_brand) as? String
        let car_document = aDecoder.decodeObject(forKey: KeyDriverInfo.car_document) as? String
        let car_number = aDecoder.decodeObject(forKey: KeyDriverInfo.car_number) as? String
        let image = aDecoder.decodeObject(forKey: KeyDriverInfo.image) as? String
        let verifymsg = aDecoder.decodeObject(forKey: KeyDriverInfo.verifymsg) as? String
      
        
        self.init(id: id!, name: name!, email: email!, password: password!, zipcode: zipcode!, mobile: mobile!, verification_code: verification_code!, identification_id: identification_id!, identification_photo: identification_photo!, created_date: created_date!, token: token!, status: status!, adminRejectReason: adminRejectReason!, adminApproved: adminApproved!, address: address!, birthdate: birthdate!, car_brand: car_brand!,car_document:car_document!,car_number: car_number!,image: image!,verifymsg: verifymsg!)
        
        
    }
}


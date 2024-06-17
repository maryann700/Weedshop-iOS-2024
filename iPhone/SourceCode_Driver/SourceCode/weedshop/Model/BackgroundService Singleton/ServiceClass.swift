//
//  ServiceClass.swift
//  weedshop
//
//  Created by Devubha Manek on 06/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import Alamofire


public class ServiceClass: NSObject
{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    
    static let sharedInstance : ServiceClass = {
        let instance = ServiceClass()
        return instance
    }()
    
    
    func getUserInfo(DriverID: String, withCompletionHandler:@escaping (_ result: driverInfo) -> Void)
    {
        let parameters: Parameters = ["driver_id": DriverID]
        
        Alamofire.request(WebURL.DriverInfo, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: {  (response) in
            
            print(response)
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "response") as! String
                    if success == "true"
                    {
                        if let dataDic:NSDictionary = JSON.object(forKey: "data") as? NSDictionary
                        {
                            let id: String = createString(value: dataDic.object(forKey: "id") as AnyObject)
                            let name: String =  createString(value: dataDic.object(forKey: "name") as AnyObject)
                            let email: String = createString(value: dataDic.object(forKey: "email") as AnyObject)
                            let mobile: String = createString(value: dataDic.object(forKey: "mobile") as AnyObject)
                            let zipcode: String = createString(value: dataDic.object(forKey: "zipcode") as AnyObject)
                            let password: String = createString(value: dataDic.object(forKey: "password") as AnyObject)
                            let identification_id: String = createString(value: dataDic.object(forKey: "identification_id") as AnyObject)
                            let identification_photo: String = createString(value: dataDic.object(forKey: "identification_photo") as AnyObject)
                            let created_date: String = createString(value: dataDic.object(forKey: "created_date") as AnyObject)
                            let status: String = createString(value: dataDic.object(forKey: "status") as AnyObject)
                            let token: String = createString(value: dataDic.object(forKey: "token") as AnyObject)
                            let verification_code: String = createString(value: dataDic.object(forKey: "verification_code") as AnyObject)
                            let adminRejectReason: String = createString(value: dataDic.object(forKey: "adminRejectReason") as AnyObject)
                            let adminApproved: String = createString(value: dataDic.object(forKey: "adminApproved") as AnyObject)
                            let address: String = createString(value: dataDic.object(forKey: "address") as AnyObject)
                            let birthdate: String = createString(value: dataDic.object(forKey: "birthdate") as AnyObject)
                            let car_brand : String = createString(value: dataDic.object(forKey: "car_brand") as AnyObject)
                            let car_document: String = createString(value: dataDic.object(forKey: "car_document") as AnyObject)
                            let car_number : String = createString(value: dataDic.object(forKey: "car_number") as AnyObject)
                            let image : String = createString(value: dataDic.object(forKey: "image") as AnyObject)
                            let verifymsg : String = createString(value: dataDic.object(forKey: "verifymsg") as AnyObject)
                            
                            let info = driverInfo.init(id: id, name: name, email: email, password: password, zipcode: zipcode, mobile: mobile, verification_code: verification_code, identification_id: identification_id, identification_photo: identification_photo, created_date: created_date, token: token, status: status, adminRejectReason: adminRejectReason, adminApproved: adminApproved, address: address, birthdate: birthdate , car_brand: car_brand   , car_document: car_document, car_number: car_number  , image: image, verifymsg: verifymsg)
                            
                            withCompletionHandler(info)
                        }
                    }
                }
                
                break
            case .failure(let error):
                print(error)
                
                break
            }
            
            
        })
        
    }
    
    //MARK: - Device Token
    func userDeviceTokenUpdate(userID: String, token: String, uniqueid: String, withCompletionHandler:@escaping (_ result: Bool, _ message: String) -> Void)
    {
        let parameters: Parameters = ["driver_id": userID, "token": token, "uniqueid": uniqueid, "device_type": "ios"]
        
        Alamofire.request(WebURL.deviceTokenUpdate, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: {  (response) in
            
            print(response)
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "response") as! String
                    if success == "true"
                    {
                        withCompletionHandler(true, (JSON.object(forKey: "msg") as? String)!)
                    }
                    else
                    {
                        withCompletionHandler(false, (JSON.object(forKey: "msg") as? String)!)
                    }
                }
                else
                {
                    withCompletionHandler(false, "No Data Found")
                }
                break
            case .failure(let error):
                print(error)
                withCompletionHandler(false, error.localizedDescription)
                break
            }
        })
    }
    
    //MARK: - Logout Service
    func userLogout(userID: String, token: String, withCompletionHandler:@escaping (_ result: Bool, _ message: String) -> Void)
    {
        let parameters: Parameters = ["driver_id": userID, "token": token]
        
        Alamofire.request(WebURL.logout, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: {  (response) in
            
            print(response)
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "response") as! String
                    if success == "true"
                    {
                        withCompletionHandler(true, (JSON.object(forKey: "msg") as? String)!)
                    }
                    else
                    {
                        withCompletionHandler(false, (JSON.object(forKey: "msg") as? String)!)
                    }
                }
                else
                {
                    withCompletionHandler(false, "No Data Found")
                }
                break
            case .failure(let error):
                print(error)
                withCompletionHandler(false, error.localizedDescription)
                break
            }
        })
    }
    
    // Order Detail Service
    func getOrderDetail(DriverID: String, orderid: String, completionHandler:@escaping (_ result: Order_Detail_history, _ message: String) -> Void )
    {
        if (appDelegate.manager?.isReachable)! == false
        {
            let arrOrder = Order_Detail_history()
            completionHandler(arrOrder, "The network connection was lost.")
            return
        }
        
        var parameters = Parameters()
        parameters = ["driver_id": DriverID, "order_id": orderid]
        
        
        Alamofire.request(WebURL.driver_order_detail, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            
            print(response)
            let arrOrder = Order_Detail_history()
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "response") as! String
                    if success == "true"
                    {
                        
                        let data_arr  = creatArray(value: JSON.object(forKey: "data") as AnyObject)
                        
                        if let data:NSDictionary = data_arr.object(at: 0) as? NSDictionary
                        {
                            
                            let dateFormatter = DateFormatter()
                            let strDate = createString(value: (data as AnyObject).object(forKey: "order_date") as AnyObject)
                            
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                             dateFormatter.locale = Locale(identifier: NSLocale.current.identifier)
                            let orderdate = dateFormatter.date(from: strDate)!
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let strfinaldate = dateFormatter.string(from: orderdate)
                            let date1 = dateFormatter.date(from: strfinaldate)!
                            
                            let id = createString(value: (data as AnyObject).object(forKey: "id") as AnyObject)
                            let order_code = createString(value: (data as AnyObject).object(forKey: "order_code") as AnyObject)
                            let user_id = createString(value: (data as AnyObject).object(forKey: "user_id") as AnyObject)
                            let driver_id = createString(value: (data as AnyObject).object(forKey: "driver_id") as AnyObject)
                            let store_id = createString(value: (data as AnyObject).object(forKey: "store_id") as AnyObject)
                            let address_id = createString(value: (data as AnyObject).object(forKey: "address_id") as AnyObject)
                            let delivery_name = createString(value: (data as AnyObject).object(forKey: "delivery_name") as AnyObject)
                            let delivery_phone = createString(value: (data as AnyObject).object(forKey: "delivery_phone") as AnyObject)
                            let delivery_address = createString(value: (data as AnyObject).object(forKey: "delivery_address") as AnyObject)
                            let delivery_latitude = createString(value: (data as AnyObject).object(forKey: "delivery_latitude") as AnyObject)
                            let delivery_longitude = createString(value: (data as AnyObject).object(forKey: "delivery_longitude") as AnyObject)
                            let sub_total = createFloatToString(value: (data as AnyObject).object(forKey: "sub_total") as AnyObject)
                            let delivery_charge = createFloatToString(value: (data as AnyObject).object(forKey: "delivery_charge") as AnyObject)
                            let final_total = createFloatToString(value: (data as AnyObject).object(forKey: "final_total") as AnyObject)
                            let order_date = date1
                            let status = createString(value: (data as AnyObject).object(forKey: "status") as AnyObject)
                            let sent_request = createString(value: (data as AnyObject).object(forKey: "sent_request") as AnyObject)
                            let pickup = createString(value: (data as AnyObject).object(forKey: "pickup") as AnyObject)
                            let collect_payment = createFloatToString(value: (data as AnyObject).object(forKey: "collect_payment") as AnyObject)
                            let shop_name = createFloatToString(value: (data as AnyObject).object(forKey: "shop_name") as AnyObject)
                            let shop_owner = createFloatToString(value: (data as AnyObject).object(forKey: "shop_owner") as AnyObject)
                            let shop_address = createFloatToString(value: (data as AnyObject).object(forKey: "shop_address") as AnyObject)
                            let shop_phone = createFloatToString(value: (data as AnyObject).object(forKey: "shop_phone") as AnyObject)
                            
                            let total_products = createString(value: (data as AnyObject).object(forKey: "total_products") as AnyObject)
                            let products = creatArray(value: (data as AnyObject).object(forKey: "products") as AnyObject)
                            var productsData = [productHistoryDetail]()
                            
                            if products.count > 0
                            {
                                for item in products
                                {
                                    let order_id1 = createString(value: (item as AnyObject).object(forKey: "order_id") as AnyObject)
                                    let product_id = createString(value: (item as AnyObject).object(forKey: "product_id") as AnyObject)
                                    let product_name = createString(value: (item as AnyObject).object(forKey: "product_name") as AnyObject)
                                    
                                    let price = createFloatToString(value: (item as AnyObject).object(forKey: "price") as AnyObject)
                                    let quantity = createString(value: (item as AnyObject).object(forKey: "quantity") as AnyObject)
                                    let attribute_description = createString(value: (item as AnyObject).object(forKey: "attribute_description") as AnyObject)
                                    let image = createString(value: (item as AnyObject).object(forKey: "image") as AnyObject)
                                    let image_url = createString(value: (item as AnyObject).object(forKey: "image_url") as AnyObject)
                                    let type = createString(value: (item as AnyObject).object(forKey: "type") as AnyObject)
                                    let color = createString(value: (item as AnyObject).object(forKey: "color") as AnyObject)
                                    
                                    let product11 = productHistoryDetail.init(order_id: order_id1,product_id: product_id, product_name: product_name,price: price,quantity: quantity,attribute_description: attribute_description,image: image,image_url:image_url,type: type,color: color)
                                    
                                    productsData.append(product11)
                                }
                            }
                            
                            let newOrder1 = Order_Detail_history.init(id: id, order_code: order_code, user_id: user_id, driver_id: driver_id, store_id: store_id, address_id: address_id, delivery_name: delivery_name, delivery_phone: delivery_phone, delivery_address: delivery_address, delivery_latitude: delivery_latitude,delivery_longitude:delivery_longitude, sub_total: sub_total, delivery_charge: delivery_charge, final_total: final_total, order_date: order_date, status: status, sent_request: sent_request, pickup: pickup, collect_payment: collect_payment,shop_name: shop_name,shop_owner: shop_owner,shop_address: shop_address,shop_phone: shop_phone, total_products: total_products, products: productsData)
                            
                            completionHandler(newOrder1, "")
                        }
                    }
                    else
                    {
                        completionHandler(arrOrder, (JSON.object(forKey: "msg") as? String)!)
                    }
                }
                else
                {
                    completionHandler(arrOrder, "No Data Found")
                }
                break
            case .failure(let error):
                print(error)
                completionHandler(arrOrder, error.localizedDescription)
                break
            }
        })
        
    }
    
    func HistoryServiceCall(page:NSString, completionHandler:@escaping (_ result: NSMutableArray, _ message: String) -> Void){
        
        
        
        if (appDelegate.manager?.isReachable)! == false
        {
            let arrOrder = NSMutableArray()
            completionHandler(arrOrder, "The network connection was lost.")
            return
        }
        
        
        var DriverID = ""
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            DriverID = UserDefaults.Main.string(forKey: .DriverID)
        }
        
        let parameters: Parameters = ["driver_id": DriverID,"page":page,]
        
        Alamofire.request(WebURL.driver_order_history, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            
            print(response)
            let arrOrder = NSMutableArray()
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "response") as! String
                    if success == "true"
                    {
                        
                        if let dataArr:NSArray = JSON.object(forKey: "data") as? NSArray
                        {
                            if dataArr.count > 0
                            {
                                for data in dataArr
                                {
                                    let dateFormatter = DateFormatter()
                                    
                                    let strDate = createString(value: (data as AnyObject).object(forKey: "order_date") as AnyObject)
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    dateFormatter.locale = Locale(identifier: NSLocale.current.identifier)
                                    let order_date1 = dateFormatter.date(from: strDate)!
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    let strfinaldate = dateFormatter.string(from: order_date1)
                                    let dates = dateFormatter.date(from: strfinaldate)!
                                    
                                    
                                    let id = createString(value: (data as AnyObject).object(forKey: "id") as AnyObject)
                                    let order_code = createString(value: (data as AnyObject).object(forKey: "order_code") as AnyObject)
                                    let user_id = createString(value: (data as AnyObject).object(forKey: "user_id") as AnyObject)
                                    let driver_id = createString(value: (data as AnyObject).object(forKey: "driver_id") as AnyObject)
                                    let store_id = createString(value: (data as AnyObject).object(forKey: "store_id") as AnyObject)
                                    let final_total = createFloatToString(value: (data as AnyObject).object(forKey: "final_total") as AnyObject)
                                    let order_date = dates
                                    let status = createString(value: (data as AnyObject).object(forKey: "status") as AnyObject)
                                    let store_name = createString(value: (data as AnyObject).object(forKey: "store_name") as AnyObject)
                                    let store_image = createString(value: (data as AnyObject).object(forKey: "store_image") as AnyObject)
                                    let user_name = createString(value: (data as AnyObject).object(forKey: "user_name") as AnyObject)
                                    let user_image = createString(value: (data as AnyObject).object(forKey: "user_image") as AnyObject)
                                    
                                    let user_image_url = createString(value: (data as AnyObject).object(forKey: "user_image_url") as AnyObject)
                                    let store_image_url = createString(value: (data as AnyObject).object(forKey: "store_image_url") as AnyObject)
                                    let total_time = createString(value: (data as AnyObject).object(forKey: "total_time") as AnyObject)
                                    
                                    let products = creatArray(value: (data as AnyObject).object(forKey: "products") as AnyObject)
                                    
                                    var productsData = [Product_history]()
                                    if products.count > 0
                                    {
                                        for item in products
                                        {
                                            let product_id = createString(value: (item as AnyObject).object(forKey: "product_id") as AnyObject)
                                            let product_name = createString(value: (item as AnyObject).object(forKey: "product_name") as AnyObject)
                                            
                                            let product = Product_history.init(product_id: product_id, product_name: product_name)
                                            productsData.append(product)
                                        }
                                    }
                                    
                                    
                                    let newOrder = OrderHistory.init(id: id, order_code: order_code, user_id: user_id, driver_id: driver_id, store_id: store_id, final_total: final_total, order_date: order_date, status: status, store_name: store_name, store_image: store_image, user_name: user_name, user_image: user_image, user_image_url: user_image_url, store_image_url: store_image_url, Product_history:productsData,total_time:total_time)
                                    arrOrder.add(newOrder)
                                }
                            }
                            completionHandler(arrOrder, "")
                        }
                    }
                    else
                    {
                        completionHandler(arrOrder, (JSON.object(forKey: "msg") as? String)!)
                    }
                }
                else
                {
                    completionHandler(arrOrder, "No Data Found")
                }
                break
            case .failure(let error):
                print(error)
                completionHandler(arrOrder, error.localizedDescription)
                break
            }
        })
        
    }
    
    //MARK: - Get Profile Detail
    func getUserProfile(userID: String, action: String, dicData: Parameters, completionHander:@escaping (_ result: UserProfile, _ message: String) -> Void)
    {
        if (appDelegate.manager?.isReachable)! == false
        {
            let profile = UserProfile()
            completionHander(profile, "The network connection was lost.")
            return
        }
        
        var parameters = Parameters()
        if action == "list"
        {
            parameters = ["driver_id": userID, "action": action]
        }
        else
        {
            parameters = dicData
        }
        Alamofire.request(WebURL.driver_profile, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            
            print(response)
            var profile = UserProfile()
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "response") as! String
                    if success == "true"
                    {
                        if let dataArr:NSArray = JSON.object(forKey: "data") as? NSArray
                        {
                            print(dataArr)
                            
                            if dataArr.count > 0
                            {
                                let dic = NSMutableDictionary.init(dictionary: dataArr.object(at: 0) as! [AnyHashable : Any])
                                
                                let id = createString(value: dic.object(forKey: "id") as AnyObject)
                                let name = createString(value: dic.object(forKey: "name") as AnyObject)
                                let email = createString(value: dic.object(forKey: "email") as AnyObject)
                                let birthdate = createString(value: dic.object(forKey: "birthdate") as AnyObject)
                                let image = createString(value: dic.object(forKey: "image") as AnyObject)
                                let mobile = createString(value: dic.object(forKey: "mobile") as AnyObject)
                                let address = createString(value: dic.object(forKey: "address") as AnyObject)
                                let identification_id = createString(value: dic.object(forKey: "identification_id") as AnyObject)
                                let car_number = createString(value: dic.object(forKey: "car_number") as AnyObject)
                                let car_brand = createString(value: dic.object(forKey: "car_brand") as AnyObject)
                                let image_url = createString(value: dic.object(forKey: "image_url") as AnyObject)
                                
                                profile = UserProfile.init(id: id, name: name, email: email, birthdate: birthdate, image: image, mobile: mobile, address: address, identification_id: identification_id,car_number:car_number,car_brand:car_brand, image_url: image_url)
                            }
                        }
                        completionHander(profile, "")
                    }
                    else
                    {
                        completionHander(profile, (JSON.object(forKey: "msg") as? String)!)
                    }
                }
                else
                {
                    completionHander(profile, "No Data Found")
                }
                break
            case .failure(let error):
                print(error)
                completionHander(profile, error.localizedDescription)
                break
            }
        })
    }
    
    //MARK: - Get App Review Status
    func checkAppReviewStatus() -> Void
    {
        if (appDelegate.manager?.isReachable)! == false
        {
            return
        }
        Alamofire.request(WebURL.appInReview, method: .get, parameters: nil, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            
            print(response)
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "response") as! String
                    if success == "true"
                    {
                        if let dataDic:NSDictionary = JSON.object(forKey: "data") as? NSDictionary
                        {
                            UserDefaults.Main.set(createString(value: dataDic.object(forKey: "current_driver_version") as AnyObject), forKey: .currentReviewVersion)
                            UserDefaults.standard.synchronize()
                        }
                    }
                    else
                    {
                        self.checkAppReviewStatus()
                    }
                }
                else
                {
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        })
        
    }
}
extension ServiceClass{
    //Call For location update every Time
    
    func callForLocationUpdate(lat:NSString,Long:NSString){
        
        
        
        var DriverID = ""
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            DriverID = UserDefaults.Main.string(forKey: .DriverID)
        }
        self.callFor_address_Update(lat: lat, Long: Long)
        let parameters: Parameters = ["driver_id": DriverID,"latitude":lat,"longitude":Long]
        Alamofire.request(WebURL.update_driver_location, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            print(response)
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "response") as! String
                    if success == "true"
                    {
                        if let dict:NSDictionary = JSON.object(forKey: "data") as? NSDictionary
                        {
                            
                        }
                        else
                        {
                        }
                    }
                    else
                    {
                        
                    }
                }
                else
                {
                    
                }
                break
            case .failure(let error):
                print(error)
                
                
                
            }
        })
        
    }
    
}


extension ServiceClass{
    //Call For location update every Time
    
    func callFor_address_Update(lat:NSString,Long:NSString){
        let url = "http://maps.googleapis.com/maps/api/geocode/json?sensor=true&latlng="+"\(lat)"+","+"\(Long)"
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, headers: nil).responseJSON(completionHandler: { (response) in
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let arr_add = creatArray(value: JSON.object(forKey: "results") as AnyObject)
                    
                    if arr_add.count > 0{
                        let dict = creatDictnory(value:arr_add[0] as AnyObject)
                        let str_add = dict.value(forKey:"formatted_address")
                        NotificationCenter.default.post(name: Notification.Name("LocationUpdate"), object: nil,userInfo: ["address":str_add ?? ""])
                    }
                }
                else
                {
                }
                break
            case .failure(let error):
                print(error)
            }
        })
        
    }
    
}

//
//  BackGroundServices.swift
//  weedshop
//
//  Created by Devubha Manek on 12/05/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import  Alamofire


protocol ProductNotifyDelegate: class {
    
    func ProductNotifyToDriversWithData(sender: Product_notify)
    func ProductAccept()
    func Productdecline()
    func failmessageForAlert(msg: String)
    func Is_accept_success()
    func Current_order_of_driver(sender: CurrentOrderDetail)
    func FailCurrentOrder(msg: String)
    func conformForAlert(msg: String)
    
}





class BackGroundServices: NSObject {
    
    let appDelegate1 = UIApplication.shared.delegate as! AppDelegate
    var productTimer:Timer!
    var product_info: Product_notify!
    weak var delegate:ProductNotifyDelegate?
    
    func StartTimer_ProductNotify(){
        self.CallForProdunctNotify()
        productTimer = Timer.scheduledTimer(timeInterval:30, target: self, selector: #selector(CallForProdunctNotify), userInfo: nil, repeats: true)
    }
    
    func StopTimer_ProductNotify()  {
        if productTimer != nil{
            productTimer.invalidate()
            productTimer = nil
        }
        
    }
    
}






extension BackGroundServices{
    //Call For product notify update every Time
    func CallForProdunctNotify(){
        
        var DriverID = ""
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            DriverID = UserDefaults.Main.string(forKey: .DriverID)
        }
        
        let parameters: Parameters = ["driver_id": DriverID]
        
        Alamofire.request(WebURL.driver_get_order_request, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            print(response)
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "response") as! String
                    if success == "true"
                    {
                        if JSON.object(forKey: "data") != nil
                        {
                            
                            let arr  = creatArray(value: JSON.object(forKey: "data") as AnyObject)
                            if arr.count > 0{
                                
                                let dict_12 = arr[0] as! NSDictionary
                                self.StopTimer_ProductNotify()
                                 self.product_info =  Product_notify.init(
                                    
                                    delivery_address: createString(value: dict_12.value(forKey:"delivery_address" ) as AnyObject),
                                    delivery_distance: createFloatToString(value: dict_12.value(forKey:"delivery_distance")as AnyObject) ,
                                    delivery_latitude: createFloatToString(value:dict_12.value(forKey:"delivery_latitude") as AnyObject),
                                    delivery_longitude:createFloatToString(value:dict_12.value(forKey:"delivery_longitude") as AnyObject),
                                    delivery_time: createFloatToString(value:dict_12.value(forKey:"delivery_time") as AnyObject) ,
                                    driver_address: createString(value:dict_12.value(forKey:"driver_address")as AnyObject) ,
                                    driver_id: createString(value:dict_12.value(forKey:"driver_id") as AnyObject),
                                    driver_latitude: createFloatToString(value:dict_12.value(forKey:"driver_latitude") as AnyObject) ,
                                    driver_longitude: createFloatToString(value:dict_12.value(forKey:"driver_longitude") as AnyObject) ,
                                    final_total: createFloatToString(value:dict_12.value(forKey:"final_total") as AnyObject) ,
                                    id: createString(value:dict_12.value(forKey:"id") as AnyObject) ,
                                    order_code: createString(value:dict_12.value(forKey:"order_code") as AnyObject) ,
                                    order_date: createString(value:dict_12.value(forKey:"order_date") as AnyObject),
                                    request_timeout: createIntToString(value:dict_12.value(forKey:"request_timeout") as AnyObject) ,
                                    status: createString(value:dict_12.value(forKey:"status") as AnyObject) ,
                                    store_id: createString(value:dict_12.value(forKey:"store_id") as AnyObject) ,
                                    user_id: createString(value:dict_12.value(forKey:"user_id") as AnyObject) )
                                
                                
                                UserDefaults.Main.removeObj(forKey: .product_info_notify)
                                self.StopTimer_ProductNotify()
                                
//                                let product_info_notify = NSKeyedArchiver.archivedData(withRootObject: product_info_notify)
//                                UserDefaults.Main.set(Current_OrderDetail, forKey: .product_info_notify)
                                
                                
                                if (self.product_info.status == "Pending"){
                                  self.delegate?.ProductNotifyToDriversWithData(sender: self.product_info)
                                }else{
                                    let product_info1 = NSKeyedArchiver.archivedData(withRootObject: self.product_info)
                                    UserDefaults.Main.set(product_info1, forKey: .product_info_notify)
                                    self.driver_current_order_detail(order_id: self.product_info.id as NSString)
                                }
                            }
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

extension BackGroundServices{
    //Call For product action update every Time
    
    func produt_deliver_accept_decline(action:Bool,order_id:NSString){
        
        
        var string_action = ""
        if action {
            string_action = "accept"
            UserDefaults.Main.set(true, forKey: .isProductAccept)
        }else{
            string_action = "decline"
            UserDefaults.Main.set(false, forKey: .isProductAccept)
        }
        
        var DriverID = ""
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            DriverID = UserDefaults.Main.string(forKey: .DriverID)
        }
        
        let parameters: Parameters = ["driver_id": DriverID,"order_id":order_id,"action":string_action]
        Alamofire.request(WebURL.driver_request_action, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            print(response)
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "response") as! String
                    if success == "true"
                    {
                        if JSON.object(forKey: "data") != nil
                        {
                            let isProductAccept = UserDefaults.Main.bool(forKey: .isProductAccept)
                            
                            if  isProductAccept{
                                if self.product_info != nil {
                                    
                                    let product_info1 = NSKeyedArchiver.archivedData(withRootObject: self.product_info!)
                                    UserDefaults.Main.set(product_info1, forKey: .product_info_notify)
                                }

                                self.StopTimer_ProductNotify()
                                self.delegate?.ProductAccept()
                                self.delegate?.Is_accept_success()
                                
                        

                            }else{
                                self.StartTimer_ProductNotify()
                                self.delegate?.Productdecline()
                            }
                            UserDefaults.Main.removeObj(forKey: .isProductAccept)
                        }
                        else
                        {
                             UserDefaults.Main.removeObj(forKey: .product_info_notify)
                            let failMessage = JSON.object(forKey: "msg") as! String
                            self.delegate?.failmessageForAlert(msg:failMessage)
                        }
                    }
                    else
                    {
                         UserDefaults.Main.removeObj(forKey: .product_info_notify)
                        let failMessage = JSON.object(forKey: "msg") as! String
                        self.delegate?.failmessageForAlert(msg:failMessage)
                    }
                }
                else
                {
                     UserDefaults.Main.removeObj(forKey: .product_info_notify)
                    self.delegate?.failmessageForAlert(msg:"Network Isuue")
                }
                break
            case .failure(let error):
                 UserDefaults.Main.removeObj(forKey: .product_info_notify)
                self.delegate?.failmessageForAlert(msg:createString(value:error.localizedDescription as AnyObject))
            }
        })
        
    }
    
}

extension BackGroundServices{
    //Call For product action update every Time
    
    func driver_current_order_detail(order_id:NSString){
        
        let parameters: Parameters = ["order_id":order_id]
        Alamofire.request(WebURL.driver_current_order_detail, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            print(response)
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "response") as! String
                    if success == "true"
                    {
                        if JSON.object(forKey: "data") != nil
                        {
                            let arr  = creatArray(value: JSON.object(forKey: "data") as AnyObject)
                            if arr.count > 0{
                                
                                let dict_12 = arr[0] as! NSDictionary
                                
                                let odrer_detail =  CurrentOrderDetail.init(
                                    id: createString(value: dict_12.value(forKey:"id" ) as AnyObject),
                                    order_code: createString(value: dict_12.value(forKey:"order_code" ) as AnyObject),
                                    user_id: createString(value: dict_12.value(forKey:"user_id" ) as AnyObject),
                                    driver_id: createString(value: dict_12.value(forKey:"driver_id" ) as AnyObject),
                                    store_id: createString(value: dict_12.value(forKey:"store_id" ) as AnyObject),
                                    order_date: createString(value: dict_12.value(forKey:"order_date" ) as AnyObject),
                                    final_total: createFloatToString(value: dict_12.value(forKey:"final_total" ) as AnyObject),
                                    status: createString(value: dict_12.value(forKey:"status" ) as AnyObject),
                                    delivery_name: createString(value: dict_12.value(forKey:"delivery_name" ) as AnyObject),
                                    delivery_phone: createString(value: dict_12.value(forKey:"delivery_phone" ) as AnyObject),
                                    delivery_address: createString(value: dict_12.value(forKey:"delivery_address" ) as AnyObject),
                                    delivery_latitude: createFloatToString(value: dict_12.value(forKey:"delivery_latitude" ) as AnyObject),
                                    delivery_longitude: createFloatToString(value: dict_12.value(forKey:"delivery_longitude" ) as AnyObject),
                                    driver_name: createString(value: dict_12.value(forKey:"driver_name" ) as AnyObject),
                                    car_number: createString(value: dict_12.value(forKey:"car_number" ) as AnyObject),
                                    car_brand: createString(value: dict_12.value(forKey:"car_brand" ) as AnyObject),
                                    mobile: createString(value: dict_12.value(forKey:"mobile" ) as AnyObject),
                                    driver_latitude: createFloatToString(value: dict_12.value(forKey:"driver_latitude" ) as AnyObject) ,
                                    driver_longitude: createFloatToString(value: dict_12.value(forKey:"driver_longitude" ) as AnyObject) ,
                                    driver_address: createFloatToString(value: dict_12.value(forKey:"driver_address" ) as AnyObject) ,
                                    store_latitude: createFloatToString(value: dict_12.value(forKey:"store_latitude" ) as AnyObject) ,
                                    store_longitude: createFloatToString(value: dict_12.value(forKey:"store_longitude" ) as AnyObject) ,
                                    store_address: createString(value: dict_12.value(forKey:"store_address" ) as AnyObject) ,
                                    store_owner: createString(value: dict_12.value(forKey:"store_owner" ) as AnyObject) ,
                                    store_name: createString(value: dict_12.value(forKey:"store_name" ) as AnyObject) ,
                                    store_distance: createFloatToString(value: dict_12.value(forKey:"store_distance" ) as AnyObject) ,
                                    delivery_distance: createFloatToString(value: dict_12.value(forKey:"delivery_distance" ) as AnyObject) ,
                                    store_time: createString(value: dict_12.value(forKey:"store_time" ) as AnyObject) ,
                                    delivery_time: createString(value: dict_12.value(forKey:"delivery_time" ) as AnyObject),
                                    
                                    user_image: createString(value: dict_12.value(forKey:"user_image" ) as AnyObject),
                                    
                                    user_image_url: createString(value: dict_12.value(forKey:"user_image_url" ) as AnyObject),
                                    store_image_url: createString(value: dict_12.value(forKey:"store_image_url" ) as AnyObject),
                                    store_image: createString(value: dict_12.value(forKey:"store_image" ) as AnyObject)
                                )
                                
                                UserDefaults.Main.removeObj(forKey: .currentOrderInfo)
                                self.StopTimer_ProductNotify()
                                let Current_OrderDetail = NSKeyedArchiver.archivedData(withRootObject: odrer_detail)
                                UserDefaults.Main.set(Current_OrderDetail, forKey: .currentOrderInfo)
                                self.delegate?.Current_order_of_driver(sender: odrer_detail)
                            }
                        }
                        
                    }
                    else
                    {
                        
                       
                            
                        self.delegate?.FailCurrentOrder(msg:JSON.object(forKey: "msg") as! String)
                        UserDefaults.Main.removeObj(forKey: .product_info_notify)
                        UserDefaults.Main.removeObj(forKey: .currentOrderInfo)
//                        //delete
                        
//                        let current_Order_Info = UserDefaults.Main.object(forKey: .currentOrderInfo)
//                        if current_Order_Info != nil
//                        {
//                            let current_Order_Info: CurrentOrderDetail = NSKeyedUnarchiver.unarchiveObject(with: current_Order_Info as! Data) as! CurrentOrderDetail
//                            self.delegate?.Current_order_of_driver(sender: current_Order_Info)
//                            
//                        }else{
                        
                            //self.delegate?.Productdecline()
//
//                            print("currentOrderInfo remove here")
//                            
//                        }
                        
                    }
                }
                else
                {
                    
                }
                break
            case .failure(let error):
                print(error)
                 self.delegate?.failmessageForAlert(msg:createString(value:error.localizedDescription as AnyObject))
               
            }
        })
        
    }
    
}
extension BackGroundServices{
    //Call For product action update every Time
    
    //    func driver_order_action(action:NSString,withCompletionHandler:@escaping (_ result: String) -> Void){
    func driver_order_action(action:NSString){
        
        
        
        
        var DriverID = ""
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            DriverID = UserDefaults.Main.string(forKey: .DriverID)
        }
        var order_id = ""
        let product_info = UserDefaults.Main.object(forKey: .product_info_notify)
        if product_info != nil
        {
            let product_info: Product_notify = NSKeyedUnarchiver.unarchiveObject(with: product_info as! Data) as! Product_notify
            order_id = product_info.id
        }
        
        let parameters: Parameters = ["driver_id": DriverID,"order_id":order_id,"action":action]
        
        Alamofire.request(WebURL.driverOrderAction, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            print(response)
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "response") as! String
                    if success == "true"
                    {
                        if JSON.object(forKey: "msg") != nil{
                            var mssage = ""
                            mssage = JSON.object(forKey: "msg") as! String
                            if mssage == "Your request pickup order successfully!"{
                                self.delegate?.conformForAlert(msg:mssage)
                            }else if mssage == "Your request delivered order successfully!"{
                                self.delegate?.conformForAlert(msg:mssage)
                            }else{
                             self.delegate?.failmessageForAlert(msg:mssage)
                            }
                        }
                        
                    }
                   
                }
                break
            case .failure(let error):
                print(error)
                self.delegate?.failmessageForAlert(msg:createString(value:error.localizedDescription as AnyObject))
            }
        })
        
    }
    
}


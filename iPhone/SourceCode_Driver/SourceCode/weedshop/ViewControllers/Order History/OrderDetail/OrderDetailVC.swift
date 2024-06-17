//
//  OrderDetailVC.swift
//  weedshop
//
//  Created by Devubha Manek on 03/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import KRProgressHUD

// MARK:- =======================================================
// MARK: - Table Cell


class cellOrderHistory1: MTTableCell
{
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblTitleProduct: MTLabel!
    @IBOutlet var lblWeightProduct: MTLabel!
    @IBOutlet var viewType: UIView!
    @IBOutlet var lblType: MTLabel!
    @IBOutlet var lblPrice: MTLabel!
    @IBOutlet var lblMore: MTLabel!
    @IBOutlet var lineBottom: UIView!
    @IBOutlet var viewProductBg: UIView!
    @IBOutlet var btnMore: UIButton!
    @IBOutlet var lblQuantity: MTLabel!
    
    @IBOutlet var viewContainerSecond: UIView!
    @IBOutlet var viewContainer: UIView!
    var isCornerRadiousSet: Bool = true
}

// cell for Order Details Section
class cellOrderDetail: MTTableCell
{
    @IBOutlet var lblOrderDate: MTLabel!
    @IBOutlet var lblOrderNumber: MTLabel!
    @IBOutlet var lblOrderTotal: MTLabel!
    @IBOutlet var viewContainer: UIView!
    
}

// cell for Shipping Address Section
class cellShipping: MTTableCell
{
    @IBOutlet var lblName: MTLabel!
    @IBOutlet var lblPhoneNumber: MTLabel!
    @IBOutlet var lblAddress: MTLabel!
    @IBOutlet var viewContainer: UIView!
}
// cell for Shopping Address Section
class cellShopping: MTTableCell
{
    @IBOutlet var lblName: MTLabel!
    @IBOutlet var lblPhoneNumber: MTLabel!
    @IBOutlet var lblAddress: MTLabel!
    @IBOutlet var viewContainer: UIView!
}
// cell for Order Summary Section
class cellOrderSummary: MTTableCell
{
    @IBOutlet var lblItems: MTLabel!
    @IBOutlet var lblDeliveryCharge: MTLabel!
    @IBOutlet var lblOrderTotal: MTLabel!
    @IBOutlet var viewContainer: UIView!
}



// MARK:- =======================================================
// MARK: - UIViewController
class OrderDetailVC: MTViewController, UITableViewDataSource, UITableViewDelegate {

    
// MARK:- =======================================================
// MARK: - Outlets And Variables
    
    // Outlet
    @IBOutlet var tblOrderDetails: UITableView!
    @IBOutlet var lblCartCount: UILabel!
    
    //Variables
     let dateFormatter = DateFormatter()
     var arrOrderDetails = NSMutableArray()
     var isSliderOpne: Bool = false
     var orderID = String()
     var arrMainProduct = NSMutableArray()
     var appDelegate = AppDelegate()
    var currentReviewVersion: String = ""
    
// MARK:- =======================================================
// MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add NOtification For remove transparent view  on Slider Menu Close
        

        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tblOrderDetails.frame.size.width, height: 10))
        view.backgroundColor = .clear
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        self.tblOrderDetails.tableFooterView = view
        
        // Set Detail Model for Order Detail
        dateFormatter.dateFormat = "MMM dd yyyy"
        
        self.getOrderDetailData()
        self.currentReviewVersion = createString(value: UserDefaults.Main.string(forKey: .currentReviewVersion) as AnyObject)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
      //  lblCartCount.setNotificationCounter(counter: updateCartCount())
        isSliderOpne = false
        let hotspot = UserDefaults.Main.bool(forKey: .isHotSpotActive)
        if hotspot
        {
            UIApplication.shared.isStatusBarHidden = true
        }
        else
        {
            UIApplication.shared.isStatusBarHidden = false
        }

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        
        self.tblOrderDetails.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tblOrderDetails.reloadData()
    }

    
// MARK:- =======================================================
// MARK: - Service Methods
    
    func getOrderDetailData() -> Void
    {
        if (self.appDelegate.manager?.isReachable)! == false
        {
            self.alert(message: "The network connection was lost.")
            return
        }
        
        let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
        KRProgressHUD.show()

        var DriverID = ""
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            DriverID = UserDefaults.Main.string(forKey: .DriverID)
        }
        
        ServiceClass.sharedInstance.getOrderDetail(DriverID: DriverID, orderid: orderID) { (orderHistoryData, message) in
           
            KRProgressHUD.dismiss({ 
                if message.characters.count > 0
                {
                    self.alert(message: message)
                }
            })
            if orderHistoryData.id.characters.count > 0
            {
                let orderData = orderHistoryData
                
                let detail = OrderDetail.init(date: orderData.order_date, number: orderData.order_code, total: "$" + orderData.final_total + " (" + orderData.total_products + " Items)")
                let arrDetail = NSMutableArray.init(object: detail)
                
                
                // Set Address Model for Shipment Detail
                let address_deliver = Address.init(name: orderData.delivery_name,Shop_name: orderData.shop_name, phoneNumber: orderData.delivery_phone, address: orderData.delivery_address, isSelected: true)
                let arrAddress_delivery = NSMutableArray.init(object: address_deliver)
                
                
                // Set Address Model for Shopment Detail
                let address_shop = Address.init(name: orderData.shop_owner,Shop_name: orderData.shop_name, phoneNumber: orderData.shop_phone, address: orderData.shop_address, isSelected: true)
                
                let arrAddress_shop = NSMutableArray.init(object: address_shop)

                
                // Set Order Summary Model
                let summary = OrderSummary.init(item: orderData.total_products, number: orderData.delivery_charge, total: orderData.final_total)
                let arrSummary = NSMutableArray.init(object: summary)
                
                let productsData = orderData.products
                
                self.arrMainProduct = NSMutableArray.init()
                
                for i in 0...productsData.count - 1
                {
                    let dicData = NSMutableDictionary.init()
                    dicData.setValue(createString(value: productsData[i].product_name as AnyObject), forKey: "product_name")
                    dicData.setValue(createString(value: productsData[i].image_url as AnyObject), forKey: "image_url")
                    dicData.setValue(createString(value: productsData[i].image as AnyObject), forKey: "image")
                    dicData.setValue(createString(value: productsData[i].product_id as AnyObject), forKey: "product_id")
                    
                    let price = String(Float(productsData[i].quantity)! * Float(productsData[i].price)!)
                    dicData.setValue(createFloatToString(value: price as AnyObject), forKey: "price")
                    dicData.setValue(createString(value: productsData[i].quantity as AnyObject), forKey: "quantity")
                    
                    dicData.setValue(createString(value: productsData[i].attribute_description as AnyObject), forKey: "attribute_description")
                    dicData.setValue(createString(value: productsData[i].type as AnyObject), forKey: "type")
                    dicData.setValue(createString(value: productsData[i].color as AnyObject), forKey: "color")
                    
                    self.arrMainProduct.add(dicData)
                }
                
                let tmpProducts = NSMutableArray.init()
                
                if self.arrMainProduct.count >= 2
                {
                    for i in 0...1
                    {
                        tmpProducts.add(self.arrMainProduct[i])
                    }
                }
                else
                {
                    for i in 0...self.arrMainProduct.count - 1
                    {
                        tmpProducts.add(self.arrMainProduct[i])
                    }
                }
                
                self.arrOrderDetails.add(arrDetail)
                self.arrOrderDetails.add(tmpProducts)
                self.arrOrderDetails.add(arrAddress_delivery)
                self.arrOrderDetails.add(arrAddress_shop)
                self.arrOrderDetails.add(arrSummary)
                
                DispatchQueue.main.async {
                     self.tblOrderDetails.reloadData()// Depends if you were populating a collection view or table view
                }
               
            }
        }
       
    }

// MARK:- =======================================================
// MARK: - Action Methods
    
    // Remove Transparent View From self.view
    func setSliderClose()
    {
        isSliderOpne = false
        for view in self.view.subviews
        {
            if view.tag == 12325
            {
                view.removeFromSuperview()
            }
        }
    }
    
    func sliderClose(tap: UITapGestureRecognizer) -> Void
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: KVSideMenu.Notifications.toggleLeft), object: self)
        isSliderOpne = false
        for view in self.view.subviews
        {
            if view.tag == 12325
            {
                view.removeFromSuperview()
            }
        }
    }

   
    
    
    @IBAction func btnMenuTap(_ sender: Any)
    {
        (sender as AnyObject).layer.startAnimation(tintColor :UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0))
        NotificationCenter.default.post(name: Notification.Name(rawValue: KVSideMenu.Notifications.toggleLeft), object: self)
        
        if isSliderOpne
        {
            isSliderOpne = false
            for view in self.view.subviews
            {
                if view.tag == 12325
                {
                    view.removeFromSuperview()
                }
            }
        }
        else
        {
            isSliderOpne = true
            let transParentView = UIView.init(frame: CGRect.init(x: 0, y: 66.5 * DeviceScale.SCALE_Y, width: self.view.frame.size.width, height:  self.view.frame.size.height - (66.5 * DeviceScale.SCALE_Y)))
            transParentView.alpha = 0.3
            transParentView.backgroundColor = .black
            transParentView.tag = 12325;
            self.view.addSubview(transParentView)
            
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(sliderClose(tap:)))
            tapGesture.numberOfTapsRequired = 1
            transParentView.addGestureRecognizer(tapGesture)

        }
    }
    
    @IBAction func btnBackTap(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
   
    func btnMoreTap(_ sender: Any) -> Void
    {
        let tmpProducts = NSMutableArray.init()
        //tmpProducts = productsData
        
        if (arrOrderDetails[1] as AnyObject).count >= arrMainProduct.count
        {
            
            for i in 0...1
            {
                tmpProducts.add(arrMainProduct[i])
            }
            arrOrderDetails.replaceObject(at: 1, with: tmpProducts)
            
            let deletedIndexpath = NSMutableArray()
            for i in (2...arrMainProduct.count - 1).reversed()
            {
                let index = IndexPath.init(item: i, section: 1)
                deletedIndexpath.add(index)
            }

            self.tblOrderDetails.beginUpdates()
            self.tblOrderDetails.deleteRows(at: deletedIndexpath as! [IndexPath], with: UITableViewRowAnimation.automatic)
            self.tblOrderDetails.endUpdates()
            
            
            
            self.perform(#selector(OrderDetailVC.tableReload), with: self, afterDelay: 0.4)
            
        }
        else
        {
            for i in 0...arrMainProduct.count - 1
            {
                tmpProducts.add(arrMainProduct[i])
            }
            arrOrderDetails.replaceObject(at: 1, with: tmpProducts)
            
            let insertIndexpath = NSMutableArray()
            for i in 2...arrMainProduct.count - 1
            {
                let index = IndexPath.init(item: i, section: 1)
                insertIndexpath.add(index)
            }
            
            self.tblOrderDetails.beginUpdates()
            self.tblOrderDetails.insertRows(at: insertIndexpath as! [IndexPath], with: UITableViewRowAnimation.automatic)
            self.tblOrderDetails.endUpdates()
            
            self.perform(#selector(OrderDetailVC.tableReload), with: self, afterDelay: 0.2)
        }
        
        
    }
  
    func tableReload() -> Void
    {
        DispatchQueue.main.async {
            self.tblOrderDetails.reloadData()// Depends if you were populating a collection view or table view
        }
       
    }
    
// MARK:- =======================================================
// MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
       return arrOrderDetails.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrOrderDetails.count > 0
        {
            return (arrOrderDetails.object(at: section) as AnyObject).count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell.init()
        
        // Create Cell for OrderDetail
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOrderDetail", for: indexPath) as! cellOrderDetail
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            let orderDetail = (arrOrderDetails[indexPath.section] as AnyObject).object(at: 0) as! OrderDetail
           
            cell.viewContainer.layer.cornerRadius = 3.0
            cell.viewContainer.layer.borderColor = UIColor.init(red: 58.0 / 255.0, green: 66.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0).cgColor
            cell.viewContainer.layer.borderWidth = 1.0
            
            cell.lblOrderDate.text = dateFormatter.string(from: orderDetail.detail_date)
            cell.lblOrderNumber.text = orderDetail.detail_Number
            cell.lblOrderTotal.text = orderDetail.detail_Total
            
            cell.selectionStyle = .none
            return cell
        }
        // Create Cell for Shipping Detail
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOrderHistory1", for: indexPath) as! cellOrderHistory1
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            let shipmentDetail = arrOrderDetails[indexPath.section]
            
           cell.lineBottom.isHidden = true
           
            cell.viewContainer.layer.cornerRadius = 0.0
            cell.viewContainer.layer.mask = nil
            
            cell.btnMore.isHidden = true
            cell.btnMore.setTitle("More", for: .normal)
            if arrMainProduct.count > 2
            {
                if (arrOrderDetails[indexPath.section] as AnyObject).count > 2
                {
                    if indexPath.row == ((arrOrderDetails[indexPath.section] as AnyObject).count - 1)
                    {
                        cell.btnMore.isHidden = false
                        cell.btnMore.setTitle("Less", for: .normal)
                    }
                }
                else
                {
                    if indexPath.row == 1
                    {
                        cell.btnMore.isHidden = false
                    }
                }
            }
            cell.btnMore.addTarget(self, action: #selector(OrderDetailVC.btnMoreTap(_:)), for: .touchUpInside)
            
            if cell.isCornerRadiousSet == true
            {
                cell.isCornerRadiousSet = false
                
                cell.imgProduct.layer.cornerRadius = (cell.imgProduct.frame.height * DeviceScale.SCALE_Y) / 2
                cell.imgProduct.layer.borderWidth = 1.0
                cell.imgProduct.borderColor = UIColor.init(red: 243.0 / 255.0, green: 244.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
                cell.imgProduct.clipsToBounds = true
                
                cell.viewType.layer.cornerRadius = (cell.viewType.frame.height * DeviceScale.SCALE_X) / 2
                cell.viewType.backgroundColor = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
             
            }
            
            if (shipmentDetail as AnyObject).count == 1
            {
                cell.viewContainer.layer.cornerRadius = 3.0
                cell.viewContainer.layer.borderColor = UIColor.init(red: 58.0 / 255.0, green: 66.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0).cgColor
                cell.viewContainer.layer.borderWidth = 1.0
                cell.lineBottom.isHidden = true
            }
            else
            {
                cell.lineBottom.isHidden = true
                cell.viewContainer.layer.cornerRadius = 0.0

                
                cell.viewContainer.layer.addBorder(edge: .left, color: UIColor.init(red: 58.0 / 255.0, green: 66.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0), thickness: 1.0)
                cell.viewContainer.layer.addBorder(edge: .right, color: UIColor.init(red: 58.0 / 255.0, green: 66.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0), thickness: 1.0)
              
                if indexPath.row == 0
                {
                    cell.viewContainer.layer.addBorder(edge: .top, color: UIColor.init(red: 58.0 / 255.0, green: 66.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0), thickness: 1.0)
                    var frame = cell.viewContainer.frame
                    frame.origin.x = cell.viewContainerSecond.frame.origin.x
                    frame.origin.y = cell.viewContainerSecond.frame.origin.y
                    
                    let pathWithRadius = UIBezierPath(roundedRect:frame, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize.init(width: 3.0, height: 3.0))
                    let maskLayer = CAShapeLayer()
                    maskLayer.path = pathWithRadius.cgPath
                    cell.viewContainer.layer.mask = maskLayer
                    
                }
                else if indexPath.row == (shipmentDetail as AnyObject).count - 1
                {
                    cell.lineBottom.isHidden = true
                    cell.viewContainer.layer.mask = nil
                    if (arrOrderDetails[indexPath.section] as AnyObject).count <= 2
                    {
                         cell.viewContainer.layer.addBorder(edge: .top, color: UIColor.init(red: 58.0 / 255.0, green: 66.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0), thickness: 1.0)
                    }
                    cell.viewContainer.layer.addBorder(edge: .bottom, color: UIColor.init(red: 58.0 / 255.0, green: 66.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0), thickness: 1.0)
                    
                    if indexPath.row != 2
                    {
                        var frame = cell.viewContainer.frame
                        frame.origin.x = cell.viewContainerSecond.frame.origin.x
                        frame.origin.y = cell.viewContainerSecond.frame.origin.y
                        
                        let pathWithRadius = UIBezierPath(roundedRect:frame, byRoundingCorners:[.bottomRight, .bottomLeft], cornerRadii: CGSize.init(width: 4.0, height: 4.0))
                        let maskLayer = CAShapeLayer()
                        maskLayer.path = pathWithRadius.cgPath
                        cell.viewContainer.layer.mask = maskLayer
                    }
                }
                else
                {
                    cell.viewContainer.layer.addBorder(edge: .bottom, color: UIColor.init(red: 58.0 / 255.0, green: 66.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0), thickness: 1.0)

                    cell.viewContainer.layer.mask = nil
                    var frame = cell.viewContainer.frame
                    frame.origin.x = cell.viewContainerSecond.frame.origin.x
                    frame.origin.y = cell.viewContainerSecond.frame.origin.y
                    
                    let pathWithRadius = UIBezierPath(roundedRect:frame, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize.init(width: 3.0, height: 3.0))
                    let maskLayer = CAShapeLayer()
                    maskLayer.path = pathWithRadius.cgPath
                    cell.viewContainer.layer.mask = maskLayer
                }
            }
            
            if  (shipmentDetail as AnyObject).count > indexPath.row
            {
                let product = (arrOrderDetails[indexPath.section] as AnyObject).object(at: indexPath.row) as! NSDictionary
                
                if String(describing: product.object(forKey: "image")).characters.count > 0
                {
                    cell.imgProduct.sd_setImage(with: URL.init(string: product.object(forKey: "image_url") as! String), placeholderImage: UIImage.init(named: "High5_Logo"), options: .refreshCached)
                }
                else
                {
                    cell.imgProduct.image = UIImage.init(named: "High5_Logo")
                }
                cell.lblTitleProduct.text = createString(value: product.object(forKey: "product_name") as AnyObject)
                cell.lblWeightProduct.text = createString(value: product.object(forKey: "attribute_description") as AnyObject)
                cell.lblType.text =  createString(value: product.object(forKey: "type") as AnyObject)
                
                if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                    print(version)
                    
                    if currentReviewVersion == version{
                        cell.lblPrice.text = ""
                    }
                    else
                    {
                        cell.lblPrice.text = "$" +  createString(value: product.object(forKey: "price") as AnyObject)
                    }
                }
                else
                {
                     cell.lblPrice.text = ""
                }
                
                cell.lblQuantity.text = "Quantity : " + createString(value:  product.object(forKey: "quantity") as AnyObject)
                let color = self.hexStringToUIColor(hex: createString(value: product.object(forKey: "color") as AnyObject))
                cell.viewType.backgroundColor = color

            }
            tableView.separatorStyle = .none
            cell.selectionStyle = .none
            return cell
        }
        // Create Cell for Shipping Address
        else if indexPath.section == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellShipping", for: indexPath) as! cellShipping
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            cell.viewContainer.layer.cornerRadius = 3.0
            cell.viewContainer.layer.borderColor = UIColor.init(red: 58.0 / 255.0, green: 66.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0).cgColor
            cell.viewContainer.layer.borderWidth = 1.0
            
            let address = (arrOrderDetails[indexPath.section] as AnyObject).object(at: 0) as! Address
            
            cell.lblName.text = address.persionName

            cell.lblPhoneNumber.text = " +1" + address.phonenumber
            cell.lblAddress.text = address.address

            tableView.separatorStyle = .none
            cell.selectionStyle = .none
            return cell
        }
            // Create Cell for Shopping Address
        else if indexPath.section == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellShopping", for: indexPath) as! cellShopping
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            cell.viewContainer.layer.cornerRadius = 3.0
            cell.viewContainer.layer.borderColor = UIColor.init(red: 58.0 / 255.0, green: 66.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0).cgColor
            cell.viewContainer.layer.borderWidth = 1.0
            
            let address = (arrOrderDetails[indexPath.section] as AnyObject).object(at: 0) as! Address
            
            cell.lblName.text = address.persionName + " ("+"\(address.Shop_name)" + ")"
            cell.lblPhoneNumber.text = " +1" + address.phonenumber
            cell.lblAddress.text = address.address
            
            tableView.separatorStyle = .none
            cell.selectionStyle = .none
            return cell
        }
        // Create Cell for Order Summary
        else if indexPath.section == 4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOrderSummary", for: indexPath) as! cellOrderSummary
            cell.layoutIfNeeded()
            cell.layoutSubviews()
            cell.viewContainer.layer.cornerRadius = 3.0
            cell.viewContainer.layer.borderColor = UIColor.init(red: 58.0 / 255.0, green: 66.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0).cgColor
            cell.viewContainer.layer.borderWidth = 1.0
            let orderSummary = (arrOrderDetails[indexPath.section] as AnyObject).object(at: 0) as! OrderSummary
            
            cell.lblItems.text = "$" + String(Float(orderSummary.orderTotal)! - Float(orderSummary.delivaryCharge)!)
            cell.lblDeliveryCharge.text = "$" + orderSummary.delivaryCharge
            cell.lblOrderTotal.text = "$" + orderSummary.orderTotal
            cell.selectionStyle = .none
            return cell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let view = UIView.init(frame: CGRect.init(x: 20, y: 0, width: tableView.frame.size.width, height: 30))
            view.backgroundColor = UIColor.init(red: 39.0 / 255.0, green: 44.0 / 255.0, blue: 49.0 / 255.0, alpha: 1.0)
            
            let lblDate = UILabel.init(frame: CGRect.init(x: 17, y: 5, width: view.frame.size.width, height: view.frame.size.height))
            var str = ""
            if section == 0
            {
                str = "Order detail"
            }
            else if section == 1
            {
                str = "Shipment details"
            }
            else if section == 2
            {
                str = "Shipping address"
            }
            else if section == 3
            {
                str = "Shop address"
            }
            else if section == 4
            {
                str = "Order Summary"
            }
            lblDate.text = String.init(format: "%@", str)
            lblDate.textColor = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
            lblDate.font = UIFont.init(name: "Roboto-Bold", size: 10.0)
            lblDate.textAlignment = .left
            view.addSubview(lblDate)
            return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
    }
   

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 1
        {
            return 90 * DeviceScale.SCALE_Y
        }
        else if indexPath.section == 2
        {
            return UITableViewAutomaticDimension
        }
        else if indexPath.section == 3
        {
            return UITableViewAutomaticDimension
        }
        else if indexPath.section == 4
        {
            return 82 * DeviceScale.SCALE_Y
            
        }
        else
        {
           return 77 * DeviceScale.SCALE_Y
        }
        
        
    }

}

// MARK: Create Extenation for Layer Border
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge
        {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: thickness)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: self.frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
                break
            default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}

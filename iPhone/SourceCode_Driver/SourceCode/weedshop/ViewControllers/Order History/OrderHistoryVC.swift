//
//  OrderHistory.swift
//  weedshop
//
//  Created by Devubha Manek on 31/03/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import KRProgressHUD

// MARK:- =======================================================
// MARK: - SWTableViewCell
class cellOrderHistory: UITableViewCell
{
   
    @IBOutlet weak var ViewMAin: UIView!
    @IBOutlet weak var ShopImage: UIImageView!
    @IBOutlet weak var ShopName: MTLabel!
    
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: MTLabel!
    
    @IBOutlet weak var Productname: MTLabel!
    
    @IBOutlet weak var Price_lbl: MTLabel!
    @IBOutlet weak var Time_lbl: MTLabel!
}

//// MARK:- =======================================================
//// MARK: - Table Cell For Filter
//class cellFilteHistory: MTTableCell
//{
//    @IBOutlet var lblTitle: MTLabel!
//    @IBOutlet var imgSelectFilter: UIImageView!
//    @IBOutlet var lineBottom: UIView!
//    @IBOutlet var btnSelectFilter: UIButton!
//    var isCellRead: Bool = true
//}

class OrderHistoryVC: MTViewController,UITableViewDelegate,UITableViewDataSource
{
    
// MARK:- =======================================================
// MARK: - Outlets And Variables
    
    // Outlet
    @IBOutlet var tblOrderHistoryList: UITableView!
    @IBOutlet var lblTitle: MTLabel!
    @IBOutlet var lblCartCount: MTLabel!
  

    // Variables
    var orderLists = NSMutableArray()
    var allDataArray = NSMutableArray()
    var isSliderOpne: Bool = false
    var sortedDates = NSMutableArray()
    let dateFormatter = DateFormatter()
    var isFilterVisible: Bool = false
    var isFilterListVisible: Bool = false
    var pageNumber: Int = 1
    var totalPages: Int = 1
    var isNewDataLoading: Bool = false
    var filterText: String = ""
    var filterDate: String = ""
    var btnApplyTransition: TKTransitionSubmitButton!
    var varbtnApplyTransition: TKTransitionSubmitButton!
    var appDelegate = AppDelegate()
    var currentReviewVersion: String = ""
    
    // creat Array of Model Class
    var searchData = [Filter]()
   // var arrProductType = [ProductType]()
    var selectedFilter = Filter()
    
    
    // Constraints Variables
    var varconstTopviewFilterTransition = NSLayoutConstraint()
    
    // Constraints Outlet
    @IBOutlet var constTopviewFilterTransition: NSLayoutConstraint!
    
    
    var sortedArray:[Any] = []
// MARK:- =======================================================
// MARK: - UIViewController Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

//        NotificationCenter.default.addObserver(self, selector: #selector(ShopListVC.setSliderClose), name: NSNotification.Name(rawValue: "SliderRemove"), object: nil)

       // varconstTopviewFilterTransition.constant = constTopviewFilterTransition.constant
//        constTopviewFilterTransition.constant = constTopviewFilterTransition.constant - viewFilterTransition.frame.size.height
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        sortedDates = NSMutableArray.init()
        orderLists = NSMutableArray.init()

        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.getOrderStatus()
        
        self.currentReviewVersion = createString(value: UserDefaults.Main.string(forKey: .currentReviewVersion) as AnyObject)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        isSliderOpne = false
      //  lblCartCount.setNotificationCounter(counter: updateCartCount())
        
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tblOrderHistoryList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
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
    
 //MARK:- Comman Methods
   
    //Update Cart Counter Delegate Method
    func updateCartCounter() {
       // lblCartCount.setNotificationCounter(counter: updateCartCount())
    }
    
    // Set SignIn Button For Fluid Animation
    func setSingInButton()->Void
    {
//        btnApplyTransition = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.btnApply.frame.size.width * DeviceScale.SCALE_X, height: self.btnApply.frame.size.height * DeviceScale.SCALE_Y))
//        btnApplyTransition.center = self.btnApply.center
//        btnApplyTransition.addTarget(self, action: #selector(OrderHistoryVC.btnSearchTap(_:)), for: UIControlEvents.touchUpInside)
//        self.btnApply.addSubview(btnApplyTransition)
    }
 
// MARK:- Comman Methods
    // Sorting of Order Data According to Date
    func sortingByDate() -> Void
    {
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "order_date", ascending: false)
        let descriptors: NSArray = [descriptor]
        self.sortedArray = self.allDataArray.sortedArray(using: descriptors as! [NSSortDescriptor])
        NSLog("%@", self.sortedArray)
        
        for item in self.sortedArray
        {
            let order = item as! OrderHistory
            
            if !self.sortedDates.contains(order.order_date)
            {
                self.sortedDates.add(order.order_date)
            }
        }
        
        for item in self.sortedDates
        {
           
            
            let resultPredicate = NSPredicate(format: "order_date == %@", item as! CVarArg)
            let searchResults = self.sortedArray.filter { resultPredicate.evaluate(with: $0) }
            
            if searchResults.count > 0
            {
                let tempArray = NSMutableArray.init(array: searchResults)
                self.orderLists.add(tempArray)
            }
        }
        
        self.tblOrderHistoryList.reloadData()
    }
    
    // MARK:- =======================================================
    // MARK: - Service Methods
    
    func getOrderStatus() -> Void
    {
        if (self.appDelegate.manager?.isReachable)! == false
        {
            self.alert(message: "The network connection was lost.")
            return
        }
        
        let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
        KRProgressHUD.show()
        
        
        ServiceClass.sharedInstance.HistoryServiceCall(page: createString(value:pageNumber as AnyObject ) as NSString , completionHandler: { (OrderHistoryData, message) in
            KRProgressHUD.dismiss({
                if message.characters.count > 0
                {
                    self.alert(message: message)
                }
            })
            
            

            if OrderHistoryData.count > 0
            {
                self.isNewDataLoading = false
                self.allDataArray.addObjects(from: OrderHistoryData as! [Any])
                self.orderLists = NSMutableArray()
               // self.totalPages = Int(totalPage)!
                self.sortedDates = NSMutableArray.init()
                self.sortingByDate()
            }
            
        })
        
        
        
    }
    
    

    // MARK:- =======================================================
    // MARK: - ScrollView View Delegate
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == tblOrderHistoryList
        {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isNewDataLoading
                {
                    isNewDataLoading = true
                    
                    if pageNumber < self.totalPages
                    {
                        pageNumber = pageNumber + 1
                        self.getOrderStatus()
                    }
                }
            }
        }
    }
    

    
// MARK:- =======================================================
// MARK: - Action Methods
    
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
        
     //   self.setSearchData()
        
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
    @IBAction func btnBackTap(_ sender: Any)
    {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.HomeviewVC)
        
    }
    
  
   
    
  
    
// MARK:- =======================================================
// MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

         /*   let currentOrderData = ((orderLists.object(at: indexPath.section) as AnyObject).object(at: indexPath.row) as AnyObject) as! OrderHistory
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailVC") as! OrderDetailVC
            vc.orderID = currentOrderData.id
            self.navigationController?.pushViewController(vc, animated: true)
    */
       
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return orderLists.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if orderLists.count > 0 {
            return (self.orderLists.object(at: section) as AnyObject).count
        }else{
            return 0
        }
        
        
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOrderHistory", for: indexPath) as! cellOrderHistory
        
        
        cell.UserImage.layer.cornerRadius = (cell.UserImage.frame.height ) / 2
        cell.ShopImage.layer.cornerRadius = (cell.ShopImage.frame.height ) / 2
        
        cell.UserImage.clipsToBounds = true
        cell.ShopImage.clipsToBounds = true
        
        cell.ViewMAin.layer.cornerRadius = 4.0
        if orderLists.count > indexPath.section
        {
            let orderData = ((orderLists.object(at: indexPath.section) as AnyObject).object(at: indexPath.row) as AnyObject) as! OrderHistory
            
            let productArr = orderData.Product_history1
            
            if productArr.count > 0
            {
                let product = productArr[0]
                if (orderData.store_image.characters.count) > 0{
                    cell.ShopImage.sd_setImage(with: URL.init(string: orderData.store_image_url), placeholderImage: UIImage.init(named: "High5_Logo"), options: .refreshCached)
                }else{
                    cell.ShopImage.image = UIImage.init(named: "High5_Logo")
                }
                
                if (orderData.user_image.characters.count) > 0{
                        cell.UserImage.sd_setImage(with: URL.init(string: orderData.user_image_url), placeholderImage: UIImage.init(named: "userPlace"), options: .refreshCached)
                }else{
                    cell.UserImage.image = UIImage.init(named: "userPlace")
                }
                
                cell.ShopName.text = orderData.store_name
                cell.UserName.text = orderData.user_name
                cell.Productname.text = product.product_name
                
                if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                    print(version)
                    
                    if currentReviewVersion == version{
                        cell.Price_lbl.text = ""
                    }
                    else
                    {
                         cell.Price_lbl.text = "$"+orderData.final_total
                    }
                }
                else
                {
                    cell.Price_lbl.text = ""
                 }
                
                if (orderData.total_time != ""){
                    cell.Time_lbl.text = "Time: " + orderData.total_time
                }else{
                    cell.Time_lbl.text = "Time: " 
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == self.tblOrderHistoryList
        {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
            view.backgroundColor = UIColor.init(red: 39.0 / 255.0, green: 44.0 / 255.0, blue: 49.0 / 255.0, alpha: 1.0)
            
            let lblDate = UILabel.init(frame: CGRect.init(x: 0, y: 2, width: view.frame.size.width, height: view.frame.size.height))
            
            if sortedDates.count > 0{
                let str = dateFormatter.string(from: sortedDates.object(at: section) as! Date)
                
                 let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "yyyy-MM-dd"
                let date1 = dateFormatter1.date(from: str)!
                
               
                dateFormatter1.dateFormat = "MMMM dd yyyy"
                let strDate = dateFormatter1.string(from: date1)
                //let sendDate = dateFormatter.string(from: date1)
                
                lblDate.text = String.init(format: "Delivered on : %@", strDate)
                lblDate.textColor = UIColor.init(red: 158.0 / 255.0, green: 161.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0)
                lblDate.font = UIFont.init(name: "Roboto-Medium", size: 8.0)
                lblDate.textAlignment = .left
                view.addSubview(lblDate)
                return view
            }
            else
            {
                return nil
            }
            
        }
        else
        {
            return nil
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == self.tblOrderHistoryList
        {
            return 25
        }
        else
        {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == self.tblOrderHistoryList
        {
             return UITableViewAutomaticDimension
//            return 106 * DeviceScale.SCALE_Y
        }
        else
        {
            return CGFloat(DeviceScale.SCALE_Y * 26)
        }
        //
    }
    

    
    // MARK:- =======================================================
    //MARK: - Textfield Delegate Method
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        textField.inputAccessoryView = toolbarInit();
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return true
    }
    
    //MARK:- UITextField Toolbar and Methods
    
    func toolbarInit() -> UIToolbar
    {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40)
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.barTintColor = UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
        toolBar.tintColor = UIColor.white
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(resignKeyboard))
        doneButton.tintColor = UIColor.init(patternImage: UIImage.init(named: "imgBG")!)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        return toolBar;
    }
    func resignKeyboard()
    {
       
    }

}

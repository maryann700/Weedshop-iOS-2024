//
//  LeftSideMenu.swift
//  weedshop
//
//  Created by Devubha Manek on 23/02/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.


import Foundation
import Alamofire
import KRProgressHUD
import UserNotifications



class LeftCell: MTTableCell
{
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblTitle: MTLabel!
}

class LeftSideMenu: MTViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var leftTbl: UITableView!
    @IBOutlet var imgClose: UIImageView!
    @IBOutlet var btnImage: UIControl!
    @IBOutlet var imgProfilePic: UIImageView!
    var mainCategoryArry = NSMutableArray()
    
    @IBOutlet weak var carNumberLbl: MTLabel!
    @IBOutlet var lblName: MTLabel!
    var dicIndex:NSInteger?
    var dict = NSDictionary()
    
    // MARK: - ViewDidLoad Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width / 2
        self.imgProfilePic.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(LeftSideMenu.updateProfileImage), name: NSNotification.Name(rawValue: "ProfileImageUpdate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LeftSideMenu.NotifyProduct), name: NSNotification.Name(rawValue: "NotifyProduct"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(LeftSideMenu.showCurrentOrder(data:)), name: NSNotification.Name(rawValue: "showCurrentOrder"), object: nil)
        
        var home_lbl = ""
        let product_info = UserDefaults.Main.object(forKey: .product_info_notify)
        if product_info != nil
        {
            home_lbl = "Current order status"
        }else{
            home_lbl = "Your current location"
        }
        mainCategoryArry = [["titleName": "Profile", "imageName": "userIcon","SelectImageName": "userIcon.png"],["titleName": home_lbl, "imageName": "status","SelectImageName": "jpgR7.png"],["titleName": "Order history", "imageName": "order-history","SelectImageName": "jpgR7.png"]]
        
        leftTbl.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.updateProfileImage()
        self.getProfileData()
        
    }
    func NotifyProduct() {
        
        var home_lbl = ""
        let product_info = UserDefaults.Main.object(forKey: .product_info_notify)
        if product_info != nil
        {
            home_lbl = "Current order status"
        }else{
            home_lbl = "Your current location"
        }
        mainCategoryArry = [["titleName": "Profile", "imageName": "userIcon","SelectImageName": "userIcon.png"],["titleName": home_lbl, "imageName": "status","SelectImageName": "jpgR7.png"],["titleName": "Order history", "imageName": "order-history","SelectImageName": "jpgR7.png"]]
        
        leftTbl.reloadData()
    }
    
    // Method Call when get shop on Notification
    func showCurrentOrder(data: NSNotification) -> Void
    {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.HomeviewVC)
    }
    
    // MARK:- =======================================================
    // MARK: - Service Methods
    
    func getProfileData() -> Void
    {
        var DriverID = ""
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            DriverID = UserDefaults.Main.string(forKey: .DriverID)
        }
        self.activityIndicator.startAnimating()
        ServiceClass.sharedInstance.getUserProfile(userID: DriverID, action: "list", dicData: Parameters()) { (profileDta, message) in
            
            self.activityIndicator.stopAnimating()
            let tempProfileDta = NSKeyedArchiver.archivedData(withRootObject: profileDta)
            UserDefaults.Main.set(tempProfileDta, forKey: .userProfile)
            UserDefaults.standard.synchronize()
            self.carNumberLbl.text = "Car number: " + profileDta.car_number
            self.lblName.text = profileDta.name
            if profileDta.image.characters.count > 0
            {
                self.imgProfilePic.sd_setImage(with: URL.init(string: profileDta.image_url), placeholderImage: UIImage.init(named: "userSlider"), options: .refreshCached)
            }
            else
            {
                self.imgProfilePic.image = UIImage.init(named: "userSlider")
            }
        }
    }
    
    
    // Set Method for Update profile Data
    func updateProfileImage()
    {
        self.activityIndicator.startAnimating()
        if UserDefaults.Main.object(forKey: .userProfile) != nil
        {
            let date = UserDefaults.Main.object(forKey: .userProfile) as! Data
            let productData = NSKeyedUnarchiver.unarchiveObject(with: date)
            print(productData!)
            
            let profileData = productData.unsafelyUnwrapped as! UserProfile
            print(profileData)
            self.carNumberLbl.text = "Car number: " + profileData.car_number
            self.lblName.text = profileData.name
            if profileData.image.characters.count > 0
            {
                self.imgProfilePic.sd_setImage(with: URL.init(string: profileData.image_url), placeholderImage: UIImage.init(named: "userSlider"), options: .refreshCached)
            }
            else
            {
                self.imgProfilePic.image = UIImage.init(named: "userSlider")
            }
            self.activityIndicator.stopAnimating()
        }
    }
    // Method Call when Tap on Header of Cart's Shop Name
   
    
    @IBAction func btnCloseTap(_ sender: Any)
    {
        (sender as AnyObject).layer.startAnimation(tintColor :UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0))
        NotificationCenter.default.post(name: Notification.Name(rawValue: KVSideMenu.Notifications.toggleLeft), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SliderRemove"), object: self)
    }
    
    @IBAction func btnImageTap(_ sender: Any)
    {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.ProfileVC)
        NotificationCenter.default.post(name: Notification.Name(rawValue: KVSideMenu.Notifications.toggleLeft), object: self)
    }
    
    @IBAction func btnSettingTap(_ sender: Any) {
    }
    
    @IBAction func btnLogoutTap(_ sender: Any)
    {
        
        let alert = UIAlertController.init(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        let yes = UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            
            
            var userID = ""
            let id: String = UserDefaults.Main.string(forKey: .DriverID)
            if (id.characters.count > 0)
            {
                userID = createString(value: UserDefaults.Main.string(forKey: .DriverID) as AnyObject)
            }
            var deviceToken = ""
            let token: String = UserDefaults.Main.string(forKey: .DriverID)
            if (token.characters.count > 0)
            {
                deviceToken = createString(value: UserDefaults.Main.string(forKey: .deviceToken) as AnyObject)
            }
            
            let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
            KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
            KRProgressHUD.show()
            
            ServiceClass.sharedInstance.userLogout(userID: userID, token: deviceToken) { (success, message) in
                
                KRProgressHUD.dismiss({
                    
                    if #available(iOS 10.0, *) {
                        let center = UNUserNotificationCenter.current()
                        center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
                        center.removeAllDeliveredNotifications() // To remove all delivered notifications
                    } else {
                        UIApplication.shared.cancelAllLocalNotifications()
                    }
                    
                    UserDefaults.Main.removeObj(forKey: .isLogin)
                    UserDefaults.Main.removeObj(forKey: .isSignUp)
                    UserDefaults.Main.removeObj(forKey: .isEmailVerify)
                    UserDefaults.Main.removeObj(forKey: .isIdCardVerify)
                    UserDefaults.Main.removeObj(forKey: .DriverID)
                    UserDefaults.Main.removeObj(forKey: .driverInfo)
                    UserDefaults.Main.removeObj(forKey: .isCarVerify)
                    UserDefaults.Main.removeObj(forKey: .isAdminVerify)
                    
                    UserDefaults.Main.removeObj(forKey: .product_info_notify)
                    UserDefaults.Main.removeObj(forKey: .currentOrderInfo)
                    UserDefaults.Main.removeObj(forKey: .isOrder)
                    UserDefaults.standard.synchronize()
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    let navController = UINavigationController.init(rootViewController: vc)
                    navController.navigationBar.isHidden = true
                    navController.interactivePopGestureRecognizer?.isEnabled = false
                    UIApplication.shared.keyWindow?.rootViewController = navController
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()

                    
                })
                
            }
        })
        alert.addAction(yes)
        
        let cancel = UIAlertAction.init(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        })
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: {
            
        })

        
    }
    
    
    //MARK: - Tableview Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return mainCategoryArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftCell", for: indexPath) as! LeftCell
        
        cell.lblTitle.text = NSString.init(format: "%@",(self.mainCategoryArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "titleName") as! CVarArg) as String
        cell.imgIcon.image = UIImage.init(named: NSString.init(format: "%@",(self.mainCategoryArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "imageName") as! CVarArg) as String)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.ProfileVC)
            NotificationCenter.default.post(name: Notification.Name(rawValue: KVSideMenu.Notifications.toggleLeft), object: self)
        }
       else if indexPath.row == 1
        {
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.HomeviewVC)
            NotificationCenter.default.post(name: Notification.Name("SlideCloseHomeview"), object: nil,userInfo:nil)
            NotificationCenter.default.post(name: Notification.Name(rawValue: KVSideMenu.Notifications.toggleLeft), object: self)
          
        }
        else if indexPath.row == 2
        {
            self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.OrderHistory)
            NotificationCenter.default.post(name: Notification.Name(rawValue: KVSideMenu.Notifications.toggleLeft), object: self)
            
          
        }
        //        leftTbl.reloadData()
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 55
    }
    
    
    
    
}

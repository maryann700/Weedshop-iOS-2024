//
//  AppDelegate.swift
//  weedshop
//
//  Created by Devubha Manek on 23/02/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import CoreLocation
import GoogleMaps
import GooglePlaces
import Alamofire
import UserNotifications
import GLNotificationBar


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate
{
    

    var window: UIWindow?
    var locationManager = CLLocationManager()
    var storyBoard = UIStoryboard()
    var navController = UINavigationController()
    var DriverInfo = driverInfo()
    var manager = NetworkReachabilityManager()

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self])
     
        GMSServices.provideAPIKey("AIzaSyD5dRdfmT4dpHjAo7Rdy-WOK4YMixclnuo")
        GMSPlacesClient.provideAPIKey("AIzaSyD5dRdfmT4dpHjAo7Rdy-WOK4YMixclnuo")
        
        registerForRemoteNotification()
        
        locationManager = CLLocationManager()
        if (CLLocationManager.locationServicesEnabled())
        {
           
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            //locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        manager = NetworkReachabilityManager(host: "www.google.com")
        
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            if self.manager?.isReachable == true
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkAvailable"), object: nil)
            }
        }
        
        manager?.startListening()
        
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            self.updateDeviceToken()
        }
        
        // App Review Status Check
        ServiceClass.sharedInstance.checkAppReviewStatus()
        
        storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let login = UserDefaults.Main.bool(forKey: .isLogin)
        if login == true
        {
            navController = self.storyBoard.instantiateViewController(withIdentifier: "navSliderRoot") as! UINavigationController
            navController.interactivePopGestureRecognizer?.isEnabled = false
            self.window?.rootViewController = navController;
        }
        else
        {
            
            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            navController = UINavigationController.init(rootViewController: vc)
            navController.navigationBar.isHidden = true
            navController.interactivePopGestureRecognizer?.isEnabled = false
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
            
        }
        
        //  Converted with Swiftify v1.0.6355 - https://objectivec2swift.com/
        let remoteNotifiInfo = (launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification])
        
        //Accept push notification when app is not open
        if remoteNotifiInfo != nil
        {
            self.application(application, didReceiveRemoteNotification: remoteNotifiInfo as! [AnyHashable : Any])
            print("didReceiveRemoteNotification call from did finish =>\(String(describing: remoteNotifiInfo))")
        }
        
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
        
        return true
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error while updating location " + error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //locationManager.stopUpdatingLocation()
        if locations.count > 0
        {
            self.checkLocation(location: locations)
        }
    
    }
    func checkLocation(location: [CLLocation]) -> Void
    {
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = location[0]
            
            let latitude :CLLocationDegrees = currentLocation.coordinate.latitude
            let longitude :CLLocationDegrees = currentLocation.coordinate.longitude

            let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
            print(location)
            
            let ServiceCl = ServiceClass()
            ServiceCl.callForLocationUpdate(lat: "\(latitude)" as NSString, Long:"\(longitude)" as NSString)
         
            
            
            let lat = NSNumber(value: location.coordinate.latitude)
            let lon = NSNumber(value: location.coordinate.longitude)
            let DriverLocation: NSDictionary = ["lat": lat, "long": lon]
            
            UserDefaults.Main.set(DriverLocation, forKey: .driverLocation)
            UserDefaults.standard.synchronize()

            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                print(location)
                
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks!.count) > 0
                {
                    let pm = placemarks![0]
                    
                    if pm.locality !=  nil
                    {
                        print(pm.locality!)
                        print(pm.addressDictionary!)
                        
                        
                        let lat = NSNumber(value: location.coordinate.latitude)
                        let lon = NSNumber(value: location.coordinate.longitude)
                        let DriverLocation: NSDictionary = ["lat": lat, "long": lon, "locationName": pm.locality!]
                        
                        if UserDefaults.Main.object(forKey: .driverLocation) != nil
                        {
                            let userLocation: NSDictionary  = UserDefaults.Main.object(forKey: .driverLocation) as! NSDictionary
                            if userLocation.allKeys.count > 0 {
                                
                                let lat = NSNumber(value: location.coordinate.latitude)
                                let lon = NSNumber(value: location.coordinate.longitude)
                                let DriverLocation: NSDictionary = ["lat": lat, "long": lon, "locationName": (pm.locality!)]
                                
                                UserDefaults.Main.set(userLocation, forKey: .driverLocation)
                                UserDefaults.standard.synchronize()
                            }
                        }
                        
                        let tempAddress = pm.addressDictionary!
                        print(tempAddress)
                        
                        let state = tempAddress[AnyHashable("State")] as! String
                        let countryCode = tempAddress[AnyHashable("CountryCode")] as! String
                        
                        if (state == "Gujarat" && countryCode == "IN") || (state == "CA" && countryCode == "US")
                        {
                            print("in Area")
                            
                            var vc = self.window?.rootViewController
                            if vc is UINavigationController
                            {
                                vc = (vc as! UINavigationController).visibleViewController
                                print(vc!)
                                
                                if vc is LocationVerificationVC
                                {
                                    self.window?.rootViewController?.dismiss(animated: true, completion: {
                                    })
                                }
                            }
                        }
                        else
                        {
                            let vc = self.storyBoard.instantiateViewController(withIdentifier: "LocationVerificationVC") as! LocationVerificationVC
                            self.window?.rootViewController?.present(vc, animated: true, completion: {
                                
                            })
                            
                        }
                        
                    }
                    else
                    {
                        let vc = self.storyBoard.instantiateViewController(withIdentifier: "LocationVerificationVC") as! LocationVerificationVC
                        self.window?.rootViewController?.present(vc, animated: true, completion: {
                            
                        })
                        
                    }
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })
            
            
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      
        let  statusBarFrame = UIApplication.shared.statusBarFrame
        if statusBarFrame.size.height > 20
        {
            UIApplication.shared.isStatusBarHidden = true
            UserDefaults.Main.set(true, forKey: .isHotSpotActive)
            UserDefaults.standard.synchronize()
        }
        else
        {
            UserDefaults.Main.set(false, forKey: .isHotSpotActive)
            UserDefaults.standard.synchronize()
            UIApplication.shared.isStatusBarHidden = false
        }

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        
        
        let product_info_notify = UserDefaults.Main.object(forKey: .product_info_notify)
        if product_info_notify != nil
        {
            UserDefaults.Main.removeObj(forKey: .product_info_notify)
        }
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
            locationManager.startMonitoringSignificantLocationChanges()
    }
    func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        print("status frame\( newStatusBarFrame)")
        if newStatusBarFrame.size.height > 20
        {
        UIApplication.shared.isStatusBarHidden = false
        UserDefaults.Main.set(true, forKey: .isHotSpotActive)
            UserDefaults.standard.synchronize()
        }
        else
        {
            UserDefaults.Main.set(false, forKey: .isHotSpotActive)
            UserDefaults.standard.synchronize()
            UIApplication.shared.isStatusBarHidden = false
        }
    }
    
    
    // Update Device Token
    
    func updateDeviceToken() -> Void
    {
        var userID = ""
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            userID = UserDefaults.Main.string(forKey: .DriverID)
        }
        var deviceToken = ""
        let dToken: String = UserDefaults.Main.string(forKey: .deviceToken)
        if (dToken.characters.count > 0)
        {
            deviceToken = UserDefaults.Main.string(forKey: .deviceToken)
        }
        
        let uniqID = createString(value: UIDevice.current.identifierForVendor?.uuidString as AnyObject)
        
        ServiceClass.sharedInstance.userDeviceTokenUpdate(userID: userID, token: deviceToken, uniqueid: uniqID) { (success, message) in
            
            
        }
    }
    
    
    //MARK: - RegisterForRemoteNotifications Methods
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Registration succeeded!")
        print("Token: ", token)
        
        let ttoken = createString(value: token as AnyObject)
        if ttoken.characters.count > 0
        {
            UserDefaults.Main.set(ttoken, forKey: .deviceToken)
            UserDefaults.standard.synchronize()
        }
        self.updateDeviceToken()
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //UserDefaults.standard.set("e617960027a07370672d140a3f1062cd49e998977591581f4ccb00ea9a76dbe7", forKey: "DeviceToken")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("User Info :\(userInfo)")
        
        let data = userInfo
        let aps = data[AnyHashable("aps")] as! [AnyHashable: Any]
        let key = createString(value: data["info"] as AnyObject)
        let message = createString(value: aps["alert"] as AnyObject)
        
        
        if application.applicationState == UIApplicationState.active
        {
            _ = GLNotificationBar.init(title: "", message: message, preferredStyle: .simpleBanner, handler: { (success) in
                
                if key == "101"
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "showCurrentOrder"), object: self)
                }
                else if key == "100"
                {
                        UserDefaults.Main.set(true, forKey: .isLogin)
                        UserDefaults.Main.set(true, forKey: .isAdminVerify)
                        UserDefaults.standard.synchronize()

                        
                        self.navController = self.storyBoard.instantiateViewController(withIdentifier: "navSliderRoot") as! UINavigationController
                        self.navController.interactivePopGestureRecognizer?.isEnabled = false
                        self.window?.rootViewController =  self.navController;
                        
                }
            })
        }
        else if application.applicationState == UIApplicationState.inactive
        {
            if key == "101"
            {
                self.perform(#selector(self.sendOnMap), with: self, afterDelay: 2.0)
            }
            else if key == "100"
            {
                UserDefaults.Main.set(true, forKey: .isLogin)
                UserDefaults.Main.set(true, forKey: .isAdminVerify)
                    UserDefaults.standard.synchronize()
                    
                    
                    self.navController = self.storyBoard.instantiateViewController(withIdentifier: "navSliderRoot") as! UINavigationController
                    self.navController.interactivePopGestureRecognizer?.isEnabled = false
                    self.window?.rootViewController =  self.navController;
                    
            }
        }
        else if application.applicationState == UIApplicationState.background
        {
            if key == "101"
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "showCurrentOrder"), object: self)
            }
            else if key == "100"
            {
                UserDefaults.Main.set(true, forKey: .isLogin)
                UserDefaults.Main.set(true, forKey: .isAdminVerify)
                    UserDefaults.standard.synchronize()
                    
                    
                    self.navController = self.storyBoard.instantiateViewController(withIdentifier: "navSliderRoot") as! UINavigationController
                    self.navController.interactivePopGestureRecognizer?.isEnabled = false
                    self.window?.rootViewController =  self.navController;
                    
            }
        }
        
         UIApplication.shared.cancelAllLocalNotifications()
    }
    
    func sendOnMap() -> Void
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showCurrentOrder"), object: self)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {

        
        UserDefaults.Main.set(true, forKey: .isLogin)
        UserDefaults.Main.set(true, forKey: .isAdminVerify)
        UserDefaults.standard.synchronize()
            
            
        self.navController = self.storyBoard.instantiateViewController(withIdentifier: "navSliderRoot") as! UINavigationController
        self.navController.interactivePopGestureRecognizer?.isEnabled = false
        self.window?.rootViewController =  self.navController;
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
        center.removeAllDeliveredNotifications() // To remove all delivered notifications

        completionHandler([.badge, .alert, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        //  print("Response Info :\(response.notification.request.content.body)")
        print("Response Info :\(response.notification.request.content.userInfo)")
        
        let data = response.notification.request.content.userInfo as [AnyHashable: Any]
        

    }
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

   
}


// Add your userdefault key here :
extension UserDefaults
{
    struct Main : UserDefaultable {
        private init() { }
        
        enum BoolDefaultKey : String {
            case isLogin
            case isSignUp
            case isEmailVerify
            case isIdCardVerify
            case isCarVerify
            case isAdminVerify
            case isProductAccept
            case isHotSpotActive
            case isOrder
        }
        
        enum FloatDefaultKey:String {
            case floatKey
            case KVSideMenuOffsetValueInRatio
        }
        
        enum DoubleDefaultKey: String {
            case doubleKey
        }
        
        enum IntegerDefaultKey: String {
            case IntKey
        }
        
        enum StringDefaultKey: String {
            case DriverID
            case deviceToken
            case currentReviewVersion
        }
        
        
        enum URLDefaultKey: String {
            case urlKey
        }
        
        enum ObjectDefaultKey: String {
            case driverInfo
            case driverLocation
            case userProfile
            case product_info_notify
            case currentOrderInfo
            
        }
    }
}



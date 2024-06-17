//
//  ShopListVC.swift
//  weedshop
//
//  Created by Devubha Manek on 01/03/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import GoogleMaps
import GooglePlaces
import KRProgressHUD


extension HomeViewVC {
    
    
    
}

enum DriverStage {
    case Normal
    case Notify
    case productDeliver
    
}



extension HomeViewVC :ProductNotifyDelegate {
    

    
    func ProductNotifyToDriversWithData(sender: Product_notify) {
        KRProgressHUD.dismiss({})
            self.DriverinNofityStage(product_info: sender)
        
        
    }
    func ProductAccept() {
        KRProgressHUD.dismiss({
            
        })
        self.HideAlertView()
        
    }
    func Productdecline() {
        KRProgressHUD.dismiss({
            
        })
        self.HideAlertView()
        self.DriverinNormalStage()
    }
    func failmessageForAlert(msg: String){
        
        KRProgressHUD.dismiss({
            
        })
        IsAccept = ""
        
        IsFail = true
        
        UIView.animate(withDuration: 0.2, animations: {
              self.HideAlertView()
        }) { (yes) in
            self.showAlerView(headerLbl: "ALERT", messagelbl: msg, pricelbl: "",btn_title:"OK")
        }
    }
    func conformForAlert(msg: String){
        self.HideAlertView()
        IsPickupOrPayment = ""
        
        KRProgressHUD.dismiss({
            
            if  msg == "Your request pickup order successfully!"{
                
                let alert = UIAlertController.init(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                    
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                UserDefaults.Main.set(true, forKey: .isOrder)
                
            }else if msg == "Your request delivered order successfully!"{
                let alert = UIAlertController.init(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                    
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                UserDefaults.Main.removeObj(forKey: .product_info_notify)
                UserDefaults.Main.removeObj(forKey: .currentOrderInfo)
                UserDefaults.Main.removeObj(forKey: .isOrder)
                self.IsPickupOrPayment = "NO"
                self.isProductActive = false
                self.GmapView.clear()
                self.DriverinNormalStage()
            }
        })

            
        
    // self.showAlerView(headerLbl: "Alert", messagelbl: msg, pricelbl: "")
        
        
    }
    func Is_accept_success() {
        
        IsAccept = ""
        let product_info = UserDefaults.Main.object(forKey: .product_info_notify)
        if product_info != nil
        {
           
            let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
            KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
            KRProgressHUD.show()
            
            lbl_header.text  = "Current Order"
            let product_info: Product_notify = NSKeyedUnarchiver.unarchiveObject(with: product_info as! Data) as! Product_notify
            bgservice.driver_current_order_detail(order_id: product_info.id as NSString)
            
        }
        
    }
    func Current_order_of_driver(sender: CurrentOrderDetail) {
        KRProgressHUD.dismiss({
             self.DriverinProductDeliverStage()
        })
       
    }
    func FailCurrentOrder(msg: String) {
        KRProgressHUD.dismiss({
//            let product_info = UserDefaults.Main.object(forKey: .product_info_notify)
//            if product_info != nil
//            {
//                let product_info: Product_notify = NSKeyedUnarchiver.unarchiveObject(with: product_info as! Data) as! Product_notify
//                self.bgservice.driver_current_order_detail(order_id: product_info.id as NSString)
//            }
            let alert = UIAlertController.init(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                self.DriverinNormalStage()
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        })
        
    }
   

}






class HomeViewVC: MTViewController,GMSMapViewDelegate
{
    
    
    
    @IBOutlet weak var lbl_header: MTLabel!
    //Green View to show user location
    @IBOutlet weak var NormalView: UIView!
    @IBOutlet weak var GreenView_street_lbl: UILabel!
    @IBOutlet weak var GreenVIew_KM_lbl: UILabel!
    
    
    @IBOutlet weak var constrin_code: NSLayoutConstraint!
    
    @IBOutlet weak var Lbl_Product_code: MTLabel!
    
     var appDelegate = AppDelegate()
    @IBOutlet weak var constrain_alert: NSLayoutConstraint!
    
    var Progress_timer :Timer!
    
    
    var bgservice  = BackGroundServices();
    //Mapview data show
    var GmapView: GMSMapView!
    
    var GmapUserMark: GMSMarker!
     var GmapDiverMark: GMSMarker!
    var GmapShoprmarker: GMSMarker!
    var GmapDrliverMark: GMSMarker!
    
    
    var usrPosition =  CLLocationCoordinate2D()
    var ShopPosition =  CLLocationCoordinate2D()
    var DeliverPosition =  CLLocationCoordinate2D()
    
    @IBOutlet weak var MapView: UIView!
    
    //progress view data
    @IBOutlet weak var progressBarView: UIView!
    var TimerView: BRCircularProgressView!
    @IBOutlet weak var View_main_drag: UIView!
    var IsAccept = ""
    var IsPickupOrPayment = "NO"
    var IsFail = false
    var currentReviewVersion: String = ""

    
    @IBOutlet weak var NotifyTimeView: UIView!

    var isProductActive = false
    
    @IBOutlet weak var DrafviewHeight: NSLayoutConstraint!
    // MARK:- =======================================================
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.MapView.layoutIfNeeded()
        
        bgservice.delegate = self
        
        self.DriverinNormalStage()
        isProductActive = false
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Create a GMSCameraPosition that tells the map to display the
       
        
        let camera = GMSCameraPosition.camera(withLatitude: 23, longitude: 72, zoom: 11.0)
        GmapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.MapView.frame.size.width , height: self.MapView.frame.size.height), camera: camera)
        
        let location = UserDefaults.Main.object(forKey: .driverLocation) as? NSDictionary
        if location != nil{
            
            let lat = location?.value(forKey:  "lat") as! NSNumber
            let lon = location?.value(forKey:  "long") as! NSNumber
            
            
            let position = CLLocationCoordinate2D(latitude:CLLocationDegrees(lat) , longitude: CLLocationDegrees(lon))
            let camera:GMSCameraPosition  = GMSCameraPosition.camera(withTarget: position, zoom: 12.0)
            self.GmapView.animate(to: camera)
            
        }
        
        self.MapView.addSubview(GmapView)
        
        //set mapview color
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "googleMapsStyle", withExtension: "json") {
                GmapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        self.currentReviewVersion = createString(value: UserDefaults.Main.string(forKey: .currentReviewVersion) as AnyObject)
        
        GmapView.delegate = self
      //  self.ShowDriverCurent_marker(position: )
               
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewVC.NotificationFromDragView(notification:)), name: Notification.Name("DragNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewVC.LocationUpdateNotification(notification:)), name: Notification.Name("LocationUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewVC.stopInterection(notification:)), name: Notification.Name("SlideCloseHomeview"), object: nil)
       

         self.performSelector(inBackground: #selector(self.checkAppReview), with: self)
        
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
       

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
        bgservice.delegate = self
        
        if UserDefaults.Main.object(forKey: .driverLocation) != nil
        {
            let driverLocation: NSDictionary  = UserDefaults.Main.object(forKey: .driverLocation) as! NSDictionary
            if driverLocation.allKeys.count > 0 {
                print(driverLocation)
                let latitute =  createDoubleToString(value: driverLocation.object(forKey: "lat") as AnyObject )
                let longitute = createDoubleToString(value:  driverLocation.object(forKey: "long")  as AnyObject)
                let ServiceCl = ServiceClass()
                ServiceCl.callForLocationUpdate(lat: latitute as NSString, Long: longitute as NSString)
            }
        }
        
        
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("siapper")
    }
    // Set Status Bar Style Light(White)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Check App Review Status
    @objc func checkAppReview() -> Void {
        ServiceClass.sharedInstance.checkAppReviewStatus()
    }
    
    
    func ChangesAnimation_icon(text:String)  {
        
    
        if GmapShoprmarker != nil{
            let myCustomShop: MarkerSmallView = .instanceFromNibSmall(Marker_image: #imageLiteral(resourceName: "ShopMarkerWeed"), Window_image: #imageLiteral(resourceName: "ShopWindow"), MakerTitle: "", Window_title:"Shop" )
            GmapShoprmarker.iconView = myCustomShop
        }
        if GmapDiverMark != nil{
            let myCustomDriver: MarkerSmallView = .instanceFromNibSmall(Marker_image: #imageLiteral(resourceName: "DriverMarkerWeed"), Window_image: #imageLiteral(resourceName: "DriverWindow"), MakerTitle: "", Window_title: "You")
            GmapDiverMark.iconView = myCustomDriver
        }
        if GmapDrliverMark != nil{
            let myCustomDeliver: MarkerSmallView = .instanceFromNibSmall(Marker_image: #imageLiteral(resourceName: "DeliverMarker"), Window_image: #imageLiteral(resourceName: "DeliverMarkerWeed"), MakerTitle: "", Window_title: "Delivery")
            GmapDrliverMark.iconView = myCustomDeliver
        }
        
        if text  == "Shop"{
           
            let myCustomShop1: MarkerView = .instanceFromNib(Marker_image: #imageLiteral(resourceName: "ShopMarkerWeed"), Window_image: #imageLiteral(resourceName: "ShopWindow"), MakerTitle: "", Window_title:"Shop" )
            self.GmapShoprmarker?.iconView = myCustomShop1
            
        }else if text  == "You"{
            
            let myCustomDriver1: MarkerView = .instanceFromNib(Marker_image: #imageLiteral(resourceName: "DriverMarkerWeed"), Window_image: #imageLiteral(resourceName: "DriverWindow"), MakerTitle: "", Window_title: "You")
            self.GmapDiverMark?.iconView = myCustomDriver1
            
            
        }else if text  == "Delivery"{
            let myCustomDeliver1: MarkerView = .instanceFromNib(Marker_image: #imageLiteral(resourceName: "DeliverMarkerWeed"), Window_image: #imageLiteral(resourceName: "DeliverWindow"), MakerTitle: "", Window_title:"Delivery")
            self.GmapDrliverMark?.iconView = myCustomDeliver1
            
        }
        else{
            let myCustomView: MarkerView = .instanceFromNib(Marker_image: #imageLiteral(resourceName: "DriverMarkerWeed"), Window_image: #imageLiteral(resourceName: "Rounded Rectangle 23 copy"), MakerTitle: "", Window_title: "You")
            GmapUserMark.iconView = myCustomView
            
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        
        if  isProductActive{
            if (mapView.selectedMarker?.iconView?.isKind(of: MarkerSmallView.self))!{
                let marker  = mapView.selectedMarker?.iconView as! MarkerSmallView
                self.ChangesAnimation_icon(text: marker.title.text!)
            }else if(mapView.selectedMarker?.iconView?.isKind(of: MarkerView.self))!{
                let marker  = mapView.selectedMarker?.iconView as! MarkerView
                self.ChangesAnimation_icon(text: marker.lbl_title.text!)
            }
            
        }
        
        
       // GmapUserMark.iconView = myCustomView
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        return view
    }
    
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        UIView.animate(withDuration: 5.0, animations: { () -> Void in
            
        }, completion: {(finished) in
            // Stop tracking view changes to allow CPU to idle.
        })
        
    }
    
    
    
    // MARK:- =======================================================
    // MARK: - Action Methods of view controller
    
    @IBAction func btnMenuTap(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotifyProduct"), object: nil)
        
        bgservice.StopTimer_ProductNotify()
        self.NormalView.isUserInteractionEnabled = false
        self.NotifyTimeView.isUserInteractionEnabled = false
        self.View_main_drag.isUserInteractionEnabled = false
        self.MapView.isUserInteractionEnabled = false
        
        (sender as AnyObject).layer.startAnimation(tintColor :UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0))
        NotificationCenter.default.post(name: Notification.Name(rawValue: KVSideMenu.Notifications.toggleLeft), object: self)
        
        
    }
    func stopInterection(notification: Notification){
        
        
        
        let product_info = UserDefaults.Main.object(forKey: .product_info_notify)
        if product_info == nil
        {
            bgservice.StartTimer_ProductNotify()
        }
        
        self.MapView.isUserInteractionEnabled = true
        self.NormalView.isUserInteractionEnabled = true
        self.NotifyTimeView.isUserInteractionEnabled = true
        self.View_main_drag.isUserInteractionEnabled = true
    
    }
    
    
    @IBAction func btnCartItemTap(_ sender: Any)
    {
//        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.OrderHistory)
    }
    
    // MARK:- Alert View
    
    //Alert Reminder View
    
    @IBOutlet weak var Alert_reminder_view: UIView!
    @IBOutlet weak var Alert_lbl_header: UILabel!
    @IBOutlet weak var Alert_price: UILabel!
    @IBOutlet weak var alert_message: UILabel!
    
    @IBOutlet weak var Btn_title_Yes: UILabel!
    @IBOutlet weak var StaticPrice: UILabel!
    func HideAlertView(){
        self.constrain_alert.constant = 1000
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: {(finished) in
            // Stop tracking view changes to allow CPU to idle.
        })
        
        
    }
    func Show_Alert(){
        if  self.constrain_alert.constant != 0{
            self.constrain_alert.constant = 0
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.view.layoutIfNeeded()
            }, completion: {(finished) in
                // Stop tracking view changes to allow CPU to idle.
            })
        }
        
    }
    func showAlerView(headerLbl:String,messagelbl:String,pricelbl:String,btn_title:String)  {
        Alert_lbl_header.text = headerLbl
        Alert_price.text = pricelbl
        alert_message.text = messagelbl
        if  pricelbl == ""{
            self.StaticPrice.isHidden = true
        }else{
            self.StaticPrice.isHidden = false
        }
        self.Btn_title_Yes.text = btn_title
        self.Show_Alert()
        
        
    }
    
    // MARK:- Alert button YES cross
    @IBAction func Yes_fileter_controller(_ sender: UIControl) {
        
      
        
        if IsFail{
            IsFail = false
            self.HideAlertView()
            return
        
        }
        if IsAccept == "Accept" {
         
            if  bgservice.product_info != nil
            {
                
                let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
                KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
                KRProgressHUD.show()
                bgservice.produt_deliver_accept_decline(action: true,  order_id:  bgservice.product_info.id as NSString)
            }
            self.NotifyTimeView.isHidden = true
            if (TimerView != nil) {
                self.TimerView.removeFromSuperview()
            }
            if (Progress_timer != nil) {
                Progress_timer.invalidate()
                Progress_timer = nil
            }
            
        }
        else if  IsAccept == "Decline"{
            
            if  bgservice.product_info != nil
            {
                let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
                KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
                KRProgressHUD.show()
                
                bgservice.produt_deliver_accept_decline(action: false, order_id:  bgservice.product_info.id as NSString)
            }
            
            UserDefaults.Main.removeObj(forKey: .product_info_notify)
            if (TimerView != nil) {
                self.TimerView.removeFromSuperview()
            }
            if (Progress_timer != nil) {
                Progress_timer.invalidate()
                Progress_timer = nil
            }
        }
        else if  IsPickupOrPayment == "pickup"{
            let ordered =  UserDefaults.Main.bool(forKey: .isOrder)
            if !ordered{
                let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
                KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
                KRProgressHUD.show()
                 bgservice.driver_order_action(action: IsPickupOrPayment as NSString)
            }else{
                self.HideAlertView()
            }
           
            
        }
        else if IsPickupOrPayment == "delivered"{
            
            let ordered =  UserDefaults.Main.bool(forKey: .isOrder)
            if ordered{
                let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
                KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
                KRProgressHUD.show()
                bgservice.driver_order_action(action: IsPickupOrPayment as NSString)
            }else{
                self.HideAlertView()
            }
            
           
        }
        else if IsPickupOrPayment == "" {
           self.HideAlertView()
            
        }
        else if  IsAccept == "" {
            self.NotifyTimeView.isHidden = true
            if (TimerView != nil) {
                self.TimerView.removeFromSuperview()
                
            }
            if (Progress_timer != nil) {
                Progress_timer.invalidate()
                Progress_timer = nil
            }
            self.DriverinNormalStage()
            self.HideAlertView()
            
        }
        
    }
    
    @IBAction func Cross_control(_ sender: Any) {
        
        if IsFail{
            IsFail = false
            self.HideAlertView()
            return
            
        }
        
        if  IsAccept == ""  &&  !isProductActive{
            
            self.NotifyTimeView.isHidden = true
            if (TimerView != nil) {
                self.TimerView.removeFromSuperview()
            }
            if (Progress_timer != nil) {
                Progress_timer.invalidate()
                Progress_timer = nil
            }
           
            self.DriverinNormalStage()
            
           
        }
       
        self.HideAlertView()
        
    }
    
    
     @IBAction func ShowCureentOrderDetail(_ sender: Any) {

        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            print(version)
            
            if currentReviewVersion != version{
                self.CheckProductInfoCurrent { (current_Order_Info ) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailVC") as! OrderDetailVC
                    vc.orderID = current_Order_Info.id
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    // MARK:- proggress for aceept
    @IBOutlet weak var lbl_user_address: UILabel!
    @IBOutlet weak var lbl_delivery_address: UILabel!
    @IBOutlet weak var lbl_price_progress_view: UILabel!
    @IBOutlet weak var lbl_time_progress_view: UILabel!
    @IBOutlet weak var lbl_distance_progress_view: UILabel!
    @IBOutlet weak var progress_decline_control: UIControl!
    @IBOutlet weak var Progress_accept_control: UIControl!
    
    @IBAction func Accept_progress_click(_ sender: UIControl) {
        
        IsAccept = "Accept"
        var price = ""
        if bgservice.product_info != nil {
            price = "$" + bgservice.product_info.final_total
            self.showAlerView(headerLbl:IsAccept , messagelbl: "Are you sure you want to accept this order?", pricelbl: price,btn_title:"YES")
        }
        
    }
    
    
    
    @IBAction func Decline_progress_click(_ sender: UIControl) {
        
        IsAccept = "Decline"
        
        var price = ""
        if bgservice.product_info != nil {
            price = "$" + bgservice.product_info.final_total
            self.showAlerView(headerLbl:IsAccept , messagelbl: "Are you sure you want to decline this order?", pricelbl: price,btn_title:"YES")
        }
        
    }
    
    
    func showTimerProgressViaNIB(Time:CGFloat) {
        
        if (TimerView != nil) {
            if (TimerView != nil) {
                self.TimerView.removeFromSuperview()
              
            }
            if (Progress_timer != nil) {
                Progress_timer.invalidate()
                Progress_timer = nil
            }
        }
        TimerView = BRCircularProgressView()
        TimerView.frame =  CGRect(x: 0, y: 0, width: progressBarView.frame.size.width, height: progressBarView.frame.size.height)
        progressBarView.addSubview(TimerView)
        TimerView.setCircleStrokeWidth(2)
        var second: CGFloat = Time
        TimerView.setProgressText("\(Int(second))")
        
        if #available(iOS 10.0, *) {
            Progress_timer =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (timer) in
                second -= 1
                self?.TimerView.progress = second/Time
                self?.TimerView.setProgressText("\(Int(second))")
                
                if second == 0 { // restart rotation
                    self?.TimerClose()
                }
            }
        } else {
            
            Progress_timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(HomeViewVC.Timer_called_accept_decline(timer:)), userInfo: ["second":second, "time": Time], repeats: false)
            
            
            
        }
    }
    func Timer_called_accept_decline(timer: Timer)  {
        
        let userinfo = timer.userInfo as! NSDictionary
        var second: CGFloat = userinfo.value(forKey:"second") as! CGFloat
        let Time: CGFloat = userinfo.value(forKey: "time") as! CGFloat
        
        second -= 1
        self.TimerView.progress = second/Time
        self.TimerView.setProgressText("\(Int(second))")
  
        if second == 0 { // restart rotation
            self.TimerClose()
        }else{
            Progress_timer.invalidate()
            Progress_timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(HomeViewVC.Timer_called_accept_decline(timer:)), userInfo: ["second":second, "time": Time], repeats: false)
        
        }
        
    }
    func TimerClose() {
        if (self.TimerView != nil) {
            self.TimerView.removeFromSuperview()
        }
        if (self.Progress_timer != nil) {
            self.Progress_timer.invalidate()
            self.Progress_timer = nil
        }
        
        if bgservice.product_info != nil
        {
            self.bgservice.produt_deliver_accept_decline(action: false, order_id: bgservice.product_info.id as NSString)
        }
        
        UserDefaults.Main.removeObj(forKey: .product_info_notify)
        
        self.DriverinNormalStage()
    }
    
    

    func DriverinNormalStage()  {
        
      
        self.NormalView.isHidden = true
        self.NotifyTimeView.isHidden = true
        self.View_main_drag.isHidden = true
        self.DrafviewHeight.constant = 0
        self.Lbl_Product_code.text = ""
        self.constrin_code.constant = 0
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }

      
        let product_info = UserDefaults.Main.object(forKey: .product_info_notify)
        if product_info != nil
        {
             lbl_header.text  = "Current Order"
            
            let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
            KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
            KRProgressHUD.show()
            
            let product_info: Product_notify = NSKeyedUnarchiver.unarchiveObject(with: product_info as! Data) as! Product_notify
            bgservice.driver_current_order_detail(order_id: product_info.id as NSString)
            
        }else{
            
            lbl_header.text  = "Your Current Location"
            self.NormalView.isHidden = false
            self.NotifyTimeView.isHidden = true
            if (TimerView != nil) {
                self.TimerView.removeFromSuperview()
                if (Progress_timer != nil) {
                    Progress_timer.invalidate()
                    Progress_timer = nil
                }
                
            }
            self.View_main_drag.isHidden = true
            
            
            bgservice.StartTimer_ProductNotify()
        }
        
        let location = UserDefaults.Main.object(forKey: .driverLocation) as? NSDictionary
        if location != nil{
            
            let lat = location?.value(forKey:  "lat") as! NSNumber
            let lon = location?.value(forKey:  "long") as! NSNumber
            let ServiceCl = ServiceClass()
            ServiceCl.callForLocationUpdate(lat: "\(lat)" as NSString, Long: "\(lon)" as NSString)
        }
    }
    
    func DriverinNofityStage(product_info : Product_notify)  {
        
        self.NormalView.isHidden = true
        self.NotifyTimeView.isHidden = false
        self.View_main_drag.isHidden = true
        
        lbl_user_address.text = product_info.driver_address
        lbl_delivery_address.text =  product_info.delivery_address
        lbl_distance_progress_view.text = product_info.delivery_distance + "km"
        lbl_time_progress_view.text = product_info.delivery_time
        lbl_price_progress_view.text = "$" + product_info.final_total
        
        let delivery_time = Int(product_info.request_timeout)
        showTimerProgressViaNIB(Time: CGFloat(delivery_time!))
        
    }
    
    func DriverinProductDeliverStage()  {
       
        lbl_header.text  = "Current Order"
        isProductActive = true
        self.GmapView.clear()
        self.NormalView.isHidden = true
        self.NotifyTimeView.isHidden = true
        if (TimerView != nil) {
            self.TimerView.removeFromSuperview()
        }
        if (Progress_timer != nil) {
            Progress_timer.invalidate()
            Progress_timer = nil
        }
        
        self.constrin_code.constant = 45
        if DeviceType.IS_IPHONE_6PLUS || DeviceType.IS_IPHONE_6
        {
           self.DrafviewHeight.constant = 310
        }
        else if DeviceType.IS_IPHONE_5
        {
            self.DrafviewHeight.constant = 280
        
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        self.View_main_drag.isHidden = false
        
        self.View_main_drag.layoutIfNeeded()
        let viewdrag = DragView(frame:CGRect(x: 0, y: 0, width: self.View_main_drag.frame.size.width, height: self.View_main_drag.frame.size.height))
        self.View_main_drag.addSubview(viewdrag)
        
        print(viewdrag.DrageScroll)
        viewdrag.setupScrollView()
        
        
        self.CheckProductInfoCurrent { (current_Order_Info ) in
            
            self.Lbl_Product_code.text = "Order id: " + current_Order_Info.order_code
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
            let origin = current_Order_Info.driver_latitude + "," + current_Order_Info.driver_longitude
            let destination = current_Order_Info.store_latitude + "," + current_Order_Info.store_longitude
            self.drawPath(origin:origin , Destination: destination)
        }
    }
    
    
    func CheckProductInfoCurrent(WithComplete:(_ Order:CurrentOrderDetail ) ->Void)  {
        let current_Order_Info = UserDefaults.Main.object(forKey: .currentOrderInfo)
        if current_Order_Info != nil
        {
            let current_Order_Info: CurrentOrderDetail = NSKeyedUnarchiver.unarchiveObject(with: current_Order_Info as! Data) as! CurrentOrderDetail
            
          WithComplete(current_Order_Info)
            
        }
    }
    
    // MARK:- Drag viwe action order and delivered
    
    func NotificationFromDragView(notification: Notification){
        
        if let action = notification.userInfo?["action"] as? String {
            
            var price = ""
            let current_Order_Info = UserDefaults.Main.object(forKey: .currentOrderInfo)
            if current_Order_Info != nil
            {
                let current_Order_Info: CurrentOrderDetail = NSKeyedUnarchiver.unarchiveObject(with: current_Order_Info as! Data) as! CurrentOrderDetail
                
                price = "$" + current_Order_Info.final_total
            }
            
            if action == "pickup"{
                
               let ordered =  UserDefaults.Main.bool(forKey: .isOrder)
                if ordered{
                
                    IsPickupOrPayment = "pickup"
                    self.showAlerView(headerLbl:"ALERT" , messagelbl: "You Already PickUp Product From Shop",pricelbl:price,btn_title:"OK")
                }else{
                    IsPickupOrPayment = "pickup"
                    self.showAlerView(headerLbl:"REMINDER" , messagelbl: "Have you collected product from shop?", pricelbl:price,btn_title:"YES")
                }
                
               
            }else if  action == "delivered"{
                IsPickupOrPayment = "delivered"
               
                
                let ordered =  UserDefaults.Main.bool(forKey: .isOrder)
                if ordered{
                    
                    self.showAlerView(headerLbl:"REMINDER" , messagelbl: "Have you collected payment from client?", pricelbl:price,btn_title:"YES")
                }else{
                
                 self.showAlerView(headerLbl:"ALERT" , messagelbl: "First collect product from shop", pricelbl:price,btn_title:"OK")
                
                }
                
                
                
                
               
                
            }else{
                IsPickupOrPayment = ""
            }
            
        }
    }
    
    func LocationUpdateNotification(notification: Notification) {
        
        
        
        
        if let address = notification.userInfo?["address"] as? String {
            if address != ""{
                

                let location = UserDefaults.Main.object(forKey: .driverLocation) as! NSDictionary
                if location != nil{
                    
                    let lat = location.value(forKey:  "lat") as! NSNumber
                    let lon = location.value(forKey:  "long") as! NSNumber
                   
                    
                    let position = CLLocationCoordinate2D(latitude:CLLocationDegrees(lat) , longitude: CLLocationDegrees(lon))
                    
                    self.ShowDriverCurent_marker(position:position )
                }
                GreenView_street_lbl.text = address
            }
        }
    }
    
}


extension HomeViewVC{

    func drawPath(origin:String,Destination:String)
    {
        if (self.appDelegate.manager?.isReachable)! == false
        {
            self.alert(message: "The network connection was lost.")
            return
        }
        
       
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(Destination)&mode=driving&key=AIzaSyB_ZHYKjHIDLFg8kVszyWicj3xear4TBZI"
        
        Alamofire.request(url).responseJSON { (response) in
            
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "status") as! String
                    if success == "OK"
                    {
                        if let dataArr:NSArray = JSON.object(forKey: "routes") as? NSArray
                        {
                            print(dataArr)
                            
                              self.GmapView.clear()
                            
                            self.CheckProductInfoCurrent { (current_Order_Info ) in
                                
                               
                                
                                let destination = current_Order_Info.driver_latitude + "," + current_Order_Info.driver_longitude
                                let origin = current_Order_Info.delivery_latitude + "," + current_Order_Info.delivery_longitude
                                
                                 self.driverPath(origin:origin , destination: destination)
                            }
                            
                           
                            
                            let dic = dataArr.object(at: 0) as! NSDictionary
                            print(dic)
                            
                            if let legs:NSArray = dic.object(forKey: "legs") as? NSArray
                            {
                                print(legs)
                                
                                let legsdic = legs.object(at: 0) as! NSDictionary
                                print(legsdic)
                                
                                
                                let start_location = legsdic.object(forKey: "start_location") as! NSDictionary
                                print(start_location)
                                
                                let myCustomView: MarkerSmallView = .instanceFromNibSmall(Marker_image: #imageLiteral(resourceName: "DriverMarkerWeed"), Window_image: #imageLiteral(resourceName: "DriverWindow"), MakerTitle: "", Window_title: "You")
                                
                                let positionstart = CLLocationCoordinate2D(latitude: start_location.object(forKey: "lat") as! CLLocationDegrees, longitude: start_location.object(forKey: "lng") as! CLLocationDegrees)
                                self.usrPosition = positionstart
                                self.GmapDiverMark = GMSMarker(position: positionstart)
                                self.GmapDiverMark.iconView = myCustomView
                                self.GmapDiverMark.tracksViewChanges = true
                                self.GmapDiverMark.map = self.GmapView
                                
                                
                                
                                
                                
                                
                                let end_location = legsdic.object(forKey: "end_location") as! NSDictionary
                                print(end_location)
                                
                                let myCustomView1: MarkerSmallView = .instanceFromNibSmall(Marker_image: #imageLiteral(resourceName: "ShopMarkerWeed"), Window_image:  #imageLiteral(resourceName: "ShopWindow"), MakerTitle: "", Window_title: "Shop")
                                
                                let positionEnd = CLLocationCoordinate2D(latitude: end_location.object(forKey: "lat") as! CLLocationDegrees, longitude: end_location.object(forKey: "lng") as! CLLocationDegrees)
                                self.ShopPosition = positionEnd
                                self.GmapShoprmarker = GMSMarker(position: positionEnd)
                                self.GmapShoprmarker.iconView = myCustomView1
                                self.GmapShoprmarker.tracksViewChanges = true
                                self.GmapShoprmarker.map = self.GmapView
                                
                                let distance = legsdic.object(forKey: "distance") as! NSDictionary
                                print(distance)
                                
                                let duration = legsdic.object(forKey: "duration") as! NSDictionary
                                print(duration)
                                
                                let end_address = createString(value: legsdic.object(forKey: "end_address") as AnyObject)
                                print(end_address)
                                let start_address = createString(value: legsdic.object(forKey: "start_address") as AnyObject)
                                print(start_address)
                                
                             
                                
                            }
                            
                            let overlayPolyline = dic.object(forKey: "overview_polyline") as! NSDictionary
                            print(overlayPolyline)
                            let point = createString(value: overlayPolyline.object(forKey: "points") as AnyObject)
                            print(point)
                            let path = GMSPath.init(fromEncodedPath: point)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 2.0
                            polyline.geodesic = true
                            polyline.strokeColor = .black
                            polyline.map = self.GmapView
                            
                            //                            let lat = Double(self.orderStatusMapData.delivery_latitude)
                            //                            let lon = Double(self.orderStatusMapData.delivery_longitude)
                            //                            let origin = CLLocationCoordinate2D.init(latitude: lat!, longitude: lon!)
                            //
                            //                            let lat1 = Double(self.orderStatusMapData.store_latitude)
                            //                            let lon1 = Double(self.orderStatusMapData.store_longitude)
                            //                            let destinationShop = CLLocationCoordinate2D.init(latitude: lat1!, longitude: lon1!)
                            //                            
                            //                            let bounds = GMSCoordinateBounds(coordinate: origin, coordinate: destinationShop)
                            //                            self.GmapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
                        }
                    }
                }
            case .failure(let error):
                print(error)
                
                self.alert(message: error.localizedDescription)
                break
            }
        }
        
    }
    func driverPath(origin:String,destination:String) -> Void
    {
        if (self.appDelegate.manager?.isReachable)! == false
        {
            self.alert(message: "The network connection was lost.")
            return
        }
//        
//        let origin = self.orderStatusMapData.store_latitude + "," + self.orderStatusMapData.store_longitude //"18.520,73.856"
//        let destination = self.orderStatusMapData.driver_latitude + "," + self.orderStatusMapData.driver_longitude
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=DRIVING&key=AIzaSyB_ZHYKjHIDLFg8kVszyWicj3xear4TBZI"
        
        Alamofire.request(url).responseJSON { (response) in
            
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "status") as! String
                    if success == "OK"
                    {
                        if let dataArr:NSArray = JSON.object(forKey: "routes") as? NSArray
                        {
                            print(dataArr)
                            
                          
                            let dic = dataArr.object(at: 0) as! NSDictionary
                            print(dic)
                            
                            if let legs:NSArray = dic.object(forKey: "legs") as? NSArray
                            {
                                print(legs)
                                
                                let legsdic = legs.object(at: 0) as! NSDictionary
                                print(legsdic)
                                
                                let start_location = legsdic.object(forKey: "start_location") as! NSDictionary
                                print(start_location)
                                
                                
                                let myCustomView: MarkerSmallView = .instanceFromNibSmall(Marker_image: #imageLiteral(resourceName: "DeliverMarkerWeed"), Window_image: #imageLiteral(resourceName: "DeliverWindow"), MakerTitle: "", Window_title: "Delivery")
                                
                                let positionstart = CLLocationCoordinate2D(latitude: start_location.object(forKey: "lat") as! CLLocationDegrees, longitude: start_location.object(forKey: "lng") as! CLLocationDegrees)
                                self.DeliverPosition = positionstart
                                self.GmapDrliverMark = GMSMarker(position: positionstart)
                                self.GmapDrliverMark.iconView = myCustomView
                                self.GmapDrliverMark.tracksViewChanges = true
                                self.GmapDrliverMark.map = self.GmapView
                                
//                                
//                                let end_location = legsdic.object(forKey: "end_location") as! NSDictionary
//                                print(end_location)
//                                
//                                let myCustomView1: MarkerSmallView = .instanceFromNibSmall(Marker_image: #imageLiteral(resourceName: "DriverMarkerWeed"), Window_image: #imageLiteral(resourceName: "DriverWindow"), MakerTitle: "A", Window_title: "You")
//                                
//                                let positionEnd = CLLocationCoordinate2D(latitude: end_location.object(forKey: "lat") as! CLLocationDegrees, longitude: end_location.object(forKey: "lng") as! CLLocationDegrees)
//                                self.usrPosition = positionEnd
//                                self.GmapDiverMark = GMSMarker(position: positionEnd)
//                                self.GmapDiverMark.iconView = myCustomView1
//                                self.GmapDiverMark.tracksViewChanges = true
//                                self.GmapDiverMark.map = self.GmapView
                                
                                let distance = legsdic.object(forKey: "distance") as! NSDictionary
                                print(distance)
                                
                                let duration = legsdic.object(forKey: "duration") as! NSDictionary
                                print(duration)
                                
                                let end_address = createString(value: legsdic.object(forKey: "end_address") as AnyObject)
                                print(end_address)
                                let start_address = createString(value: legsdic.object(forKey: "start_address") as AnyObject)
                                print(start_address)
                                
                                //                                let mapInsets = UIEdgeInsets(top: 50.0, left: 50.0, bottom: 120.0, right: 50.0)
                                //                                self.GmapView.padding = mapInsets
                                
                                //                                let vancouver = CLLocationCoordinate2D(latitude: start_location.object(forKey: "lat") as! CLLocationDegrees, longitude: start_location.object(forKey: "lng") as! CLLocationDegrees)
                                //                                let calgary = CLLocationCoordinate2D(latitude: end_location.object(forKey: "lat") as! CLLocationDegrees,longitude: end_location.object(forKey: "lng") as! CLLocationDegrees)
                                //                                let bounds = GMSCoordinateBounds(coordinate: vancouver, coordinate: calgary)
                                //                                let camera = self.GmapView.camera(for: bounds, insets: UIEdgeInsets())!
                                //                                self.GmapView.camera = camera
                                //
                                //                                CATransaction.begin()
                                //                                CATransaction.setValue(NSNumber.init(value: 2.0), forKey: kCATransactionAnimationDuration)
                                //                                self.GmapView.animate(to: camera)
                                //                                CATransaction.commit()
                            }
                            
                            
                            let overlayPolyline = dic.object(forKey: "overview_polyline") as! NSDictionary
                            print(overlayPolyline)
                            let point = createString(value: overlayPolyline.object(forKey: "points") as AnyObject)
                            print(point)
                            let path = GMSPath.init(fromEncodedPath: point)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 2.0
                            polyline.geodesic = true
                            polyline.strokeColor = UIColor.init(red: 43.0 / 255.0, green: 205.0 / 255.0, blue: 127.0 / 255.0, alpha: 1.0)
                            polyline.map = self.GmapView
                            
                            
                            self.CheckProductInfoCurrent { (current_Order_Info ) in
                                
                                let lat = Double(current_Order_Info.delivery_latitude)
                                let lon = Double(current_Order_Info.delivery_longitude)
                                let origin = CLLocationCoordinate2D.init(latitude: lat!, longitude: lon!)
                                
                                let lat1 = Double(current_Order_Info.store_latitude)
                                let lon1 = Double(current_Order_Info.store_longitude)
                                let destinationShop = CLLocationCoordinate2D.init(latitude: lat1!, longitude: lon1!)
                                
                                let lat2 = Double(current_Order_Info.driver_latitude)
                                let lon2 = Double(current_Order_Info.driver_longitude)
                                let destinationDriver = CLLocationCoordinate2D.init(latitude: lat2!, longitude: lon2!)
                                
                                var bounds = GMSCoordinateBounds(coordinate: origin, coordinate: destinationShop)
                                bounds = bounds.includingCoordinate(destinationDriver)
                                self.GmapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
                               
                                
                            }

                            
                           
                        }
                    }
                }
            case .failure(let error):
                print(error)
                
                self.alert(message: error.localizedDescription)
                break
            }
        }
    }



}

extension HomeViewVC{
    
    
    func ShowDriverCurent_marker(position: CLLocationCoordinate2D)  {
        
        
        
        let product_info = UserDefaults.Main.object(forKey: .product_info_notify)
        if product_info != nil
        {
            self.CheckProductInfoCurrent { (current_Order_Info ) in
                let origin = current_Order_Info.driver_latitude + "," + current_Order_Info.driver_longitude //"18.520,73.856"
                let destination = current_Order_Info.store_latitude + "," + current_Order_Info.store_longitude
                self.drawPath(origin:origin , Destination: destination)
            }
            
        }else{
            let myCustomView: MarkerSmallView = .instanceFromNibSmall(Marker_image: #imageLiteral(resourceName: "DriverMarkerWeed"), Window_image: #imageLiteral(resourceName: "DriverWindow"), MakerTitle: "A", Window_title: "You")
            self.GmapView.clear()
            GmapUserMark = GMSMarker(position: position)
            GmapUserMark.iconView = myCustomView
            GmapUserMark.tracksViewChanges = true
            GmapUserMark.map = GmapView
            let camera:GMSCameraPosition  = GMSCameraPosition.camera(withTarget: position, zoom: 12.0)
            self.GmapView.animate(to: camera)

        
        }
        
        

        
     
    }
    
    

}




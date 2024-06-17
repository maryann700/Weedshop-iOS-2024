//
//  Helper.swift
//  CommonClass
//
//  Created by Devubha Manek on 5/2/16.
//  Copyright © 2016 Devubha Manek. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SkyFloatingLabelTextField
import QuartzCore



//MARK: - Web Services Constant
struct WebURL {
    static let appkey:String = "582e7d442740f326cc32a5ade9ed92f1"
  //  static let baseURL:String = "http://project-demo-server.net/weed/api/"
   
//    static let baseURL:String = "http://greatlike.org/weed/api/"
    static let baseURL:String = "http://high5delivery.com/weed/api/"
    
   // Old base Url //"http://97.74.228.59/~demoserver/weed/api/"
    
    static let login:String = WebURL.baseURL + "driver_login.php"
    static let register:String = WebURL.baseURL + "driver_register.php"
    static let emailVerification:String = WebURL.baseURL + "driver_register_verification.php"
    static let resendEmail:String = WebURL.baseURL + "driver_resend_verification.php"
    static let DriverInfo:String = WebURL.baseURL + "driver_info.php"
    static let forgotPassword:String = WebURL.baseURL + "driver_forgot.php"
    static let isDriverIDUpload:String = WebURL.baseURL + "driver_id_upload.php"
    static let update_driver_location:String = WebURL.baseURL + "update_driver_location.php"
    static let driver_get_order_request:String = WebURL.baseURL + "driver_get_order_request.php"
    static let driver_request_action:String = WebURL.baseURL + "driver_request_action.php"
    static let driver_current_order_detail:String = WebURL.baseURL + "driver_current_order_detail.php"
    static let driverOrderAction:String = WebURL.baseURL + "driver_order_action.php"
    static let driver_order_history:String = WebURL.baseURL + "driver_order_history.php"
    static let driver_profile:String = WebURL.baseURL + "driver_profile.php"
    static let driver_order_detail:String = WebURL.baseURL + "driver_order_detail.php"
    
    static let logout: String = WebURL.baseURL + "driver_logout.php"
    static let deviceTokenUpdate: String = WebURL.baseURL + "driver_device.php"
    
    static let appInReview: String = WebURL.baseURL + "appInReview.php"
}


extension UIColor{
    class func AppGreen() -> UIColor{
        return UIColor(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
    }
    class func AppSkyGreen() -> UIColor{
        return UIColor(red: 24.0 / 255.0, green: 199.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
    }
    class func AppGrey() -> UIColor{
        return UIColor(red: 227.0 / 255.0, green: 232.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    }
    
}

//MARK: - Device Type
enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case Phone
    case Pad
}
struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6PLUS      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

//MARK: - Screen Size
struct ScreenSize {
    static let WIDTH         = UIScreen.main.bounds.size.width
    static let HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.WIDTH, ScreenSize.HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.WIDTH, ScreenSize.HEIGHT)
}

//MARK: - Font Layout
struct FontName {
    //Font Name List
    static let HelveticaNeueBoldItalic = "HelveticaNeue-BoldItalic"
    static let HelveticaNeueLight = "HelveticaNeue-Light"
    static let HelveticaNeueUltraLightItalic = "HelveticaNeue-UltraLightItalic"
    static let HelveticaNeueCondensedBold = "HelveticaNeue-CondensedBold"
    static let HelveticaNeueMediumItalic = "HelveticaNeue-MediumItalic"
    static let HelveticaNeueThin = "HelveticaNeue-Thin"
    static let HelveticaNeueMedium = "HelveticaNeue-Medium"
    static let HelveticaNeueThinItalic = "HelveticaNeue-ThinItalic"
    static let HelveticaNeueLightItalic = "HelveticaNeue-LightItalic"
    static let HelveticaNeueUltraLight = "HelveticaNeue-UltraLight"
    static let HelveticaNeueBold = "HelveticaNeue-Bold"
    static let HelveticaNeue = "HelveticaNeue"
    static let HelveticaNeueCondensedBlack = "HelveticaNeue-CondensedBlack"
    static let SatteliteRegular = "Satellite"
    static let SatteliteOblique = "Satellite-Oblique"
}
func setFontLayout(strFontName:String,fontSize:CGFloat) -> UIFont {
    //Set auto font size in different devices.
    return UIFont(name: strFontName, size: (ScreenSize.WIDTH / 375) * fontSize)!
}
//MARK: - Set Color Method
func setColor(r: Float, g: Float, b: Float, aplha: Float)-> UIColor {
  return UIColor(red: CGFloat(Float(r / 255.0)), green: CGFloat(Float(g / 255.0)) , blue: CGFloat(Float(b / 255.0)), alpha: CGFloat(aplha))
}

//MARK: - check string nil
func createString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Int = value as? Int
    {
        returnString = String.init(format: "%d", str)
    }
    
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}

//MARK: - check string nil
func createFloatToString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Float = value as? Float
    {
        returnString = String.init(format: "%.2f", str)
    }
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}
func createDoubleToString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Float = value as? Float
    {
        returnString = String.init(format: "%f", str)
    }
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}
//MARK: - check string nil
func createIntToString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Int = value as? Int
    {
        returnString = String.init(format: "%d", str)
    }
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}
func creatArray(value: AnyObject) -> NSMutableArray
{
    var tempArray = NSMutableArray()
 
    if let arrData: NSArray = value as? NSArray
    {
        tempArray = NSMutableArray.init(array: arrData)
    }
    else if let _: NSNull = value as? NSNull
    {
        tempArray = NSMutableArray.init()
    }
    
    return tempArray
}

func creatDictnory(value: AnyObject) -> NSMutableDictionary
{
    var tempDict = NSMutableDictionary()
    
    if let DictData: NSDictionary = value as? NSDictionary
    {
        tempDict = NSMutableDictionary.init()
        tempDict.addEntries(from:DictData as! [AnyHashable : Any])
    }
    else if let _: NSNull = value as? NSNull
    {
        tempDict = NSMutableDictionary.init()
    }
    
    return tempDict
}
//MARK: - Scaling
struct DeviceScale {
    static let SCALE_X = ScreenSize.WIDTH / 375.0
    static let SCALE_Y = ScreenSize.HEIGHT / 667.0
}

//MARK: - Helper Class
class Helper {
//MARK: - Shared Instance
    static let sharedInstance : Helper = {
        let instance = Helper()
        return instance
    }()

    static let isDevelopmentBuild:Bool = true
    
//MARK: - MBProgressHUD
//    var mbProgressHud:MBProgressHUD!
//    func showHud()  {
//        mbProgressHud = MBProgressHUD.showAdded(to: ((UIApplication.shared.delegate?.window)!)!, animated: true)
//        mbProgressHud.label.text = "Please wait..."
//    }
//    func hideHud() {
//        if mbProgressHud != nil {
//            mbProgressHud.hide(animated: true)
//        }
//    }
//MARK: - User Details
//    func isUserLogin() -> Bool {
//
//        if let strLoginStatus:String = UserDefaults.Main.string(forKey: .isUserLogin) {
//            let status:String = strLoginStatus
//            if  status == "YES" {
//                return true
//            }
//        }
//        return false
//    }
//    func getUserInfo(key: String) -> String {
//        
//        if let dictUserInfo:NSDictionary = UserDefaults.Main.object(forKey: .UserInfo) as! NSDictionary? {
//            if let strValue = dictUserInfo.value(forKey: key) {
//                return "\(strValue)"
//            }
//        }
//        return ""
//    }
//MARK: - Convert Second TO Hours,Minutes and Seconds
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
//MARK: - Add zero before single digit
    func addZeroBeforeDigit(number: Int) -> String {
        return ((number > 9) ? (String.init(format: "%d", number)) : (String.init(format: "0%d", number)))
    }
}
//MARK: - UILabel Extension
extension UILabel {
    //Set line spacing between two lines.
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, text.characters.count))
            self.attributedText = attributeString
        }
    }
    //Set notification counter with dynamic width calculate
    func setNotificationCounter(counter: String) {
        if counter.length == 0 {
            self.isHidden = true
        }
        else {
            self.isHidden = false
            let strCounter:String = ":\(counter)|"
            
            self.clipsToBounds = true
            self.layer.cornerRadius = self.frame.size.height / 2.0
            
            let string_to_color1 = ":"
            let range1 = (strCounter as NSString).range(of: string_to_color1)
            let attributedString1 = NSMutableAttributedString(string:strCounter)
            attributedString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.clear , range: range1)
            
            let string_to_color2 = "|"
            let range2 = (strCounter as NSString).range(of: string_to_color2)
            attributedString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.clear , range: range2)
            self.attributedText = attributedString1
        }
    }
    //Get notification counter
    func getNotificationCounter() -> String {
        if self.text?.length == 0 {
            return ""
        }
        else {
            var strCounter = self.text
            strCounter = strCounter?.replacingOccurrences(of: ":", with: "")
            strCounter = strCounter?.replacingOccurrences(of: "|", with: "")
            return strCounter!
        }
    }
    //Get dynamic height
    func requiredHeight() -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.frame.width, height : CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.height
    }
    //Get dynamic width
    func requiredWidth() -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.frame.width,height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.width
    }
}
//Get dynamic label width
func widthForLabel(label:UILabel,text:String) ->CGFloat
{
    let fontName = label.font.fontName;
    let fontSize = label.font.pointSize;
    
    let attributedText = NSMutableAttributedString(string: text,attributes: [NSFontAttributeName:UIFont(name: fontName,size: fontSize)!])
    let rect: CGRect = attributedText.boundingRect(with: CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
    
    return ceil(rect.size.width)
}
//MARK: - UIApplication Extension
extension UIApplication {
    class func topViewController(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(viewController: presented)
        }
//        if let slide = viewController as? SlideMenuController {
//            return topViewController(viewController: slide.mainViewController)
//        }
        return viewController
    }
}
//MARK: - String Extension
extension String {
    //Get string length
    var length: Int { return characters.count    }  // Swift 2.0
    
    //Remove white space in string
    func removeWhiteSpace() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
//MARK: - NSString Extension
extension NSString {
    //Remove white space in string
    func removeWhiteSpace() -> NSString {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces) as NSString
    }
}
//MARK: - UISearchBar Class Modify
extension UISearchBar
{
    //UISearchBar Background Color
    /*func changeSearchBarColor(color : UIColor)
    {
        for subView in self.subviews
        {
            for subSubView in subView.subviews
            {
                if subSubView.conformsToProtocol(UITextInputTraits.self)
                {
                    let textField = subSubView as! UITextField
                    textField.backgroundColor = color
                
                    break
                }
            }
        }
    }*/
    //UISearchBar Change Search Icon Size
    /*func setSearchIconFrame(frame : CGRect)
    {
        for subView in self.subviews
        {
            for subSubView in subView.subviews
            {
                if subSubView.conformsToProtocol(UITextInputTraits.self)
                {
                    let textField = subSubView as! UITextField
                    
                    let imgSearchIcon = textField.leftView
                    imgSearchIcon?.frame = frame
                    break
                }
            }
        }
    }*/
    //UISearchBar Change TextField Size
    /*func setSearchTextFieldFrame(frame : CGRect)
    {
        for subView in self.subviews
        {
            for subSubView in subView.subviews
            {
                if subSubView.conformsToProtocol(UITextInputTraits.self)
                {
                    let textField = subSubView as! UITextField
                    textField.frame = frame
                    break
                }
            }
        }
    }*/
    //UISearchBar Text Color
    func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    //UISearchBar Set Font
    func setFont(font: UIFont) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.font = font
    }
    //UISearchBar Placeholder Text Color
    func setPlaceholderColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf .setValue(color, forKeyPath: "_placeholderLabel.textColor")
    }
}
//MARK: - Search from Array
/*func searchFromList(searchText:String, mainArray:AnyObject, key:String) -> AnyObject{
    var searchArray:[AnyObject]
    searchArray = []
    
    if searchText.length > 0 {
        if mainArray.count > 0 {
            let predicate = NSPredicate(format: "\(key) contains[c] %@", searchText)
            searchArray = mainArray.filteredArrayUsingPredicate(predicate)
            
        }
    }
    return searchArray as AnyObject
}*/

//#pragma mark - Create Thumbnail From image
//
//-(UIImage*)smallimageWithImage: (UIImage*) sourceImage
//{
//    int width = 0, height = 0;
//    
//    double y = sourceImage.size.height;
//    double x = sourceImage.size.width;
//    
//    if (sourceImage.size.height > 145 || sourceImage.size.width > 145)
//    {
//        if (sourceImage.size.height > sourceImage.size.width)
//        {
//            height = 145;
//            width = 0;
//        }
//        else
//        {
//            height = 0;
//            width = 145;
//        }
//    }
//    
//    double factor = 1;
//    if (width > 0)
//    {
//        factor = width / x;
//    }
//    else if (height > 0)
//    {
//        factor = height / y;
//    }
//    
//    float newHeight = y * factor;
//    float newWidth = x * factor;
//    
//    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
//    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}


//MARK: - Create thumbnail image
    func smallImageWithImage(sourceImage: UIImage) -> UIImage {
        var width:Int = 0
        var height:Int = 0
        let y = sourceImage.size.height
        let x = sourceImage.size.width
        
        if sourceImage.size.height > 175 || sourceImage.size.width > 175 {
            if sourceImage.size.height > sourceImage.size.width {
                height = 175
                width = 0
            }else {
                height = 0
                width = 175
            }
        }
        
        var factor:Double = 1.0
        if width > 0 {
            factor = (Double(width) / Double(x) ) as Double
        }
        else if height > 0 {
            factor = Double(height) / Double(y)
        }
        
        let newHeight = Double(y) * factor
        let newWidth = Double(x) * factor
        
        UIGraphicsBeginImageContext(CGSize(width : CGFloat(newWidth),height :  CGFloat(newHeight)))
        sourceImage.draw(in: CGRect(x : 0,y : 0,width : CGFloat(newWidth),height : CGFloat(newHeight)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

//MARK: - NSDate Extention for UTC date
extension NSDate {
    func getUTCFormateDate() -> String {
        let dateFormatter = DateFormatter()
        let timeZone = NSTimeZone(name: "UTC")
        dateFormatter.timeZone = timeZone as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self as Date)
    }
    
    func getSystemFormateDate() -> String {
        let dateFormatter = DateFormatter()
        let timeZone = NSTimeZone.system
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "dd/MM/yy hh:mma"
        return dateFormatter.string(from: self as Date)
    }
}
//MARK: - UIView Extension
extension UIView {

//MARK: - IBInspectable
    //Set Corner Radious
    @IBInspectable var cornerRadius:CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

   
    //Set Round
    @IBInspectable var Round:Bool {
        set {
            self.layer.cornerRadius = self.frame.size.height / 2.0
        }
        get {
            return self.layer.cornerRadius == self.frame.size.height / 2.0
        }
    }
    //Set Border Color 
    @IBInspectable var borderColor:UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    //Set Border Width
    @IBInspectable var borderWidth:CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    //Set Shadow in View
    func addShadowView(width:CGFloat=0.2, height:CGFloat=0.2, Opacidade:Float=0.7, maskToBounds:Bool=false, radius:CGFloat=0.5){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Opacidade
        self.layer.masksToBounds = maskToBounds
    }
    struct NLInnerShadowDirection: OptionSet {
        let rawValue: Int
        
        static let None = NLInnerShadowDirection(rawValue: 0)
        static let Left = NLInnerShadowDirection(rawValue: 1 << 0)
        static let Right = NLInnerShadowDirection(rawValue: 1 << 1)
        static let Top = NLInnerShadowDirection(rawValue: 1 << 2)
        static let Bottom = NLInnerShadowDirection(rawValue: 1 << 3)
        static let All = NLInnerShadowDirection(rawValue: 15)
    }
    
    func removeInnerShadow() {
        for view in self.subviews {
            if (view.tag == 2639) {
                view.removeFromSuperview()
                break
            }
        }
    }
    
    func addInnerShadow() {
        let c = UIColor()
        let color = c.withAlphaComponent(0.5)
        
        self.addInnerShadowWithRadius(radius: 3.0, color: color, inDirection: NLInnerShadowDirection.All)
    }
    
    func addInnerShadowWithRadius(radius: CGFloat, andAlpha: CGFloat) {
        let c = UIColor()
        let color = c.withAlphaComponent(alpha)
        
        self.addInnerShadowWithRadius(radius: radius, color: color, inDirection: NLInnerShadowDirection.All)
    }
    
    func addInnerShadowWithRadius(radius: CGFloat, andColor: UIColor) {
        self.addInnerShadowWithRadius(radius: radius, color: andColor, inDirection: NLInnerShadowDirection.All)
    }
    
    func addInnerShadowWithRadius(radius: CGFloat, color: UIColor, inDirection: NLInnerShadowDirection) {
        self.removeInnerShadow()
        
        let shadowView = self.createShadowViewWithRadius(radius: radius, andColor: color, direction: inDirection)
        
        self.addSubview(shadowView)
    }
    
    func createShadowViewWithRadius(radius: CGFloat, andColor: UIColor, direction: NLInnerShadowDirection) -> UIView {
        let shadowView = UIView(frame: CGRect(x: 0,y: 0,width: self.bounds.size.width,height: self.bounds.size.height))
        shadowView.backgroundColor = UIColor.clear
        shadowView.tag = 2639
        
        let colorsArray: Array = [ andColor.cgColor, UIColor.clear.cgColor ]
        
        if direction.contains(.Top) {
            let xOffset: CGFloat = 0.0
            let topWidth = self.bounds.size.width
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.startPoint = CGPoint(x:0.5,y: 0.0)
            shadow.endPoint = CGPoint(x:0.5,y: 1.0)
            shadow.frame = CGRect(x: xOffset,y: 0,width: topWidth,height: radius)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction.contains(.Bottom) {
            let xOffset: CGFloat = 0.0
            let bottomWidth = self.bounds.size.width
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.startPoint = CGPoint(x:0.5,y: 1.0)
            shadow.endPoint = CGPoint(x:0.5,y: 0.0)
            shadow.frame = CGRect(x:xOffset,y: self.bounds.size.height - radius, width: bottomWidth,height: radius)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction.contains(.Left) {
            let yOffset: CGFloat = 0.0
            let leftHeight = self.bounds.size.height
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.frame = CGRect(x:0,y: yOffset,width: radius,height: leftHeight)
            shadow.startPoint = CGPoint(x:0.0,y: 0.5)
            shadow.endPoint = CGPoint(x:1.0,y: 0.5)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction.contains(.Right) {
            let yOffset: CGFloat = 0.0
            let rightHeight = self.bounds.size.height
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.frame = CGRect(x:self.bounds.size.width - radius,y: yOffset,width: radius,height: rightHeight)
            shadow.startPoint = CGPoint(x:1.0,y: 0.5)
            shadow.endPoint = CGPoint(x:0.0,y: 0.5)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        return shadowView
    }
}
//MARK: - Bundle Information
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
//MARK: - MTViewController
class MTViewController : UIViewController
{
    //Outlet for auto resizing constraint constant set in different devices
    @IBOutlet var arrConstraint : [NSLayoutConstraint]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if arrConstraint != nil
        {
            //Auto resizing constraint constant set in different devices
            for const in arrConstraint {
                const.constant = const.constant * DeviceScale.SCALE_X
            }
        }
        
        
    }
    
    // MARK:- =======================================================
    // MARK: - Hex to UIcolor
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func alert(message: String) -> Void
    {
        let alert = UIAlertController.init(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        })
        alert.addAction(action)
        self.present(alert, animated: true) {
            
        }
    }
}




//MARK: - MTCollectionCell
class MTCollectionCell: UICollectionViewCell
{
    @IBOutlet var arrCellConstants: [NSLayoutConstraint]!
    override func awakeFromNib() {
     
        if arrCellConstants != nil
        {
            for const in arrCellConstants {
                const.constant = const.constant * DeviceScale.SCALE_X
            }
        }
    }
}

//MARK: - MTTableCell
class MTTableCell: UITableViewCell
{
    @IBOutlet var arrTableCellConstants: [NSLayoutConstraint]!
    override func awakeFromNib() {
        
        if arrTableCellConstants != nil
        {
            for const in arrTableCellConstants {
                const.constant = const.constant * DeviceScale.SCALE_X
            }
        }
        
    }
}



//MARK: - MTButtonTRanslation
class MTButtonTRanslation : TKTransitionSubmitButton
{
//    override func awakeFromNib() {
//        //Font size auto resizing in different devices
//        self.titleLabel?.font = self.titleLabel?.font.withSize((self.titleLabel?.font.pointSize)! * DeviceScale.SCALE_X)
//    }
}

//MARK: - MTButton
class MTButton : UIButton
{
//    override func awakeFromNib() {
//        //Font size auto resizing in different devices
//        self.titleLabel?.font = self.titleLabel?.font.withSize((self.titleLabel?.font.pointSize)! * DeviceScale.SCALE_X)
//    }
  
    /*
    //MARK: - Properties
    public var duration: Double = 0.5 {
        didSet {
            if duration <= 0 {
                duration = 0.5
            }
        }
    }
    public var initialAlpha: Double = 0.5 {
        didSet {
            if initialAlpha > 1.0 || initialAlpha < 0 {
                initialAlpha = 0.5
            }
        }
    }
    public var rippleColor: UIColor = UIColor.white
    
    /// The radius of the ripple is proportional with respect to this value. The ripple will just cover the button when the value is 1.0.
    public var sizeFactor: CGFloat = CGFloat(1.2) {
        didSet {
            if sizeFactor <= 0 {
                sizeFactor = CGFloat(1.2)
            }
        }
    }
    public var initalSizeFactor: CGFloat = CGFloat(0.1) {
        didSet {
            if initalSizeFactor <= 0 {
                initalSizeFactor = CGFloat(0.1)
            }
        }
    }
    private var shapeLayer = CAShapeLayer()
    
    //MARK: - Initializers
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.addTarget(self, action: #selector(animateRipple), for: UIControlEvents.touchDown)
    }
    
    //MARK: - Animation
    public func animateRipple() {
        if shapeLayer.superlayer != nil {
            shapeLayer.removeFromSuperlayer()
        }
        shapeLayer = CAShapeLayer()
        let center = CGPoint(x: bounds.width/2.0, y: bounds.height/2.0)
        let diagnolLength = sqrt(bounds.width*bounds.width + bounds.height*bounds.height)
        let path = UIBezierPath(arcCenter: center, radius: 0.5*diagnolLength*initalSizeFactor, startAngle: 0.0, endAngle: (CGFloat(360.0 * M_PI) / 180.0), clockwise: true)
        shapeLayer.path = path.cgPath
        shapeLayer.opacity = Float(initialAlpha)
        shapeLayer.fillColor = rippleColor.cgColor
        shapeLayer.strokeColor = rippleColor.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.frame = bounds
        layer.addSublayer(shapeLayer)
        
        let circleEnlargeAnimation = CABasicAnimation(keyPath: "transform.scale")
        circleEnlargeAnimation.fromValue = 1.0
        circleEnlargeAnimation.toValue = sizeFactor/initalSizeFactor
        circleEnlargeAnimation.duration = duration * 0.7
        circleEnlargeAnimation.fillMode = kCAFillModeForwards
        circleEnlargeAnimation.isRemovedOnCompletion = false
        circleEnlargeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let fadingOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadingOutAnimation.fromValue = initialAlpha
        fadingOutAnimation.toValue = 0.0
        fadingOutAnimation.duration = duration * 0.8
        fadingOutAnimation.beginTime = duration * 0.2
        fadingOutAnimation.fillMode = kCAFillModeForwards
        fadingOutAnimation.isRemovedOnCompletion = false
        fadingOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let group = CAAnimationGroup()
        group.animations = [circleEnlargeAnimation, fadingOutAnimation]
        group.duration = duration
        
        group.fillMode = kCAFillModeForwards
        group.isRemovedOnCompletion = false
        CATransaction.begin()
        shapeLayer.add(group, forKey: nil)
        CATransaction.commit()
    }

   */
}




//MARK: - MTLabel
class MTLabel : UILabel {
    override func awakeFromNib() {
        //Font size auto resizing in different devices
        self.font = self.font.withSize(self.font.pointSize * DeviceScale.SCALE_X)
    }
}

//MARK: - MTTextView
class MTTextView: UITextView
{
//    override open func awakeFromNib() {
//        self.font = self.font?.withSize((self.font?.pointSize)! * DeviceScale.SCALE_X)
//    }
}

//MARK: - MTTextField
class MTTextField: SkyFloatingLabelTextField
{
//    override open func awakeFromNib() {
//        self.font = self.font?.withSize((self.font?.pointSize)! * DeviceScale.SCALE_X)
//    }
}

class MTTextFieldSimple: UITextField
{
    override open func awakeFromNib() {
        self.font = self.font?.withSize((self.font?.pointSize)! * DeviceScale.SCALE_X)
    }
}
//MARK: - UITextfield Extension
extension UITextField {
    
   
    //Set placeholder font
    func setPlaceholderFont(font: UIFont) {
        let lblPlaceHolder:UILabel = self.value(forKey: "_placeholderLabel") as! UILabel
        lblPlaceHolder.font = font
    }
    //Set placeholder text color
//    func setPlaceholderTextColor(color: UIColor) {
//        let lblPlaceHolder:UILabel = self.value(forKey: "_placeholderLabel") as! UILabel
//        lblPlaceHolder.textColor = color
//    }
    
    
}
//MARK: - Protocol Oriented Programming Language
protocol Shakeable { }

extension Shakeable where Self: UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.03
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x:self.center.x - 4.0, y:self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x:self.center.x + 4.0, y:self.center.y))
        layer.add(animation, forKey: "position")
    }
}
class MTImageView: UIImageView, Shakeable {
    
}
//MARK: - NSMutableArray Extension
extension NSMutableArray {
    func shuffle () {
        for i in (0..<self.count).reversed() {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
}
//MARK : - UIColor Extension
extension UIColor {
    static var keyboardColor:UIColor {
        return UIColor(red: 26.0 / 255.0, green: 26.0 / 255.0, blue: 25.0 / 255.0, alpha: 1.0)
    }
}

// Dictionary Contains Value

extension Dictionary where Value: Equatable {
    func containsValue(value : Value) -> Bool {
        return self.contains { $0.1 == value }
    }
}



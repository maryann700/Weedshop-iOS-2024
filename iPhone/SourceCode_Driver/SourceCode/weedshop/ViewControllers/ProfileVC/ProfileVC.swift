 //
 //  ProfileVC.swift
 //  weedshop
 //
 //  Created by Devubha Manek on 27/03/17.
 //  Copyright © 2017 Devubha Manek. All rights reserved.
 //
 
 import UIKit
 import Alamofire
 import KRProgressHUD
 
 
 
 // MARK:- =======================================================
 // MARK: - UIViewController
 class ProfileVC: MTViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
 {
    
    // MARK:- =======================================================
    // MARK: - IBOutlet & Variables
    
    // Outlet
    
    @IBOutlet var lblTitle: MTLabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var viewBGMainTextFields: UIView!
    @IBOutlet var viewBGTextFields: UIView!
    @IBOutlet var btnEditProfile: UIControl!
    @IBOutlet var txtPhoneNumber: MTTextFieldSimple!
    @IBOutlet var txtEmail: MTTextFieldSimple!
    @IBOutlet var txtAddress: MTTextFieldSimple!
    @IBOutlet var txtCarNumber: MTTextFieldSimple!
    @IBOutlet var txtcarBrand: MTTextFieldSimple!
    @IBOutlet weak var txt_State_id: MTTextFieldSimple!
    
    @IBOutlet var circulerView: CircleProgressView!
    @IBOutlet var txtUserName: MTTextFieldSimple!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var btnCancel: UIControl!
    @IBOutlet var txtDOB: MTTextFieldSimple!
    @IBOutlet var viewName: UIView!
    @IBOutlet var viewPhoneNumber: UIView!
    @IBOutlet var viewEmail: UIView!
    @IBOutlet var viewAddress: UIView!
    @IBOutlet var viewStateCart: UIView!
    @IBOutlet var viewCarNumber: UIView!
    @IBOutlet var viewCarbrand: UIView!
    
    @IBOutlet var viewDatePicker: UIView!
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var lineName: UIView!
    @IBOutlet var linePhoneNumber: UIView!
    @IBOutlet var lineEmail: UIView!
    @IBOutlet var lineAddress: UIView!
    @IBOutlet var lineStateCard: UIView!
    @IBOutlet var lineCarNumber: UIView!
    @IBOutlet var lineCarBrand: UIView!
    
    @IBOutlet var imgEdit: UIImageView!
    @IBOutlet var imgRightArrow: UIImageView!
    
    @IBOutlet var circulerViewSecond: CircleView!
    @IBOutlet var imgProfileSecond: UIImageView!
    
    @IBOutlet var btnTransparent: UIControl!
    @IBOutlet var imgCamera: UIImageView!
    
    // Constant Outets
    @IBOutlet var contHeightBtnEdit: NSLayoutConstraint!
    @IBOutlet var contWeightBtnEdit: NSLayoutConstraint!
    @IBOutlet var constTopBtnEdit: NSLayoutConstraint!
    @IBOutlet var constTopProfileView: NSLayoutConstraint!
    @IBOutlet var constHeightProfileView: NSLayoutConstraint!
    @IBOutlet var constWeightProfileView: NSLayoutConstraint!
    @IBOutlet var constTralingProfileView: NSLayoutConstraint!
    @IBOutlet var constLeadingProfileView: NSLayoutConstraint!
    
    @IBOutlet var constwidthCirculerViewSecond: NSLayoutConstraint!
    @IBOutlet var constHeightCirculerViewSecond: NSLayoutConstraint!
    @IBOutlet var constHeightViewDatePicker: NSLayoutConstraint!
    @IBOutlet var constBottomTxtDOB: NSLayoutConstraint!
    @IBOutlet var constTopTxtDOB: NSLayoutConstraint!
    
    // Constant Variables
    var varcontHeightBtnEdit = NSLayoutConstraint()
    var varcontWeightBtnEdit = NSLayoutConstraint()
    var varconstTopBtnEdit = NSLayoutConstraint()
    var varconstTopProfileView = NSLayoutConstraint()
    var varconstHeightProfileView = NSLayoutConstraint()
    var varconstWeightProfileView = NSLayoutConstraint()
    var varconstTralingProfileView = NSLayoutConstraint()
    var varconstLeadingProfileView = NSLayoutConstraint()
    var varconstwidthCirculerViewSecond = NSLayoutConstraint()
    var varconstHeightCirculerViewSecond = NSLayoutConstraint()
    var varconstHeightViewDatePicker = NSLayoutConstraint()
    var varconstBottomTxtDOB = NSLayoutConstraint()
    var varconstTopTxtDOB = NSLayoutConstraint()
    
    // Variables
    var session = Session()
    var timer = Timer()
    
    var isEditClick: Bool = false
    var editBtnFrame = CGRect()
    var isSliderOpne: Bool = false
    var userProfileData = UserProfile()
    var userImage = UIImage()
    var isImageAvailable: Bool = false
    var birthDate: String = ""
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Initial Constraints
        varcontHeightBtnEdit.constant = contHeightBtnEdit.constant
        varcontWeightBtnEdit.constant = contWeightBtnEdit.constant
        varconstTopBtnEdit.constant = constTopBtnEdit.constant
        
        varconstTopProfileView.constant = constTopProfileView.constant
        varconstHeightProfileView.constant = constHeightProfileView.constant
        varconstWeightProfileView.constant = constWeightProfileView.constant
        varconstLeadingProfileView.constant = constLeadingProfileView.constant
        varconstTralingProfileView.constant = constTralingProfileView.constant
        
        varconstwidthCirculerViewSecond.constant = constwidthCirculerViewSecond.constant
        varconstHeightCirculerViewSecond.constant = constHeightCirculerViewSecond.constant
        
        // Set Date Picker Height 0 for Initial State
        varconstHeightViewDatePicker.constant = constHeightViewDatePicker.constant
        constHeightViewDatePicker.constant = 0
        
        // Set const for Birthdate Field
        varconstBottomTxtDOB.constant = constBottomTxtDOB.constant
        constBottomTxtDOB.constant = 10
        
        varconstTopTxtDOB.constant = constTopTxtDOB.constant
        constTopTxtDOB.constant = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC.setSliderClose), name: NSNotification.Name(rawValue: "SliderRemove"), object: nil)
        
        // Set Circuler View
        session = Session.init()
        session.state = kSessionStateStart
        session.startDate = NSDate() as Date!
        session.finishDate = nil
        
        self.view.isUserInteractionEnabled = false
        
        self.circulerView.timeLimit = 2.5
        self.circulerView.elapsedTime = 0;
        self.circulerView.tintColor = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        self.startTimer()
        self.setDefaultView()
        
        editBtnFrame = self.btnEditProfile.frame
        self.datePicker.maximumDate = Date.init()
        
        
        if UserDefaults.Main.object(forKey: .userProfile) != nil
        {
            let date = UserDefaults.Main.object(forKey: .userProfile) as! Data
            let productData = NSKeyedUnarchiver.unarchiveObject(with: date)
            print(productData!)
            
            let productType = productData.unsafelyUnwrapped as! UserProfile
            print(productType)
            
            self.userProfileData = productType
            self.setProfileData()
            self.getProfileData()
        }
        else
        {
            self.getProfileData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0;
        self.view.registerAsDodgeViewForMLInputDodger()
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
        
    }
    
    // MARK:- =======================================================
    // MARK: - Normal Methods
    
    // Set User Profile Date
    func setProfileData() -> Void
    {
        self.txtUserName.text = self.userProfileData.name
        
        if self.userProfileData.birthdate.characters.count > 0
        {
            self.birthDate = self.userProfileData.birthdate
            self.txtDOB.text = "DOB : " + self.convertDateString(dateString: self.userProfileData.birthdate, fromFormat: "yyyy-MM-dd", toFormat: "MMMM dd yyyy")
        }
        else
        {
            self.txtDOB.placeholder = "Please Enter Birthday"
        }
        
        if self.userProfileData.image.characters.count > 0
        {
            self.imgProfile.sd_setImage(with: URL.init(string: self.userProfileData.image_url), placeholderImage: UIImage.init(named: "profile-img"), options: .refreshCached)
            self.imgProfileSecond.sd_setImage(with: URL.init(string: self.userProfileData.image_url), placeholderImage: UIImage.init(named: "profile-img"), options: .refreshCached)
        }
        else
        {
            self.imgProfile.image = UIImage.init(named: "profile-img")
            self.imgProfileSecond.image = UIImage.init(named: "profile-img")
        }
        
        self.txtPhoneNumber.text = self.userProfileData.mobile
        self.txtEmail.text = self.userProfileData.email
        self.txtAddress.text = self.userProfileData.address
        self.txtCarNumber.text = self.userProfileData.car_number
        self.txtcarBrand.text = self.userProfileData.car_brand
        self.txt_State_id.text = self.userProfileData.identification_id
        
        self.view.layoutIfNeeded()
    }
    func setDefaultView()-> Void
    {
        btnEditProfile.layer.cornerRadius = (btnEditProfile.frame.size.width / 2) * DeviceScale.SCALE_X
        btnEditProfile.clipsToBounds = true
      //  self.scrollView.isUserInteractionEnabled = false
        self.lineName.alpha = 0
        self.linePhoneNumber.alpha = 0
        self.lineEmail.alpha = 0
        self.lineAddress.alpha = 0
        self.lineStateCard.alpha = 0
        self.lineCarNumber.alpha = 0
        self.lineCarBrand.alpha = 0
        
        self.txtUserName.isUserInteractionEnabled = false
        self.txtPhoneNumber.isUserInteractionEnabled = false
        self.txtDOB.isUserInteractionEnabled = false
        self.txtEmail.isUserInteractionEnabled = false
        self.txtAddress.isUserInteractionEnabled = false
        self.txtCarNumber.isUserInteractionEnabled = false
        self.txt_State_id.isUserInteractionEnabled = false
        self.txtcarBrand.isUserInteractionEnabled = false
        
        self.viewDatePicker.removeFromSuperview()
        self.txtDOB.inputView = self.viewDatePicker
        
        self.imgEdit.alpha = 1.0
        self.imgRightArrow.alpha = 0
        self.btnTransparent.alpha = 0
        self.imgCamera.alpha = 0
        self.btnCancel.alpha = 0
        
        self.imgProfileSecond.layer.cornerRadius =   self.imgProfileSecond.frame.size.width / 2
        self.imgProfile.layer.cornerRadius =   self.imgProfile.frame.size.width / 2
        self.imgProfileSecond.clipsToBounds = true
        self.imgProfile.clipsToBounds = true
        self.imgProfileSecond.layer.masksToBounds = true
        self.imgProfile.layer.masksToBounds = true
        
        
        self.setPlaceholderColor(textField: self.txtDOB!)
        self.setPlaceholderColor(textField: self.txtUserName!)
        self.setPlaceholderColor(textField: self.txtPhoneNumber!)
        self.setPlaceholderColor(textField: self.txtEmail!)
        self.setPlaceholderColor(textField: self.txtAddress!)
        self.setPlaceholderColor(textField: self.txtCarNumber!)
        self.setPlaceholderColor(textField: self.txtcarBrand!)
        self.setPlaceholderColor(textField: self.txt_State_id!)
        
        
    }
    
    // Set PlaceHolder Color
    func setPlaceholderColor(textField: MTTextFieldSimple) -> Void {
        
        textField .setValue(UIColor.init(colorLiteralRed: 131/255, green: 141/255, blue: 155/255, alpha: 1.0), forKeyPath: "_placeholderLabel.textColor")
    }
    

  
    
    
    // Set Method for make Profile View Editable
    func setEditView()-> Void
    {
        if isEditClick
        {
            
            guard (self.txtUserName.text?.characters.count)! > 0 else {
                self.alert(message: "Please Enter Your Name")
                return
            }
            guard (self.txtDOB.text?.characters.count)! > 0 else {
                self.alert(message: "Please Enter Birthdate")
                return
            }
            guard (self.txtPhoneNumber.text?.characters.count)! > 0 else {
                self.alert(message: "Please Enter Phone Number")
                return
            }
            guard (self.txtPhoneNumber.text?.characters.count)! > 9 else {
                self.alert(message: "Please Enter Valid Phone Number")
                return
            }
            guard (self.txtEmail.text?.characters.count)! > 0 else {
                self.alert(message: "Please Enter Email")
                return
            }
            guard (self.txtAddress.text?.characters.count)! > 0 else {
                self.alert(message: "Please Enter Address")
                return
            }
            
            self.setNonEditableView()
            
            if self.isImageAvailable == true
            {
                self.updateProfileWithImage()
            }
            else
            {
                self.updateProfileWithOutImage()
            }
            
        }
        else
        {
            self.setEditableView()
        }
    }
    
    // Set Profile View TextFields Editable
    func setEditableView()->Void
    {
        isEditClick = true
        self.scrollView.isUserInteractionEnabled = true
        self.txtUserName.isUserInteractionEnabled = true
        self.txtPhoneNumber.isUserInteractionEnabled = true
        self.txtEmail.isUserInteractionEnabled = true
        self.txtAddress.isUserInteractionEnabled = true
        self.txtDOB.isUserInteractionEnabled = true
        
        //        self.txtStateIDNumber.isUserInteractionEnabled = true
        //        self.txtMarijuanaCardNumber.isUserInteractionEnabled = true
        
        self.btnEditProfile.layer.cornerRadius = (self.contWeightBtnEdit.constant * DeviceScale.SCALE_X) / 2
        self.btnEditProfile.clipsToBounds = true
        
        
        self.contHeightBtnEdit.constant = self.contHeightBtnEdit.constant + 10
        self.contWeightBtnEdit.constant = self.contWeightBtnEdit.constant + 10
        self.constTopBtnEdit.constant = self.constTopBtnEdit.constant - 5
        self.constHeightProfileView.constant = self.constHeightProfileView.constant - 20
        self.constWeightProfileView.constant = self.constWeightProfileView.constant - 20
        
        self.constwidthCirculerViewSecond.constant = self.constwidthCirculerViewSecond.constant - 20
        self.constHeightCirculerViewSecond.constant = self.constHeightCirculerViewSecond.constant - 20
        
        constBottomTxtDOB.constant = 10
        constTopTxtDOB.constant = 7
        
        UIView.animate(withDuration: 1.0, animations: {
            
            self.lineName.alpha = 1.0
            self.linePhoneNumber.alpha = 1.0
            self.lineEmail.alpha = 1.0
            self.lineAddress.alpha = 1.0
            self.lineStateCard.alpha = 1.0
            self.lineCarNumber.alpha = 1.0
            self.lineCarBrand.alpha = 1.0
            self.imgEdit.alpha = 0
            self.imgRightArrow.alpha = 1.0
            self.btnTransparent.alpha = 0.4
            self.imgCamera.alpha = 1
            self.btnCancel.alpha = 1
            
            self.imgProfileSecond.frame = self.imgProfile.frame
            
            self.view.layoutIfNeeded()
        })
        
    }
    
    // Set Profile View TextFields NonEditable
    func setNonEditableView()->Void
    {
        isEditClick = false
      //  self.scrollView.isUserInteractionEnabled = false
        self.txtUserName.isUserInteractionEnabled = false
        self.txtPhoneNumber.isUserInteractionEnabled = false
        self.txtEmail.isUserInteractionEnabled = false
        self.txtAddress.isUserInteractionEnabled = false
        self.txtDOB.isUserInteractionEnabled = false
        self.txtCarNumber.isUserInteractionEnabled = false
        self.txtcarBrand.isUserInteractionEnabled = false
        self.txt_State_id.isUserInteractionEnabled = false
        
        self.contHeightBtnEdit.constant = self.varcontHeightBtnEdit.constant
        self.contWeightBtnEdit.constant = self.varcontWeightBtnEdit.constant
        constTopBtnEdit.constant = varconstTopBtnEdit.constant
        
        self.btnEditProfile.layer.cornerRadius = (self.contWeightBtnEdit.constant * DeviceScale.SCALE_X) / 2
        self.btnEditProfile.clipsToBounds = true
        
        self.constHeightProfileView.constant = self.varconstHeightProfileView.constant
        self.constWeightProfileView.constant = self.varconstWeightProfileView.constant
        
        self.constwidthCirculerViewSecond.constant = self.varconstwidthCirculerViewSecond.constant
        self.constHeightCirculerViewSecond.constant = self.varconstHeightCirculerViewSecond.constant
        
        constBottomTxtDOB.constant = 6
        constTopTxtDOB.constant = 0
        
        UIView.animate(withDuration: 1.0, animations:
            {
                self.lineName.alpha = 0
                self.linePhoneNumber.alpha = 0
                self.lineEmail.alpha = 0
                self.lineAddress.alpha = 0
                self.lineStateCard.alpha = 0
                self.lineCarNumber.alpha = 0
                self.lineCarBrand.alpha = 0
                self.imgEdit.alpha = 1.0
                self.imgRightArrow.alpha = 0
                self.btnTransparent.alpha = 0
                self.imgCamera.alpha = 0
                self.btnCancel.alpha = 0
                self.view.layoutIfNeeded()
        })
    }
    
    // MARK:- =======================================================
    
    // Set Circuler View Animation In Timer.
    func startTimer()-> Void
    {
        if !self.timer.isValid
        {
            if #available(iOS 10.0, *) {
                self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval.init(1), repeats: true, block: { (tick) in
                    
                    if self.circulerView.percent == 1
                    {
                        self.timer.invalidate()
                        self.view.isUserInteractionEnabled = true
                        self.circulerView.alpha = 0
                        self.circulerViewSecond.alpha = 1.0
                        self.circulerViewSecond.layer.borderWidth = 5.2
                        self.circulerViewSecond.layer.borderColor = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0).cgColor
                        self.circulerViewSecond.backgroundColor = .clear
                        self.btnTransparent.layer.cornerRadius = (self.btnTransparent.frame.width * DeviceScale.SCALE_X) / 2
                        
                    }
                    self.circulerView.elapsedTime = self.session.progressTime
                })
            } else {
                
               self.timer =   Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.updateTime),
                                     userInfo: nil,
                                     repeats: true)
            }
        }
    }
    
    func updateTime() -> Void
    {
        if self.circulerView.percent == 1
        {
            self.timer.invalidate()
            self.view.isUserInteractionEnabled = true
            self.circulerView.alpha = 0
            self.circulerViewSecond.alpha = 1.0
            self.circulerViewSecond.layer.borderWidth = 5.2
            self.circulerViewSecond.layer.borderColor = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0).cgColor
            self.circulerViewSecond.backgroundColor = .clear
            self.btnTransparent.layer.cornerRadius = (self.btnTransparent.frame.width * DeviceScale.SCALE_X) / 2
            
        }
        
        self.circulerView.elapsedTime = self.session.progressTime
    }
    // MARK:- =======================================================
    // MARK: - Date Methods
    
    func convertDateString(dateString : String!, fromFormat sourceFormat : String!, toFormat desFormat : String!) -> String {
        
        if dateString == "0000-00-00" {
           return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = sourceFormat
        let date = dateFormatter.date(from: dateString)
        if (date != nil)  {
            dateFormatter.dateFormat = desFormat
            return dateFormatter.string(from: date!)
        }else{
            return dateString
        
        }
    
        
        
        
        
    }
    
    
    // MARK:- =======================================================
    // MARK: - Service Methods
    
    func getProfileData() -> Void
    {
        if (appDelegate.manager?.isReachable)! == false
        {
            self.alert(message: "The network connection was lost.")
            return
        }
        var userID = ""
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            userID = UserDefaults.Main.string(forKey: .DriverID)
        }
        
        let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
        KRProgressHUD.show()
        
        ServiceClass.sharedInstance.getUserProfile(userID: userID, action: "list", dicData: Parameters()) { (profileDta, message) in
            
            KRProgressHUD.dismiss({
                if message.characters.count > 0
                {
                    self.alert(message: message)
                }
                
            })
            self.userProfileData = profileDta
            
            if self.userProfileData.image.characters.count > 0
            {
                self.imgProfile.sd_setImage(with: URL.init(string: self.userProfileData.image_url), placeholderImage: UIImage.init(named: "profile-img"), options: .refreshCached)
                self.imgProfileSecond.sd_setImage(with: URL.init(string: self.userProfileData.image_url), placeholderImage: UIImage.init(named: "profile-img"), options: .refreshCached)
            }
            else
            {
                self.imgProfile.image = UIImage.init(named: "profile-img")
                self.imgProfileSecond.image = UIImage.init(named: "profile-img")
            }
            
            
            let tempProfileDta = NSKeyedArchiver.archivedData(withRootObject: profileDta)
            UserDefaults.Main.set(tempProfileDta, forKey: .userProfile)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ProfileImageUpdate"), object: self)
            
            self.setProfileData()
        }
    }
    
    func updateProfileWithOutImage()
    {
        if (appDelegate.manager?.isReachable)! == false
        {
            self.alert(message: "The network connection was lost.")
            return
        }
        
        
        
        
        var userID = ""
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            userID = UserDefaults.Main.string(forKey: .DriverID)
        }
        
        let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
        KRProgressHUD.show()
        
        
        let parameters: Parameters = ["driver_id": userID, "action": "edit", "name": self.txtUserName.text!, "mobile": self.txtPhoneNumber.text!, "birthdate": birthDate, "address": self.txtAddress.text!]
        
        ServiceClass.sharedInstance.getUserProfile(userID: userID, action: "edit", dicData: parameters) { (profileDta, message) in
            
            KRProgressHUD.dismiss({
                if message.characters.count > 0
                {
                    self.alert(message: message)
                }
                else{
                    self.alert(message: "Profile Updated Successfully.")
                }
            })
            self.userProfileData = profileDta
            
            let tempProfileDta = NSKeyedArchiver.archivedData(withRootObject: profileDta)
            UserDefaults.Main.set(tempProfileDta, forKey: .userProfile)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ProfileImageUpdate"), object: self)
            self.setProfileData()
            
            
        }
    }
    func showAlert() -> Void
    {
        self.alert(message: "Profile Updated Successfully.")
    }
    
    func updateProfileWithImage() -> Void
    {
        if (appDelegate.manager?.isReachable)! == false
        {
            self.alert(message: "The network connection was lost.")
            return
        }
        
        if (self.txtPhoneNumber.text!.characters.count < 10)
        {
            self.alert(message: "Please Enter Valid Mobile Number")
            return
        }
        
        
        let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
        KRProgressHUD.show()
        
        var userID = ""
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            userID = UserDefaults.Main.string(forKey: .DriverID)
        }
        let parameters: Parameters = ["driver_id": userID, "action": "edit", "name": self.txtUserName.text!, "mobile": self.txtPhoneNumber.text!, "birthdate": birthDate, "address": self.txtAddress.text!]
        
        let url = URL(string:NSString.init(format: "%@",WebURL.driver_profile) as String)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(WebURL.appkey, forHTTPHeaderField: "APPKEY")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 600
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let imageData = UIImageJPEGRepresentation(self.userImage, 0.5)
            {
                multipartFormData.append(imageData, withName: "image", fileName: "file.png", mimeType: "image/png")
            }
            
            for (key, value) in parameters
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, with: urlRequest) { (encodingResult) in
            
            switch encodingResult
            {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    
                    
                    if let JSON:NSDictionary = response.result.value as? NSDictionary
                    {
                        print("JSON: \(JSON)")
                        let success = JSON.object(forKey: "response") as! String
                        if success == "true"
                        {
                            KRProgressHUD.dismiss({
                                self.perform(#selector(self.showAlert), with: self, afterDelay: 0.3)
                            })
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
                                    
                                    let profile = UserProfile.init(id: id, name: name, email: email, birthdate: birthdate, image: image, mobile: mobile, address: address, identification_id: identification_id,  car_number: car_number,  car_brand: car_brand,  image_url: image_url)
                                    
                                    self.userProfileData = profile
                                    
                                    let tempProfileDta = NSKeyedArchiver.archivedData(withRootObject: profile)
                                    UserDefaults.Main.set(tempProfileDta, forKey: .userProfile)
                                    UserDefaults.standard.synchronize()
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "ProfileImageUpdate"), object: self)
                                    
                                    self.setProfileData()
                                }
                            }
                        }
                        else
                        {
                            KRProgressHUD.dismiss({
                                self.alert(message: (JSON.object(forKey: "msg") as? String)!)
                            })
                        }
                    }
                    else
                    {
                        KRProgressHUD.dismiss({
                            self.alert(message: "Please try again")
                        })
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                KRProgressHUD.dismiss({
                    self.alert(message: encodingError.localizedDescription)
                })
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
    // Remove Transparent View on tap gesture
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
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ProfileImageUpdate"), object: self)
        
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
    
    @IBAction func btnCartTap(_ sender: Any)
    {
        
    }
    @IBAction func btnEditProfile(_ sender: Any)
    {
        (sender as AnyObject).layer.startAnimation(tintColor :UIColor.init(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0))
        self.setEditView()
    }
    
    @IBAction func btnTransparentTap(_ sender: Any)
    {
        (sender as AnyObject).layer.startAnimation(tintColor :UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0))
        
        let actionSheet = UIAlertController.init(title: "Profile Image", message: "Please Upload Your Profile Image", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let camera = UIAlertAction.init(title: "Camera", style: UIAlertActionStyle.default, handler: {
            (alert: UIAlertAction) -> Void in
            
            let imagePicker = UIImagePickerController.init()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController.init(title: "Alert", message: "Camera Not Available", preferredStyle: UIAlertControllerStyle.alert)
                let cancel = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.destructive, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                
            }
        })
        
        let photoLibrary = UIAlertAction.init(title: "Photo Library", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction) -> Void in
            
            let imagePicker = UIImagePickerController.init()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photoLibrary)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnCancelTap(_ sender: Any)
    {
        (sender as AnyObject).layer.startAnimation(tintColor :UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0))
        self.setNonEditableView()
    }
    
    @IBAction func dateValueChange(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        
        self.txtDOB.text = "DOB : " + strDate
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sendDate = dateFormatter.string(from: datePicker.date)
        birthDate = sendDate
    }
    
    
    // MARK:- =======================================================
    //MARK: - Textfield Delegate Method
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        OperationQueue.main.addOperation {() -> Void in
            UIMenuController.shared.setMenuVisible(false, animated: false)
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.txtDOB
        {
            textField.inputAccessoryView = toolbarInit()
            constHeightViewDatePicker.constant = varconstHeightViewDatePicker.constant
            UIView.animate(withDuration: 1.0, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: { (complete) in
                
            })
        }
        else
        {
            textField.inputAccessoryView = toolbarInit()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
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
        let previousButton:UIBarButtonItem! = UIBarButtonItem()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        previousButton.customView = self.prevNextSegment()
        toolBar.setItems([previousButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        return toolBar;
    }
    func prevNextSegment() -> UISegmentedControl
    {
        let prevNextSegment = UISegmentedControl()
        prevNextSegment.isMomentary = true
        prevNextSegment.tintColor = UIColor.init(patternImage: UIImage.init(named: "imgBG")!)
        let barbuttonFont = UIFont(name: "Roboto-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)
        prevNextSegment.setTitleTextAttributes([NSFontAttributeName: barbuttonFont, NSForegroundColorAttributeName:UIColor.clear], for: UIControlState.disabled)
        
        prevNextSegment.frame = CGRect(x: 0, y: 0, width: 130, height: 40)
        
        prevNextSegment.insertSegment(withTitle: "Previous", at: 0, animated: false)
        prevNextSegment.insertSegment(withTitle: "Next", at: 1, animated: false)
        
        prevNextSegment.addTarget(self, action: #selector(prevOrNext), for: UIControlEvents.valueChanged)
        return prevNextSegment;
    }
    
    func prevOrNext(_ segm: UISegmentedControl)
    {
        if (segm.selectedSegmentIndex == 1)
        {
            if txtUserName.isFirstResponder
            {
                txtUserName.resignFirstResponder()
                txtDOB.becomeFirstResponder()
            }
            else if txtDOB.isFirstResponder
            {
                txtDOB.resignFirstResponder()
                txtPhoneNumber.becomeFirstResponder()
            }
            else if txtPhoneNumber.isFirstResponder
            {
                txtPhoneNumber.resignFirstResponder()
                txtEmail.becomeFirstResponder()
            }
            else if txtEmail.isFirstResponder
            {
                txtEmail.resignFirstResponder()
                txtAddress.becomeFirstResponder()
            }
            else if txtAddress.isFirstResponder
            {
                txtAddress.resignFirstResponder()
                txtCarNumber.becomeFirstResponder()
            }
            else if txtCarNumber.isFirstResponder
            {
                txtCarNumber.resignFirstResponder()
                txtcarBrand.becomeFirstResponder()
            }
            else if txtcarBrand.isFirstResponder
            {
                txtcarBrand.resignFirstResponder()
                txt_State_id.becomeFirstResponder()
            }
        }
        else
        {
            if txtDOB.isFirstResponder
            {
                txtDOB.resignFirstResponder()
                txtUserName.becomeFirstResponder()
            }
            else if txt_State_id.isFirstResponder
            {
                txt_State_id.resignFirstResponder()
                txtcarBrand.becomeFirstResponder()
            }
                
            else if txtcarBrand.isFirstResponder
            {
                txtcarBrand.resignFirstResponder()
                txtCarNumber.becomeFirstResponder()
            }
            else if txtCarNumber.isFirstResponder
            {
                txtCarNumber.resignFirstResponder()
                txtAddress.becomeFirstResponder()
            }
            else if txtAddress.isFirstResponder
            {
                txtAddress.resignFirstResponder()
                txtEmail.becomeFirstResponder()
            }
            else if txtEmail.isFirstResponder
            {
                txtEmail.resignFirstResponder()
                txtPhoneNumber.becomeFirstResponder()
            }
        }
        
    }
    func resignKeyboard()
    {
        txtDOB.resignFirstResponder()
        txtUserName.resignFirstResponder()
        txtPhoneNumber.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtAddress.resignFirstResponder()
        txtCarNumber.resignFirstResponder()
        txtcarBrand.resignFirstResponder()
        txt_State_id.resignFirstResponder()
    }
    
    
    //MARK: =======================================================
    //MARK: UIImagePicker Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        userImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.isImageAvailable = true
        
        self.imgProfileSecond.image = userImage
        self.imgProfile.image = userImage
        
        picker.dismiss(animated: true, completion: {
            
            
        })
    }
    
 }

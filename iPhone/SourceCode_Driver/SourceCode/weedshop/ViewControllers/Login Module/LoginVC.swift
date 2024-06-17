//
//  LoginVC.swift
//  weedshop
//
//  Created by Devubha Manek on 23/02/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import KRProgressHUD

class LoginVC: MTViewController, UITextFieldDelegate, SegmentedProgressBarDelegate {

// MARK:- Autolayout Delegate
    
    @IBOutlet var constViewBackSignINSignUPBtn: NSLayoutConstraint!
    @IBOutlet var contForgotPassowrdBottom: NSLayoutConstraint!
    @IBOutlet var constBetweenUserNameAndPassword: NSLayoutConstraint!
    @IBOutlet var constTopBtnSignINSignUPViewSignUp: NSLayoutConstraint!
    
// MARK:- Sign In Screen Outle
    
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var viewUserName: UIView!
    @IBOutlet var viewPassword: UIView!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnForgotPassword: MTButton!
    @IBOutlet var btnSignUpBottomTap: MTButtonTRanslation!
    @IBOutlet var btnSignInBottom: MTButtonTRanslation!
    var btnLogin: TKTransitionSubmitButton!
    var varbtnLogin: TKTransitionSubmitButton!
    var btnSignUpTransition: TKTransitionSubmitButton!
    var varSignUpTransition: TKTransitionSubmitButton!

    
// MARK:- Sign Up Screen Outlet
    
    @IBOutlet var btnCheck: UIControl!
    @IBOutlet var viewSignUp: UIView!
    @IBOutlet var viewProgressBar1: UIView!
    @IBOutlet var viewProgressBar2: UIView!
    @IBOutlet var viewProgressBar3: UIView!
    @IBOutlet var btnSignInSignUpView: UIButton!
    @IBOutlet var btnSignUpSignUpView: UIButton!
    @IBOutlet var viewBackgroundScrollView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtZipCode: UITextField!
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var txtpasswordSignUp: UITextField!
    @IBOutlet var imgEye: UIImageView!
    @IBOutlet var imgCheckBox: UIImageView!
    
// MARK:- Variables
    
    var isSignUpViewSelected: Bool = false
    var isPasswordVisible: Bool = false
    var isCheckBoxChecked: Bool = false
    var appDelegate = AppDelegate()
    
    
// MARK:-   =======================================================
// MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setButtonsColor()
        self.setAllConstant()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
    }

    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
          self.btnForgotPassword.alpha = 1
        let signUp = UserDefaults.Main.bool(forKey: .isSignUp)
        if signUp == true
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationVC") as! EmailVerificationVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0;
        self.view.registerAsDodgeViewForMLInputDodger()
        
        UIApplication.shared.isStatusBarHidden = true
        isSignUpViewSelected = false
        self.btnSignInSignUpViewTap(self)
        
        
        self.setSingInButton()
        self.setSingUpButton()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.txtName.text = ""
        self.txtEmail.text = ""
        self.txtZipCode.text = ""
        self.txtMobileNo.text = ""
        self.txtPassword.text = ""
        self.txtUserName.text = ""
        self.txtpasswordSignUp.text = ""
        
        self.txtName.autocorrectionType = .no
        self.txtEmail.autocorrectionType = .no
        self.txtZipCode.autocorrectionType = .no
        self.txtMobileNo.autocorrectionType = .no
        self.txtPassword.autocorrectionType = .no
        self.txtUserName.autocorrectionType = .no
        self.txtpasswordSignUp.autocorrectionType = .no
        
        isCheckBoxChecked = false
        self.imgCheckBox.image = nil
        
        if DeviceType.IS_IPHONE_6PLUS || DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_5
        {
            self.scrollView.isScrollEnabled = false
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // Set Staus bar Style White
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
    
    
// MARK:- COmman Methods
    
    // Set SignIn Button For Fluid Animation
    func setSingInButton()->Void
    {
        btnLogin = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.btnSignInBottom.frame.size.width * DeviceScale.SCALE_X, height: self.btnSignInBottom.frame.size.height * DeviceScale.SCALE_Y))
        btnLogin.center = self.btnSignInBottom.center
        btnLogin.addTarget(self, action: #selector(LoginVC.btnSignBottomTap(_:)), for: UIControlEvents.touchUpInside)
        self.btnSignInBottom.addSubview(btnLogin)
       // self.view.bringSubview(toFront: self.btnSignInBottom)
    }
    
    // Set SignUp Button For Fluid Animation
    func setSingUpButton()->Void
    {
       
        btnSignUpTransition = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.btnSignUpBottomTap.frame.size.width * DeviceScale.SCALE_X, height: self.btnSignUpBottomTap.frame.size.height * DeviceScale.SCALE_Y))
         btnSignUpTransition.center = self.btnSignUpBottomTap.center
        btnSignUpTransition.addTarget(self, action: #selector(LoginVC.btnSignUpBottomTap(_:)), for: UIControlEvents.touchUpInside)
        self.btnSignUpBottomTap.addSubview(btnSignUpTransition)
    }
    
    // Set Progress Bar
    func setProgressBar()->Void
    {
        self.viewProgressBar1.alpha = 1
        self.viewProgressBar1.backgroundColor = .clear
        let spb = SegmentedProgressBar(numberOfSegments: 1, duration: 2)
        spb.frame = CGRect(x: 0, y: 0, width: 91.5 * DeviceScale.SCALE_X, height: 3.5 * DeviceScale.SCALE_Y)
        spb.delegate = self
        spb.topColor = UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
        spb.bottomColor = UIColor.clear
        self.viewProgressBar1.addSubview(spb)
        spb.startAnimation()

    }
    
    // Set TextField Corner Radious
    func setAllConstant() -> Void
    {
        if DeviceType.IS_IPHONE_5
        {
            constTopBtnSignINSignUPViewSignUp.constant = constTopBtnSignINSignUPViewSignUp.constant + 11
            constViewBackSignINSignUPBtn.constant = constViewBackSignINSignUPBtn.constant - 5
            contForgotPassowrdBottom.constant = contForgotPassowrdBottom.constant + 12
            constBetweenUserNameAndPassword.constant = constBetweenUserNameAndPassword.constant - 5
        }
        else if DeviceType.IS_IPHONE_4_OR_LESS
        {
            constViewBackSignINSignUPBtn.constant = constViewBackSignINSignUPBtn.constant
            contForgotPassowrdBottom.constant = contForgotPassowrdBottom.constant - 56
            constBetweenUserNameAndPassword.constant = constBetweenUserNameAndPassword.constant - 10
        }
        else if DeviceType.IS_IPHONE_6
        {
             constTopBtnSignINSignUPViewSignUp.constant = constTopBtnSignINSignUPViewSignUp.constant + 9
             constViewBackSignINSignUPBtn.constant = constViewBackSignINSignUPBtn.constant - 10
             contForgotPassowrdBottom.constant = contForgotPassowrdBottom.constant + 25
        }
        else if DeviceType.IS_IPHONE_6PLUS
        {
            constTopBtnSignINSignUPViewSignUp.constant = constTopBtnSignINSignUPViewSignUp.constant + 11.5
            constViewBackSignINSignUPBtn.constant = constViewBackSignINSignUPBtn.constant - 10
            contForgotPassowrdBottom.constant = contForgotPassowrdBottom.constant + 25
        }
        self.txtName.font = setFontLayout(strFontName: (self.txtName.font?.fontName)!, fontSize: (self.txtName.font?.pointSize)!)
    }
    
    // Set Initial Color for Button
    func setButtonsColor() -> Void
    {
        self.btnSignIn.setTitleColor(UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0), for: .normal)
        self.btnSignUp.setTitleColor(UIColor.white, for: .normal)
        
        self.imgCheckBox.layer.cornerRadius = self.btnCheck.frame.size.width / 2
        self.imgCheckBox.layer.borderColor = UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0).cgColor
        self.imgCheckBox.layer.borderWidth = 1.0
        
    }
    

// MARK:- =======================================================
// MARK: - Segmented ProgressBar Delegate

    func segmentedProgressBarChangedIndex(index: Int)
    {
        print("Now showing index: \(index)")
    }
    
    func segmentedProgressBarFinished() {
        print("Finished!")
    }
    
   
// MARK:- ======================================================
// MARK: UIViewControllerTransitioningDelegate

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

    
    
// MARK:- =======================================================
// MARK: - SignIn View Functions
    
// MARK:- Action Methods
    
    
    @IBAction func btnSignBottomTap(_ sender: TKTransitionSubmitButton) {
        
        guard (txtUserName.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txtUserName as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Please Enter Email"
            }
            return
        }
        guard self.isValidEmail(testStr: txtUserName.text!) else
        {
            if let floatingLabelTextField = txtUserName as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Please Enter Valid Email"
            }
            return
        }
        guard (txtPassword.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txtPassword as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Please Enter Password"
            }
            return
        }
        
        txtUserName.resignFirstResponder()
        txtPassword.resignFirstResponder()
        
      //  varbtnLogin = sender
       // varbtnLogin.startLoadingAnimation()
        
        let view = UIView.init(frame: self.view.frame)
        view.backgroundColor = .clear
        view.tag = 10000
        self.view.addSubview(view)
        
        
        let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
        KRProgressHUD.show()
       
        let parameters: Parameters = ["email": self.txtUserName.text!,"password": self.txtPassword.text!]
        
        Alamofire.request(WebURL.login, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            
            
            KRProgressHUD.dismiss({
                
                
                let getView = self.view .viewWithTag(10000)
                getView?.removeFromSuperview()
                
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
                                
                                let inf  = driverInfo.init(id: id, name: name, email: email, password: password, zipcode: zipcode, mobile: mobile, verification_code: verification_code, identification_id: identification_id, identification_photo: identification_photo, created_date: created_date, token: token, status: status, adminRejectReason: adminRejectReason, adminApproved: adminApproved, address: address, birthdate: birthdate , car_brand: car_brand , car_document: car_document, car_number: car_number  , image: image, verifymsg: verifymsg)
                                
                                self.appDelegate.DriverInfo = inf
                                
                                self.txtName.text = ""
                                self.txtEmail.text = ""
                                self.txtZipCode.text = ""
                                self.txtMobileNo.text = ""
                                self.txtPassword.text = ""
                                self.txtUserName.text = ""
                                self.txtpasswordSignUp.text = ""
                                
                                self.btnForgotPassword.alpha = 0
                                let driverInfo1 = NSKeyedArchiver.archivedData(withRootObject: inf)
                                UserDefaults.Main.set(driverInfo1, forKey: .driverInfo)
                                UserDefaults.Main.set(id, forKey: .DriverID)
                                
                                self.appDelegate.updateDeviceToken()
                                
                                if inf.driver_identification_photo.characters.count > 0 && inf.driver_car_document.characters.count > 0 && inf.driver_adminApproved == "Approved"
                                {
                                    UserDefaults.Main.set(true, forKey: .isLogin)
                                    UserDefaults.standard.synchronize()
                                    // self.varbtnLogin.startFinishAnimation(0.3, completion: {
                                    self.performSegue(withIdentifier: "SlideMenu", sender: self)
                                    // })
                                }
                                else if inf.driver_identification_photo.characters.count == 0
                                {
                                    
                                    
                                    UserDefaults.Main.set(true, forKey: .isSignUp)
                                    UserDefaults.Main.set(true, forKey: .isEmailVerify)
                                    UserDefaults.standard.synchronize()
                                    //  self.varbtnLogin.startFinishAnimation(0.3, completion: {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDsVerification") as! IDsVerification
                                    self.navigationController?.pushViewController(vc, animated: false)
                                    
                                    self.isSignUpViewSelected = false
                                    self.viewSignUp.alpha = 0
                                    // })
                                }
                                else if inf.driver_car_document.characters.count == 0
                                {
                                    UserDefaults.Main.set(true, forKey: .isSignUp)
                                    UserDefaults.Main.set(true, forKey: .isEmailVerify)
                                    UserDefaults.Main.set(true, forKey: .isIdCardVerify)
                                    UserDefaults.standard.synchronize()
                                    //  self.varbtnLogin.startFinishAnimation(0.3, completion: {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Car_Detail_ViewController") as! Car_Detail_ViewController
                                    self.navigationController?.pushViewController(vc, animated: false)
                                    
                                    self.isSignUpViewSelected = false
                                    self.viewSignUp.alpha = 0
                                    //})
                                }else if inf.driver_adminApproved != "Approved"{
                                    
                                    if  inf.driver_adminApproved == "Rejected"
                                    {
                                        if inf.driver_adminRejectReason == "Identification,Car"
                                        {
                                            
                                            UserDefaults.Main.set(true, forKey: .isSignUp)
                                            UserDefaults.Main.set(true, forKey: .isEmailVerify)
                                            UserDefaults.Main.set(false, forKey: .isIdCardVerify)
                                            UserDefaults.Main.set(false, forKey: .isCarVerify)

                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyProcessViewController") as! VerifyProcessViewController
                                            vc.reason = inf.driver_adminRejectReason
                                           // vc.message = inf.driver_verifymsg
                                            self.navigationController?.pushViewController(vc, animated: false)
                                            
                                            self.isSignUpViewSelected = false
                                            self.viewSignUp.alpha = 0

                                        }
                                        else if inf.driver_adminRejectReason == "Car"
                                        {
                                            UserDefaults.Main.set(true, forKey: .isSignUp)
                                            UserDefaults.Main.set(true, forKey: .isEmailVerify)
                                            UserDefaults.Main.set(false, forKey: .isIdCardVerify)
                                            UserDefaults.standard.synchronize()
                                            // self.varbtnLogin.startFinishAnimation(0.3, completion: {
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyProcessViewController") as! VerifyProcessViewController
                                            vc.reason = inf.driver_adminRejectReason
                                           // vc.message = inf.driver_verifymsg
                                            self.navigationController?.pushViewController(vc, animated: false)
                                            
                                            self.isSignUpViewSelected = false
                                            self.viewSignUp.alpha = 0

                                        }
                                        else if inf.driver_adminRejectReason == "Identification"
                                        {
                                            
                                            UserDefaults.Main.set(true, forKey: .isSignUp)
                                            UserDefaults.Main.set(true, forKey: .isEmailVerify)
                                            UserDefaults.Main.set(false, forKey: .isIdCardVerify)
                                            UserDefaults.standard.synchronize()
                                            // self.varbtnLogin.startFinishAnimation(0.3, completion: {
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyProcessViewController") as! VerifyProcessViewController
                                            vc.reason = inf.driver_adminRejectReason
                                            //vc.message = inf.driver_verifymsg
                                            self.navigationController?.pushViewController(vc, animated: false)
                                            
                                            self.isSignUpViewSelected = false
                                            self.viewSignUp.alpha = 0

                                        }
                                        else
                                        {
                                            UserDefaults.Main.set(true, forKey: .isSignUp)
                                            UserDefaults.Main.set(true, forKey: .isEmailVerify)
                                            UserDefaults.Main.set(true, forKey: .isIdCardVerify)
                                            UserDefaults.standard.synchronize()
                                            // self.varbtnLogin.startFinishAnimation(0.3, completion: {
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyProcessViewController") as! VerifyProcessViewController
                                            vc.reason = inf.driver_adminRejectReason
                                            //vc.message = inf.driver_verifymsg
                                            self.navigationController?.pushViewController(vc, animated: false)
                                            
                                            self.isSignUpViewSelected = false
                                            self.viewSignUp.alpha = 0

                                        }
                                        
                                    }
                                    else
                                    {
                                        UserDefaults.Main.set(true, forKey: .isSignUp)
                                        UserDefaults.Main.set(true, forKey: .isEmailVerify)
                                        UserDefaults.Main.set(true, forKey: .isIdCardVerify)
                                        UserDefaults.standard.synchronize()
                                        // self.varbtnLogin.startFinishAnimation(0.3, completion: {
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyProcessViewController") as! VerifyProcessViewController
                                        vc.reason = inf.driver_adminApproved
                                        self.navigationController?.pushViewController(vc, animated: false)
                                        
                                        self.isSignUpViewSelected = false
                                        self.viewSignUp.alpha = 0
                                    }
                                    
                                    // })
                                }else{
                                    
                                    print("other issues")
                                    
                                    //                                UserDefaults.Main.set(true, forKey: .isLogin)
                                    //                                UserDefaults.standard.synchronize()
                                    //                                self.varbtnLogin.startFinishAnimation(0.3, completion: {
                                    //                                    self.performSegue(withIdentifier: "SlideMenu", sender: self)
                                    //                                })
                                    
                                }
                                
                            }
                        }
                        else
                        {
                            let alert = UIAlertController.init(title: "Alert", message: JSON.object(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                            let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                                
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: {
                                //self.varbtnLogin.returnToOriginalState()
                            })
                        }
                    }
                    else
                    {
                        let alert = UIAlertController.init(title: "Alert", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                            
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: {
                            // self.varbtnLogin.returnToOriginalState()
                        })
                    }
                    break
                case .failure(let error):
                    print(error)
                    
                    let alert = UIAlertController.init(title: "Alert", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                        
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: {
                        //self.varbtnLogin.returnToOriginalState()
                    })
                    break
                }
            })
        })
    }

    @IBAction func btnSignIn(_ sender: Any)
    {
        self.btnSignIn.setTitleColor(UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0), for: .normal)
        self.btnSignUp.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func btnSignUp(_ sender: Any)
    {
        self.isSignUpViewSelected = true
        self.btnSignUp.setTitleColor(UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0), for: .normal)
        self.btnSignIn.setTitleColor(UIColor.white, for: .normal)
        
        self.btnSignUpSignUpView.setTitleColor(UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0), for: .normal)
        self.btnSignInSignUpView.setTitleColor(UIColor.white, for: .normal)
         self.resignKeyboard()
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations:
            {
                self.viewSignUp.alpha = 1.0})
        { (Bool) in
            
             self.setProgressBar()
        }
    }
    
    @IBAction func btnForgotPasswordTap(_ sender: Any)
    {
        
        if let floatingLabelTextField = self.txtUserName as? SkyFloatingLabelTextField
        {
            floatingLabelTextField.errorMessage = ""
        }
        if let floatingLabelTextField = self.txtPassword as? SkyFloatingLabelTextField
        {
            floatingLabelTextField.errorMessage = ""
        }
        
        self.txtName.text = ""
        self.txtEmail.text = ""
        self.txtZipCode.text = ""
        self.txtMobileNo.text = ""
        self.txtPassword.text = ""
        self.txtUserName.text = ""
        self.txtpasswordSignUp.text = ""
        self.resignKeyboard()
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
// MARK:- =======================================================
// MARK: Validations
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isPhoneNoValid(value: String) -> Bool{
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isValidPincode(value: String) -> Bool
    {
        if value.characters.count == 5 || value.characters.count == 6{
            return true
        }
        else{
            return false
        }
    }
    
// MARK:- =======================================================
// MARK: - SignUp View Functions
    
    // MARK: Action Methods
    
    @IBAction func btnSignUpBottomTap(_ sender: TKTransitionSubmitButton)
    {
        
        guard (txtName.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txtName as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Please Enter Name"
            }
            return
        }
        guard (txtEmail.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txtEmail as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Please Enter Email"
            }
            return
        }
        guard self.isValidEmail(testStr: txtEmail.text!) else
        {
            if let floatingLabelTextField = txtEmail as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Please Enter Valid Email"
            }
            return
        }
        guard (txtZipCode.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txtZipCode as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Please Enter ZipCode"
            }
            return
        }
        guard self.isValidPincode(value: txtZipCode.text!) else
        {
            if let floatingLabelTextField = txtZipCode as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Please Enter Valid ZipCode"
            }
            return
        }
        guard (txtMobileNo.text?.characters.count)! > 0  && (txtMobileNo.text?.characters.count)! <= 10 else
        {
            if let floatingLabelTextField = txtMobileNo as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Please Enter Mobile Number"
            }
            return
        }
        guard self.isPhoneNoValid(value: txtMobileNo.text!) else
        {
            if let floatingLabelTextField = txtMobileNo as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Please Enter Valid Mobile Number"
            }
            return
        }
        guard (txtpasswordSignUp.text?.characters.count)! >= 8 else
        {
            if let floatingLabelTextField = txtpasswordSignUp as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Password atleast 8 character"
            }
            return
        }
        if isCheckBoxChecked == false
        {
            let alert = UIAlertController.init(title: "Alert", message: "Please select terms & condition.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        txtName.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtZipCode.resignFirstResponder()
        txtMobileNo.resignFirstResponder()
        txtpasswordSignUp.resignFirstResponder()
        
       // varSignUpTransition = sender
      //  varSignUpTransition.startLoadingAnimation()
        
        let view = UIView.init(frame: self.view.frame)
        view.backgroundColor = .clear
        view.tag = 10000
        self.view.addSubview(view)
        let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
        KRProgressHUD.show()
        
        let parameters: Parameters = ["name": self.txtName.text!,"email": self.txtEmail.text!,"zipcode": self.txtZipCode.text!,"mobile": self.txtMobileNo.text!,"password": self.txtpasswordSignUp.text!]
        
        Alamofire.request(WebURL.register, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            
            let getView = self.view .viewWithTag(10000)
            getView?.removeFromSuperview()
            
           
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
                                 KRProgressHUD.dismiss({
                                let DriverID = NSString.init(format: "%@", dataDic.object(forKey: "id") as! CVarArg)
                                UserDefaults.Main.set(DriverID as String, forKey: .DriverID)
                                UserDefaults.Main.set(true, forKey: .isSignUp)
                                UserDefaults.standard.synchronize()
                                
                                self.txtName.text = ""
                                self.txtEmail.text = ""
                                self.txtZipCode.text = ""
                                self.txtMobileNo.text = ""
                                self.txtPassword.text = ""
                                self.txtUserName.text = ""
                                self.txtpasswordSignUp.text = ""
                                
                                self.appDelegate.updateDeviceToken()
                                    
                                // self.varSignUpTransition.startFinishAnimation(0.3, completion: {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationVC") as! EmailVerificationVC
                                self.navigationController?.pushViewController(vc, animated: false)
                                
                                self.isSignUpViewSelected = false
                                self.viewSignUp.alpha = 0
                                 })
                                
                                
                            }
                            else
                            {
                                KRProgressHUD.dismiss({})
                                let alert = UIAlertController.init(title: "Alert", message: JSON.object(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                                    
                                })
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: {
                                    // self.varSignUpTransition.returnToOriginalState()
                                })
                            }
                        }
                        else
                        {  KRProgressHUD.dismiss({})
                            let alert = UIAlertController.init(title: "Alert", message: JSON.object(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                            let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                                
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: {
                                // self.varSignUpTransition.returnToOriginalState()
                            })
                        }
                    }
                    else
                    {  KRProgressHUD.dismiss({})
                        let alert = UIAlertController.init(title: "Alert", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                            
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: {
                            // self.varSignUpTransition.returnToOriginalState()
                        })
                    }
                    break
                case .failure(let error):
                    print(error)
                      KRProgressHUD.dismiss({})
                    let alert = UIAlertController.init(title: "Alert", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                        
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: {
                        //self.varSignUpTransition.returnToOriginalState()
                    })
                    
                    break
                }
                
            
        
            
        })
    }
    
    @IBAction func btnSignInSignUpViewTap(_ sender: Any)
    {
        self.isSignUpViewSelected = false
        self.btnSignIn.setTitleColor(UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0), for: .normal)
        self.btnSignUp.setTitleColor(UIColor.white, for: .normal)
         self.resignKeyboard()
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations:
            {
                self.viewSignUp.alpha = 0
        })
        { (Bool) in
           
        }
    }
    @IBAction func btnSignUpSignUpViewTap(_ sender: Any)
    {
    }
    @IBAction func btnEyeTap(_ sender: Any)
    {
        if isPasswordVisible
        {
            isPasswordVisible = false
            self.txtpasswordSignUp.isSecureTextEntry = true
        }
        else
        {
            isPasswordVisible = true
            self.txtpasswordSignUp.isSecureTextEntry = false
        }
    }
    @IBAction func btnCheckBoxTap(_ sender: Any)
    {
        if isCheckBoxChecked
        {
            isCheckBoxChecked = false
            self.imgCheckBox.image = nil
        }
        else
        {
             isCheckBoxChecked = true
            self.imgCheckBox.image = UIImage.init(named: "checkBoxSelected")
        }
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
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField
        {
            floatingLabelTextField.errorMessage = ""
        }
        
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField
        {
            floatingLabelTextField.errorMessage = ""
        }
        
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
            if isSignUpViewSelected == true
            {
                if txtName.isFirstResponder
                {
                    txtName.resignFirstResponder()
                    txtEmail.becomeFirstResponder()
                }
                else if txtEmail.isFirstResponder
                {
                    if let floatingLabelTextField = txtEmail as? SkyFloatingLabelTextField
                    {
                        if self.isValidEmail(testStr: txtEmail.text!)
                        {
                            floatingLabelTextField.errorMessage = ""
                            txtEmail.resignFirstResponder()
                            txtZipCode.becomeFirstResponder()
                        }
                        else
                        {
                            floatingLabelTextField.errorMessage = "Please Enter Valid Email"
                            txtEmail.resignFirstResponder()
                            txtZipCode.becomeFirstResponder()
                        }
                    }
                }
                else if txtZipCode.isFirstResponder
                {
                    if let floatingLabelTextField = txtZipCode as? SkyFloatingLabelTextField
                    {
                        if self.isValidPincode(value: txtZipCode.text!)
                        {
                            floatingLabelTextField.errorMessage = ""
                            txtZipCode.resignFirstResponder()
                            txtMobileNo.becomeFirstResponder()
                        }
                        else
                        {
                            floatingLabelTextField.errorMessage = "Please Enter Valid ZipCode"
                            txtZipCode.resignFirstResponder()
                            txtMobileNo.becomeFirstResponder()
                        }
                    }
                   
                }
                else if txtMobileNo.isFirstResponder
                {
                    if let floatingLabelTextField = txtMobileNo as? SkyFloatingLabelTextField
                    {
                        if self.isPhoneNoValid(value: txtMobileNo.text!)
                        {
                            floatingLabelTextField.errorMessage = ""
                            txtMobileNo.resignFirstResponder()
                            txtpasswordSignUp.becomeFirstResponder()
                        }
                        else
                        {
                            floatingLabelTextField.errorMessage = "Please Enter Valid Mobile Number"
                            txtMobileNo.resignFirstResponder()
                            txtpasswordSignUp.becomeFirstResponder()
                        }
                    }
                }
                
            }
            else
            {
                if (txtUserName.isFirstResponder)
                {
                    txtUserName.resignFirstResponder()
                    txtPassword.becomeFirstResponder()
                }
                
            }
            
        }
        else
        {
            if isSignUpViewSelected == true
            {
                if txtpasswordSignUp.isFirstResponder
                {
                    txtpasswordSignUp.resignFirstResponder()
                    txtMobileNo.becomeFirstResponder()
                }
                else if txtMobileNo.isFirstResponder
                {
                    if let floatingLabelTextField = txtMobileNo as? SkyFloatingLabelTextField
                    {
                        if self.isPhoneNoValid(value: txtMobileNo.text!)
                        {
                            floatingLabelTextField.errorMessage = ""
                            txtMobileNo.resignFirstResponder()
                            txtZipCode.becomeFirstResponder()
                        }
                        else
                        {
                            floatingLabelTextField.errorMessage = "Please Enter Valid Mobile Number"
                            txtMobileNo.resignFirstResponder()
                            txtZipCode.becomeFirstResponder()
                        }
                    }
                }
                else if txtZipCode.isFirstResponder
                {
                    if let floatingLabelTextField = txtZipCode as? SkyFloatingLabelTextField
                    {
                        if self.isValidPincode(value: txtZipCode.text!)
                        {
                            floatingLabelTextField.errorMessage = ""
                            txtZipCode.resignFirstResponder()
                            txtEmail.becomeFirstResponder()

                        }
                        else
                        {
                            floatingLabelTextField.errorMessage = "Please Enter Valid ZipCode"
                            txtZipCode.resignFirstResponder()
                            txtEmail.becomeFirstResponder()
                        }
                    }
                }
                else if txtEmail.isFirstResponder
                {
                    if let floatingLabelTextField = txtEmail as? SkyFloatingLabelTextField
                    {
                        if self.isValidEmail(testStr: txtEmail.text!)
                        {
                            floatingLabelTextField.errorMessage = ""
                            txtEmail.resignFirstResponder()
                            txtName.becomeFirstResponder()
                        }
                        else
                        {
                            floatingLabelTextField.errorMessage = "Please Enter Valid Email"
                            txtEmail.resignFirstResponder()
                            txtName.becomeFirstResponder()
                        }
                    }
                }
            }
            else
            {
                if (txtPassword.isFirstResponder)
                {
                    txtPassword.resignFirstResponder()
                    txtUserName.becomeFirstResponder()
                }
            }
        }
    }
    
    func resignKeyboard()
    {
        txtName.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtZipCode.resignFirstResponder()
        txtMobileNo.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtUserName.resignFirstResponder()
        txtpasswordSignUp.resignFirstResponder()
    }
    
    
    
    
}

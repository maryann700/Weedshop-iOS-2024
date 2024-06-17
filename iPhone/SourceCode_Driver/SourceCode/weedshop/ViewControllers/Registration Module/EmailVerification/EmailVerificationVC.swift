//
//  EmailVerificationVC.swift
//  weedshop
//
//  Created by Devubha Manek on 28/02/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import KRProgressHUD


class EmailVerificationVC: MTViewController, UITextFieldDelegate, SegmentedProgressBarDelegate
{
    
    //MARK: =======================================================
    //MARK: Constants
    @IBOutlet var constLblEnterBottom: NSLayoutConstraint!
    @IBOutlet var constLblTralingSpace: NSLayoutConstraint!
    @IBOutlet var constLblLeadingSpace: NSLayoutConstraint!
    @IBOutlet var constToplblPleaseCheck: NSLayoutConstraint!
    @IBOutlet var txtVerificationCode: MTTextField!
    @IBOutlet var btnResendVarifiacationCode: MTButtonTRanslation!
    
    @IBOutlet var btnSubmit: MTButtonTRanslation!
    @IBOutlet var viewProgress1: UIView!
    @IBOutlet var viewProgress2: UIView!
    @IBOutlet var viewProgress3: UIView!
    @IBOutlet var viewProgress4: UIView!
    
    var btnSubmitTransition: TKTransitionSubmitButton!
    var varbtnSubmit: TKTransitionSubmitButton!
    
    var btnResendEmail: TKTransitionSubmitButton!
    var varResendEmail: TKTransitionSubmitButton!
    
    var resendTimer = Timer()
    var leftTime: Int = 0
    
    //MARK: =======================================================
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        leftTime = 60
        
        let emailVerify = UserDefaults.Main.bool(forKey: .isEmailVerify)
        if emailVerify == true
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDsVerification") as! IDsVerification
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0;
        self.view.registerAsDodgeViewForMLInputDodger()
        self.setProgressBar()
        self.setSingInButton()
        
//        if #available(iOS 10.0, *)
//        {
//            resendTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval.init(1), repeats: true, block: { (tick) in
//
//                self.leftTime = self.leftTime - 1
//                self.btnResendVarifiacationCode.setTitle(String.init(format: "Resend Verification code after %d Second.", self.leftTime), for: .normal)
//
//                self.btnResendVarifiacationCode.isUserInteractionEnabled = false
//
//                if self.leftTime <= 1
//                {
                    self.btnResendVarifiacationCode.isUserInteractionEnabled = true
                    self.btnResendVarifiacationCode.setTitle("Resend Verification Code.", for: .normal)
                    self.btnResendVarifiacationCode.titleLabel?.textAlignment = .center
//                    self.resendTimer.invalidate()
//                }
//            })
//        } else {
//            
//            resendTimer = Timer.scheduledTimer(timeInterval: TimeInterval.init(1), target: self, selector: #selector(self.TimerCalled(timer:)), userInfo: ["leftTime": self.leftTime], repeats: false)
//        }
    }
    
    
    func TimerCalled(timer:Timer)  {
        
        let userinfo = timer.userInfo as! NSDictionary
        
        self.leftTime = userinfo.value(forKey: "leftTime") as! Int
        self.leftTime = self.leftTime - 1
        self.btnResendVarifiacationCode.setTitle(String.init(format: "Resend Verification code after %d Second.", self.leftTime), for: .normal)
        
        self.btnResendVarifiacationCode.isUserInteractionEnabled = false
        
        if self.leftTime <= 1
        {
            self.btnResendVarifiacationCode.isUserInteractionEnabled = true
            self.btnResendVarifiacationCode.setTitle("Resend Verification Code.", for: .normal)
            self.btnResendVarifiacationCode.titleLabel?.textAlignment = .center
            self.resendTimer.invalidate()
        }else{
            resendTimer.invalidate()
            resendTimer = Timer.scheduledTimer(timeInterval: TimeInterval.init(1), target: self, selector: #selector(self.TimerCalled(timer:)), userInfo: ["leftTime": self.leftTime], repeats: false)
            
        }
    }
    
    // Set SignIn Button For Fluid Animation
    func setSingInButton()->Void
    {
        btnSubmitTransition = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.btnSubmit.frame.size.width * DeviceScale.SCALE_X, height: self.btnSubmit.frame.size.height * DeviceScale.SCALE_Y))
        btnSubmitTransition.center = self.btnSubmit.center
        btnSubmitTransition.addTarget(self, action: #selector(EmailVerificationVC.btnSubmitTap(_:)), for: UIControlEvents.touchUpInside)
        self.btnSubmit.addSubview(btnSubmitTransition)
        
        btnResendEmail = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.btnSubmit.frame.size.width * DeviceScale.SCALE_X, height: self.btnSubmit.frame.size.height * DeviceScale.SCALE_Y))
        btnResendEmail.center = self.btnSubmit.center
        btnResendEmail.addTarget(self, action: #selector(EmailVerificationVC.btnResendVarificationCodeTap(_:)), for: UIControlEvents.touchUpInside)
        self.btnResendVarifiacationCode.addSubview(btnSubmitTransition)
        
    }
    
    // Set Progress Bar
    func setProgressBar()->Void
    {
        self.viewProgress1.alpha = 1.0
        self.viewProgress1.backgroundColor = UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
        
        // self.viewProgress2.frame = self.viewProgress1.frame
        
        let spb = SegmentedProgressBar(numberOfSegments: 1, duration: 2)
        spb.frame = CGRect(x: 0, y: 0, width: 91.5 * DeviceScale.SCALE_X, height: DeviceType.IS_IPHONE_6PLUS ? 3.5 * DeviceScale.SCALE_Y : DeviceType.IS_IPHONE_6 ? 4 * DeviceScale.SCALE_Y : DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS ? 4 * DeviceScale.SCALE_Y : 4 * DeviceScale.SCALE_Y)
        spb.delegate = self
        spb.topColor = UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
        spb.bottomColor = UIColor.clear
        self.viewProgress2.addSubview(spb)
        spb.startAnimation()
        
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
    
    
    //MARK: =======================================================
    //MARK: Action Methods
    
    
    @IBAction func btnResendVarificationCodeTap(_ sender: TKTransitionSubmitButton)
    {
        self.btnResendVarifiacationCode.setTitle("Resend Verification Code.", for: .normal)
        self.btnResendVarifiacationCode.titleLabel?.textAlignment = .center
        
        
        // varResendEmail = sender
        //  varResendEmail.startLoadingAnimation()
        
        let view = UIView.init(frame: self.view.frame)
        view.backgroundColor = .clear
        view.tag = 10000
        self.view.addSubview(view)
        
        var DriverID = ""
        
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            DriverID = UserDefaults.Main.string(forKey: .DriverID)
        }
        
        let parameters: Parameters = ["driver_id": DriverID]
        
        
        let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
        KRProgressHUD.show()
        
        
        Alamofire.request(WebURL.resendEmail, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            
            let getView = self.view .viewWithTag(10000)
            getView?.removeFromSuperview()
            
            
            
            KRProgressHUD.dismiss({})
            
            print(response)
            switch response.result
            {
            case .success:
               
                    if let JSON:NSDictionary = response.result.value as? NSDictionary
                    {
                        let success = JSON.object(forKey: "response") as! String
                        if success == "true"
                        {
                            if let _:NSDictionary = JSON.object(forKey: "data") as? NSDictionary
                            {
                                let alert = UIAlertController.init(title: "Alert", message: JSON.object(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                                    
                                })
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: {
                                    // self.varResendEmail.returnToOriginalState()
                                })
                            }
                            else
                            {
                                let alert = UIAlertController.init(title: "Alert", message: JSON.object(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                                    
                                })
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: {
                                    // self.varResendEmail.returnToOriginalState()
                                })
                            }
                        }
                        else
                        {
                            let alert = UIAlertController.init(title: "Alert", message: JSON.object(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                            let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                                
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: {
                                // self.varResendEmail.returnToOriginalState()
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
                            //self.varResendEmail.returnToOriginalState()
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
                        // self.varResendEmail.returnToOriginalState()
                    })
                
                break
            }
        })
        
    }
    
    @IBAction func btnLogoutTap(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "Alert", message: "Are you sure you want to Logout? Your Progress and account will be deleted. You can re-register with same email id.", preferredStyle: UIAlertControllerStyle.alert)
        let Yes = UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            
            
            UserDefaults.Main.removeObj(forKey: .isLogin)
            UserDefaults.Main.removeObj(forKey: .isSignUp)
            UserDefaults.Main.removeObj(forKey: .isEmailVerify)
            UserDefaults.Main.removeObj(forKey: .isIdCardVerify)
            UserDefaults.Main.removeObj(forKey: .DriverID)
            UserDefaults.Main.removeObj(forKey: .driverInfo)
            UserDefaults.Main.removeObj(forKey: .isCarVerify)
            UserDefaults.Main.removeObj(forKey: .isAdminVerify)
            
            UserDefaults.standard.synchronize()
            
            _ = self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(Yes)
        let No = UIAlertAction.init(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
        })
        alert.addAction(No)
        
        self.present(alert, animated: true, completion: {
            
        })
        
        
        
    }
    
    @IBAction func btnSubmitTap(_ sender: TKTransitionSubmitButton)
    {
        guard (txtVerificationCode.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txtVerificationCode
            {
                floatingLabelTextField.errorMessage = "Please Enter Verification Code"
            }
            return
        }
        txtVerificationCode.resignFirstResponder()
        
        // varbtnSubmit = sender
        // varbtnSubmit.startLoadingAnimation()
        
        let view = UIView.init(frame: self.view.frame)
        view.backgroundColor = .clear
        view.tag = 10000
        self.view.addSubview(view)
        
        var DriverID = ""
        
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            DriverID = UserDefaults.Main.string(forKey: .DriverID)
        }
        
        let parameters: Parameters = ["code": self.txtVerificationCode.text!,"driver_id": DriverID]
        let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
        KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
        KRProgressHUD.show()
        
        Alamofire.request(WebURL.emailVerification, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            
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
                                if let _:NSDictionary = JSON.object(forKey: "data") as? NSDictionary
                                {
                                     KRProgressHUD.dismiss({
                                    UserDefaults.Main.set(true, forKey: .isEmailVerify)
                                    UserDefaults.standard.synchronize()
                                    
                                    // self.varbtnSubmit.startFinishAnimation(0.3, completion: {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDsVerification") as! IDsVerification
                                    self.navigationController?.pushViewController(vc, animated: false)
                                    })
                                    
                                }
                                else
                                {
                                    KRProgressHUD.dismiss({})
                                    let alert = UIAlertController.init(title: "Alert", message: JSON.object(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                                    let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                                        self.txtVerificationCode.text = ""
                                    })
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: {
                                        //self.varbtnSubmit.returnToOriginalState()
                                    })
                                }
                            }
                            else
                            {
                                 KRProgressHUD.dismiss({})
                                let alert = UIAlertController.init(title: "Alert", message: JSON.object(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                                    
                                    self.txtVerificationCode.text = ""
                                })
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: {
                                    //self.varbtnSubmit.returnToOriginalState()
                                })
                                 KRProgressHUD.dismiss({})
                            }
                        }
                            
                    else
                    {
                         KRProgressHUD.dismiss({})
                        let alert = UIAlertController.init(title: "Alert", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                            self.txtVerificationCode.text = ""
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: {
                            //self.varbtnSubmit.returnToOriginalState()
                        })
                        
                     }
                    break
                case .failure(let error):
                    print(error)
                    KRProgressHUD.dismiss({})
                        let alert = UIAlertController.init(title: "Alert", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                            self.txtVerificationCode.text = ""
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: {
                            //self.varbtnSubmit.returnToOriginalState()
                        })
                   
                    break
                }
                
            
        })
    }
    
    
    //MARK: =======================================================
    //MARK: Textfield Delegate Method
    
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
        
        toolBar.setItems([previousButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        return toolBar;
    }
    func resignKeyboard()
    {
        txtVerificationCode.resignFirstResponder()
    }
    
}

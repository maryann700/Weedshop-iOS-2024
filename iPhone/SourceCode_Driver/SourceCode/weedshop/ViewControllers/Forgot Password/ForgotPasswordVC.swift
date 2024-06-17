//
//  ForgotPasswordVC.swift
//  weedshop
//
//  Created by Devubha Manek on 07/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField


class ForgotPasswordVC: MTViewController, UITextFieldDelegate {

// MARK:-   =======================================================
// MARK: Outlet and Variables
    
    // outlet
    
    @IBOutlet var txtEmail: MTTextField!
    @IBOutlet var btnForgotPassword: MTButtonTRanslation!
    
    
    // Variables
    var btnForgotTransition: TKTransitionSubmitButton!
    var varbtnForgotPassword: TKTransitionSubmitButton!
    
    
// MARK:-   =======================================================
// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        UIApplication.shared.isStatusBarHidden = true
    }
    
// MARK:- COmman Methods
    
    // Set SignIn Button For Fluid Animation
    func setSingInButton()->Void
    {
        btnForgotTransition = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.btnForgotPassword.frame.size.width * DeviceScale.SCALE_X, height: self.btnForgotPassword.frame.size.height * DeviceScale.SCALE_Y))
        btnForgotTransition.center = self.btnForgotPassword.center
        btnForgotTransition.addTarget(self, action: #selector(ForgotPasswordVC.btnForgotPasswordTap(_:)), for: UIControlEvents.touchUpInside)
        self.btnForgotPassword.addSubview(btnForgotTransition)
        // self.view.bringSubview(toFront: self.btnSignInBottom)
    }
    
    // MARK:- =======================================================
    // MARK: Validations
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
// MARK:- =======================================================
// MARK: Action Methods

    
    @IBAction func btnBackTap(_ sender: Any) {
     
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnForgotPasswordTap(_ sender: TKTransitionSubmitButton) {
        
        self.resignKeyboard()
        
        guard (txtEmail.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txtEmail
            {
                floatingLabelTextField.errorMessage = "Please Enter Email"
            }
            return
        }
        guard self.isValidEmail(testStr: txtEmail.text!) else
        {
            if let floatingLabelTextField = txtEmail
            {
                floatingLabelTextField.errorMessage = "Please Enter Valid Email"
            }
            return
        }
        
        varbtnForgotPassword = sender
        varbtnForgotPassword.startLoadingAnimation()
        
        let view = UIView.init(frame: self.view.frame)
        view.backgroundColor = .clear
        view.tag = 10000
        self.view.addSubview(view)
        
        let parameters: Parameters = ["email": self.txtEmail.text!]
        
        Alamofire.request(WebURL.forgotPassword, method: .post, parameters: parameters, headers: ["APPKEY": WebURL.appkey]).responseJSON(completionHandler: { (response) in
            
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
                        let alert = UIAlertController.init(title: "Alert", message: JSON.object(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                            
                             _ = self.navigationController?.popViewController(animated: true)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: {
                            self.varbtnForgotPassword.returnToOriginalState()
                        })
                    }
                    else
                    {
                        let alert = UIAlertController.init(title: "Alert", message: JSON.object(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                            
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: {
                            self.varbtnForgotPassword.returnToOriginalState()
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
                        self.varbtnForgotPassword.returnToOriginalState()
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
                    self.varbtnForgotPassword.returnToOriginalState()
                })
                
                break
            }
        })

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
        txtEmail.resignFirstResponder()
    }
}

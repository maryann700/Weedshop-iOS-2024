//
//  Car_Detail_ViewController.swift
//  weedshop
//
//  Created by Devubha Manek on 17/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField
import KRProgressHUD

class Car_Detail_ViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate,SegmentedProgressBarDelegate {

    @IBOutlet weak var View_progress1: UIView!
    @IBOutlet weak var View_progress2: UIView!
    @IBOutlet weak var View_progress3: UIView!
    @IBOutlet weak var View_progress4: UIView!
    
    @IBOutlet weak var Car_number: UITextField!
    @IBOutlet weak var Car_brand_name: UITextField!
    
    
    
    var btnTransition: TKTransitionSubmitButton!
    var varbtnSubmit: TKTransitionSubmitButton!
    var pickImage = UIImage()
    var viewFromCame = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Car_number.text = ""
        Car_brand_name.text = ""
        self.Car_number.autocorrectionType = .no
        self.Car_brand_name.autocorrectionType = .no
        self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0;
        self.view.registerAsDodgeViewForMLInputDodger()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
      
        
        
     

     

        
        let isCarVerify = UserDefaults.Main.bool(forKey: .isCarVerify)
        if isCarVerify == true
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyProcessViewController") as! VerifyProcessViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else{
          self.setProgressBar()
        
        }
      
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Set Progress Bar
    func setProgressBar()->Void
    {
        self.View_progress1.alpha = 1.0
        self.View_progress1.backgroundColor = UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
        self.View_progress2.alpha = 1.0
        self.View_progress2.backgroundColor = UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
        self.View_progress3.alpha = 1.0
        self.View_progress3.backgroundColor = UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
        
        
        let spb = SegmentedProgressBar(numberOfSegments: 1, duration: 2)
        spb.frame = CGRect(x: 0, y: 0, width: 91.5, height: 4)
        spb.delegate = self
        spb.topColor = UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
        spb.bottomColor = UIColor.clear
        self.View_progress4.addSubview(spb)
        spb.startAnimation()
        
    }
    
    @IBAction func LogOutClick(_ sender: UIControl) {
        
        let alert = UIAlertController.init(title: "Alert", message: "Are you sure you want to Logout?", preferredStyle: UIAlertControllerStyle.alert)
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
            
            if self.viewFromCame == "AdminApproval" || self.viewFromCame.characters.count > 0
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let navController = UINavigationController.init(rootViewController: vc)
                navController.navigationBar.isHidden = true
                navController.interactivePopGestureRecognizer?.isEnabled = false
                UIApplication.shared.keyWindow?.rootViewController = navController
                UIApplication.shared.keyWindow?.makeKeyAndVisible()
            }
            else
            {
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
            
        })
        alert.addAction(Yes)
        let No = UIAlertAction.init(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
        })
        alert.addAction(No)
        
        self.present(alert, animated: true, completion: {
            
        })
        
    }
    @IBAction func Click_selected(_ sender: TKTransitionSubmitButton) {
        
        
        guard (self.Car_number.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = Car_number as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Please Enter car number"
            }
            return
        }
        guard (self.Car_brand_name.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = Car_brand_name as? SkyFloatingLabelTextField
            {
                floatingLabelTextField.errorMessage = "Please Enter car Brand Name"
            }
            return
        }
        
        self.Car_number.resignFirstResponder()
        self.Car_brand_name.resignFirstResponder()
        

     
        // varbtnSubmit = sender
        
        let actionSheet = UIAlertController.init(title: "Provide Identification", message: "Please Upload Your ID's", preferredStyle: UIAlertControllerStyle.actionSheet)
        
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
    // MARK:- =======================================================
    // MARK: - Segmented ProgressBar Delegate
    
    func segmentedProgressBarChangedIndex(index: Int)
    {
        print("Now showing index: \(index)")
    }
    
    func segmentedProgressBarFinished() {
        print("Finished!")
    }
    
    
    // Method For Upload Medical Card
    @IBAction func btnUploadRecomendationTap(_ sender: TKTransitionSubmitButton)
    {
       
        
      //  varbtnSubmit = sender
        
        let actionSheet = UIAlertController.init(title: "Provide Car Details", message: "Please Upload car detail", preferredStyle: UIAlertControllerStyle.actionSheet)
        
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
    
    //MARK: =======================================================
    //MARK: UIImagePicker Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    //MARK: =======================================================
    //MARK: UIImagePicker Delegate
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
        
        pickImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        picker.dismiss(animated: true, completion: {
            
            let view = UIView.init(frame: self.view.frame)
            view.backgroundColor = .clear
            view.tag = 10000
            self.view.addSubview(view)
            
          //  self.varbtnSubmit.startLoadingAnimation()
            let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
            KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
            KRProgressHUD.show()
            
            var DriverID = ""
            
            let id: String = UserDefaults.Main.string(forKey: .DriverID)
           
            
            let car_number:String = self.Car_number.text!
            let car_brand:String = self.Car_brand_name.text!
            
            if (id.characters.count > 0)
            {
                DriverID = UserDefaults.Main.string(forKey: .DriverID)
            }
            
            let parameters : Parameters = ["driver_id": DriverID, "type": "car_document","car_number": car_number,"car_brand": car_brand]
            
            
            let url = URL(string:NSString.init(format: "%@",WebURL.isDriverIDUpload) as String)!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue(WebURL.appkey, forHTTPHeaderField: "APPKEY")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.timeoutInterval = 600
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                if let imageData = UIImageJPEGRepresentation(self.pickImage, 0.5)
                {
                    multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")
                }
                
                for (key, value) in parameters
                {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
            }, with: urlRequest) { (encodingResult) in
                
                let getView = self.view .viewWithTag(10000)
                getView?.removeFromSuperview()
                
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
                                
                                UserDefaults.Main.set(true, forKey: .isCarVerify)
                                UserDefaults.standard.synchronize()
                                
                                
                                KRProgressHUD.dismiss({
                                    
                                    
                                    // self.varbtnSubmit.startLoadingAnimation()
                                    // self.varbtnSubmit.startFinishAnimation(0.3, completion: {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyProcessViewController") as! VerifyProcessViewController
                                    self.navigationController?.pushViewController(vc, animated: false)
                                    //})
                                    
                                })
                                    
                            }
                            else
                            {
                                KRProgressHUD.dismiss({
                                    
                                    
                                    let alert = UIAlertController.init(title: "Alert", message: JSON.object(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                                    let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                                        
                                    })
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: {
                                        //self.varbtnSubmit.returnToOriginalState()
                                    })
                                })
                            }
                        }
                        else
                        {
                            KRProgressHUD.dismiss({
                            let alert = UIAlertController.init(title: "Alert", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
                            let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                                
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: {
                                //self.varbtnSubmit.returnToOriginalState()
                            })
                           })
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    KRProgressHUD.dismiss({
                        
                        // self.varbtnSubmit.returnToOriginalState()
                        
                        let alert = UIAlertController.init(title: "Alert", message: encodingError as? String, preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                            
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: {
                            //self.varbtnSubmit.returnToOriginalState()
                        })
                        
                    })
                }
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
           
            
                if (Car_number.isFirstResponder)
                {
                    Car_number.resignFirstResponder()
                    Car_brand_name.becomeFirstResponder()
                }
                
            
            
        }
        else
        {
                if (Car_brand_name.isFirstResponder)
                {
                    Car_brand_name.resignFirstResponder()
                    Car_number.becomeFirstResponder()
                }
           
        }
    }
    
    func resignKeyboard()
    {
        Car_number.resignFirstResponder()
        Car_brand_name.resignFirstResponder()
       
    }

   

}

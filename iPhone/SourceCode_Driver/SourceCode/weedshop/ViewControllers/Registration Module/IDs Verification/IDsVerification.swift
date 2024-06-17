//
//  IDsVerification.swift
//  weedshop
//
//  Created by Devubha Manek on 28/02/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD

class IDsVerification: MTViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SegmentedProgressBarDelegate
{
    
    
    //MARK: =======================================================
    //MARK: Outlets
    @IBOutlet var viewProgress1: UIView!
    @IBOutlet var viewProgress2: UIView!
    @IBOutlet var viewProgress3: UIView!
    @IBOutlet var viewProgress4: UIView!
    
    
    
    @IBOutlet var btnAddIdentification: MTButtonTRanslation!
    var btntransation: TKTransitionSubmitButton!
    var varbtnSubmit: TKTransitionSubmitButton!
    var pickImage = UIImage()
    var viewFromCame = String()
    
    //MARK: =======================================================
    //MARK: View Lifi Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.setConstants()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        let IdCardVerify = UserDefaults.Main.bool(forKey: .isIdCardVerify)
        if IdCardVerify == true
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Car_Detail_ViewController") as! Car_Detail_ViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        self.setProgressBar()
        self.setSingInButton()
    }
    
    //MARK: =======================================================
    //MARK: Comman Methods
    
    // Set SignIn Button For Fluid Animation
    func setSingInButton()->Void
    {
        btntransation = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.btnAddIdentification.frame.size.width * DeviceScale.SCALE_X, height: self.btnAddIdentification.frame.size.height * DeviceScale.SCALE_Y))
        btntransation.center = self.btnAddIdentification.center
        btntransation.addTarget(self, action: #selector(IDsVerification.btnAddIDTap(_:)), for: UIControlEvents.touchUpInside)
        self.btnAddIdentification.addSubview(btntransation)
        // self.view.bringSubview(toFront: self.btnSignInBottom)
    }
    
    // Set Progress Bar
    func setProgressBar()->Void
    {
        self.viewProgress1.alpha = 1.0
        self.viewProgress1.backgroundColor = UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
        self.viewProgress2.alpha = 1.0
        self.viewProgress2.backgroundColor = UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
        
        self.viewProgress3.frame = self.viewProgress1.frame
        
        let spb = SegmentedProgressBar(numberOfSegments: 1, duration: 2)
        spb.frame = CGRect(x: 0, y: 0, width: 91.5 * DeviceScale.SCALE_X, height: DeviceType.IS_IPHONE_6PLUS ? 3.5 * DeviceScale.SCALE_Y : DeviceType.IS_IPHONE_6 ? 4 * DeviceScale.SCALE_Y : DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS ? 4 * DeviceScale.SCALE_Y : 4 * DeviceScale.SCALE_Y)
        spb.delegate = self
        spb.topColor = UIColor.init(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
        spb.bottomColor = UIColor.clear
        self.viewProgress3.addSubview(spb)
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
    
    @IBAction func btnLogoutTap(_ sender: Any) {
        
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
    
    // Method For Upload ID Card
    @IBAction func btnAddIDTap(_ sender: TKTransitionSubmitButton)
    {
        //        varbtnSubmit = sender
        //        varbtnSubmit.animate(1.2, completion: { () -> () in
        
        //  varbtnSubmit = sender
        
        
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
        //        })
        
        
        
    }
    
    
    
    //MARK: =======================================================
    //MARK: UIImagePicker Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        pickImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        picker.dismiss(animated: true, completion: {
            
            let view = UIView.init(frame: self.view.frame)
            view.backgroundColor = .clear
            view.tag = 10000
            self.view.addSubview(view)
            
            // self.varbtnSubmit.startLoadingAnimation()
            let color = UIColor.init(red: 47.0 / 255.0, green: 204.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
            KRProgressHUD.set(activityIndicatorStyle: .color(color, color))
            KRProgressHUD.show()
            
            var DriverID = ""
            
            let id: String = UserDefaults.Main.string(forKey: .DriverID)
            if (id.characters.count > 0)
            {
                DriverID = UserDefaults.Main.string(forKey: .DriverID)
            }
            
            let parameters: Parameters = ["driver_id": DriverID, "type": "id_card"]
            
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
                        
                        KRProgressHUD.dismiss({
                            if let JSON:NSDictionary = response.result.value as? NSDictionary
                            {
                                print("JSON: \(JSON)")
                                
                                let success = JSON.object(forKey: "response") as! String
                                if success == "true"
                                {
                                    UserDefaults.Main.set(true, forKey: .isIdCardVerify)
                                    UserDefaults.standard.synchronize()
                                    
                                    if self.viewFromCame.characters.count > 0 && self.viewFromCame == "AdminApproval_Identification"
                                    {
                                        UserDefaults.Main.set(true, forKey: .isCarVerify)
                                        UserDefaults.standard.synchronize()
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyProcessViewController") as! VerifyProcessViewController
                                        self.navigationController?.pushViewController(vc, animated: false)
                                    }
                                    else
                                    {
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Car_Detail_ViewController") as! Car_Detail_ViewController
                                        vc.viewFromCame = "AdminApproval"
                                        self.navigationController?.pushViewController(vc, animated: false)
                                    }
                                    
                                }
                                else
                                {
                                    let alert = UIAlertController.init(title: "Alert", message: JSON.object(forKey: "msg") as? String, preferredStyle: UIAlertControllerStyle.alert)
                                    let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                                        
                                    })
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: {
                                        // self.varbtnSubmit.returnToOriginalState()
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
                                    //self.varbtnSubmit.returnToOriginalState()
                                })
                            }
                            
                        })
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    
                    KRProgressHUD.dismiss({
                        
                        //  self.varbtnSubmit.returnToOriginalState()
                        
                        let alert = UIAlertController.init(title: "Alert", message: encodingError as? String, preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                            
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: {
                            // self.varbtnSubmit.returnToOriginalState()
                        })
                        
                        
                    })
                }
            }
        })
    }
    
}

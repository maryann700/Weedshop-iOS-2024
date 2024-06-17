//
//  VerifyProcessViewController.swift
//  weedshop
//
//  Created by Devubha Manek on 18/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//



import UIKit
import MessageUI
import Alamofire




class VerifyProcessViewController: MTViewController, MFMailComposeViewControllerDelegate
{
    
    // MARK:-   =======================================================
    // MARK:- Outlets and Variables
    
    //Outlets
    @IBOutlet var lblTitle: MTLabel!
    @IBOutlet var lblDetail: MTLabel!
    @IBOutlet var btnContactToAdmin: MTButtonTRanslation!
    
    //Variables
    var btnContact: TKTransitionSubmitButton!
    var message = String()
    var reason = String()
    var varbtnSubmit: TKTransitionSubmitButton!
    
    var DriverInfo = driverInfo()
    var timer = Timer()
    
    // MARK:-   =======================================================
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UIApplication.shared.isStatusBarHidden = true
        
        //self.lblDetail.text = message
        
        self.approval_called()
        
        
        if !self.timer.isValid
        {
            if #available(iOS 10.0, *)
            {
                self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (tick) in
                    self.approval_called()
                })
            } else {
                self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.approval_called), userInfo: nil, repeats: true)
            }
        }
        
        if reason == "Identification,Car"
        {
            self.btnContactToAdmin .setTitle("ADD IDENTIFICATION", for: .normal)
        }
        else if reason == "Car"
        {
            self.btnContactToAdmin .setTitle("UPDATE CAR DETAIL", for: .normal)
        }
        else if reason == "Identification"
        {
            self.btnContactToAdmin .setTitle("ADD IDENTIFICATION", for: .normal)
        }
        else
        {
            self.btnContactToAdmin .setTitle("CONTACT TO ADMIN", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK:-   =======================================================
    // MARK: Action Methods
    
    
    @IBAction func btnContactAdminTap(_ sender: TKTransitionSubmitButton)
    {
         varbtnSubmit = sender
      
        if reason == "Identification,Car"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDsVerification") as! IDsVerification
            vc.viewFromCame = "AdminApproval_Identification,Car"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if reason == "Car"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Car_Detail_ViewController") as! Car_Detail_ViewController
            vc.viewFromCame = "AdminApproval_Car"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if reason == "Identification"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDsVerification") as! IDsVerification
            vc.viewFromCame = "AdminApproval_Identification"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
            else
            {
            }
        }
        
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
      let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        composeVC.setToRecipients(["testineed@gmail.com"])
        composeVC.setSubject("Regarding Driver Profile approval.")
        composeVC.setMessageBody(reason, isHTML: false)
        
        return composeVC
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
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(Yes)
        let No = UIAlertAction.init(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
        })
        alert.addAction(No)
        
        self.present(alert, animated: true, completion: {
            
        })
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        switch (result)
        {
        case MFMailComposeResult.cancelled:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: {
                
                
            })
        case MFMailComposeResult.failed:
            print("Message failed")
            self.dismiss(animated: true, completion: {
                
                let alertAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
                let alert1: UIAlertController = UIAlertController(title: "Alert", message: "Erron in Sending Mail.", preferredStyle: .alert)
                alert1.addAction(alertAction)
                self.present(alert1, animated: true, completion: nil)
            })
        case MFMailComposeResult.sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: {
                
                let alertAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
                let alert1: UIAlertController = UIAlertController(title: "Alert", message: "Mail Sent Successfully.", preferredStyle: .alert)
                alert1.addAction(alertAction)
                self.present(alert1, animated: true, completion: nil)
            })
        default:
            break;
        }
    }
    //Webserive called
    func approval_called(){
        var DriverID = ""
        
        let id: String = UserDefaults.Main.string(forKey: .DriverID)
        if (id.characters.count > 0)
        {
            DriverID = UserDefaults.Main.string(forKey: .DriverID)
        }
        
        ServiceClass.sharedInstance.getUserInfo(DriverID: DriverID) { (info) in
                self.DriverInfo = info
                if((self.DriverInfo.driver_adminApproved == "Pending") || (self.DriverInfo.driver_adminApproved == "Rejected"))
                {
                   // self.lblTitle.text = self.DriverInfo.driver_adminApproved
                    self.message = self.DriverInfo.driver_verifymsg
                    self.lblDetail.text = self.message
                  
                }else if(self.DriverInfo.driver_adminApproved == "Approved" ){
                    
                    self.timer.invalidate()
                    UserDefaults.Main.set(true, forKey: .isLogin)
                    UserDefaults.Main.set(true, forKey: .isAdminVerify)
                    UserDefaults.standard.synchronize()
                     self.dismiss(animated: true, completion: nil)
                  //  self.lblTitle.text = self.DriverInfo.driver_adminApproved
                    self.message = self.DriverInfo.driver_verifymsg
                    self.lblDetail.text = self.message
                    self.performSegue(withIdentifier: "SlideMenu", sender: self)
                    
                }

            
            }
        
    }
}

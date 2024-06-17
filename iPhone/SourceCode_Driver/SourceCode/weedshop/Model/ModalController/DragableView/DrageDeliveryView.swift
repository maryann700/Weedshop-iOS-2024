//
//  DraggbleView.swift
//  weedshop
//
//  Created by Devubha Manek on 24/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit



class DrageDeliveryView: UIView {

    @IBOutlet weak var Delivery_name: UILabel!
    @IBOutlet weak var Deliver_price: UILabel!
    @IBOutlet weak var Deliver_time: UILabel!
    @IBOutlet weak var deliver_distance: UILabel!
    @IBOutlet weak var ShopAddresh: UILabel!
    @IBOutlet weak var deliver_address: UILabel!
    var Mobile : NSString!
    
    @IBOutlet weak var deliver_user_img: UIImageView!
    
 
    
    @IBOutlet weak var View_user: UIView!
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadViewFromNib()
    }
    func loadViewFromNib()  {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DrageDeliveryView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);


        
        View_user.layer.cornerRadius = View_user.frame.size.height/2
        View_user.clipsToBounds = true
        
        

        
    }

    @IBAction func Click_on_mobile(_ sender: UIControl) {
        
        self.phone(phoneNum: self.Mobile as String)

    
    }
    @IBAction func Control_Deliver_order(_ sender: UIControl) {

        NotificationCenter.default.post(name: Notification.Name("DragNotification"), object: nil,userInfo: ["action":"delivered"])
        
//        let bgservice = BackGroundServices()
//        bgservice.driver_order_action(action: "delivered")
        
        
    }
    func phone(phoneNum: String) {
        if let url = URL(string: "tel://\(phoneNum)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
}

//
//  DraggbleShopView.swift
//  weedshop
//
//  Created by Devubha Manek on 25/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit



class DraggbleShopView: UIView {

    @IBOutlet weak var Shop_name: UILabel!
    @IBOutlet weak var Shop_owner_name: UILabel!
    @IBOutlet weak var Shop_price: UILabel!
    @IBOutlet weak var Shop_Arrival_time: UILabel!
    @IBOutlet weak var Shop_distance: UILabel!
    @IBOutlet weak var Shop_address: UILabel!
    @IBOutlet weak var Driver_address: UILabel!
    @IBOutlet weak var Shop_owner_view: CircleView!
    var Shop_mobile_no : NSString!
    @IBOutlet weak var shopImg: UIImageView!
    
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
        let nib = UINib(nibName: "DraggbleShopView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
        Shop_owner_view.layer.cornerRadius = Shop_owner_view.frame.size.height/2
        Shop_owner_view.clipsToBounds = true

    
    }

    @IBAction func Click_On_mobile(_ sender: UIControl) {
        self.phone(phoneNum: self.Shop_mobile_no as String)
        
        
    }
    
    @IBAction func Control_PickUpOrder(_ sender: UIControl) {
        
        NotificationCenter.default.post(name: Notification.Name("DragNotification"), object: nil,userInfo: ["action":"pickup"])

        

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

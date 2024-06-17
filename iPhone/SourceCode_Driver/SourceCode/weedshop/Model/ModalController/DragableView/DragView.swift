//
//  DragView.swift
//  weedshop
//
//  Created by Devubha Manek on 25/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit





class DragView: UIView  {
    var Constat:CGFloat = 30.0
    //Swipe Gesture
    var gestureDown:UISwipeGestureRecognizer!
    var gestureUp:UISwipeGestureRecognizer!
    
    
    @IBOutlet weak var lbl_shop: UILabel!
    @IBOutlet weak var lbl_delivery: UILabel!
    @IBOutlet weak var ShopHilightedView: UIView!
    @IBOutlet weak var DeliveryHilightedview: UIView!
    @IBOutlet weak var DrageScroll: UIScrollView!
  
    
    
    
    // weak var delegate: OnboardingDelegate?
    
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
        let nib = UINib(nibName: "DragView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        self.ShopDataShow()
        
        //Gesture Down
        gestureDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeToDown))
        gestureDown.direction = UISwipeGestureRecognizerDirection.down
        self.addGestureRecognizer(gestureDown)
        
        //Gesture Up
        gestureUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeToDown))
        gestureUp.direction = UISwipeGestureRecognizerDirection.up
        self.addGestureRecognizer(gestureUp)
        
    }
    
    func setupScrollView() {
        let Content_view1 = DraggbleShopView(frame:CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height-Constat))
        Content_view1.layoutIfNeeded()
       
        let Content_view2 = DrageDeliveryView(frame:CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height-Constat))
          Content_view2.layoutIfNeeded()
       
        
        let current_Order_Info = UserDefaults.Main.object(forKey: .currentOrderInfo)
        if current_Order_Info != nil
        {
            
            let current_Order_Info: CurrentOrderDetail = NSKeyedUnarchiver.unarchiveObject(with: current_Order_Info as! Data) as! CurrentOrderDetail

            Content_view1.Shop_name.text = current_Order_Info.store_name
            Content_view1.Shop_owner_name.text = current_Order_Info.store_owner
            Content_view1.Shop_price.text = "$" + current_Order_Info.final_total
            Content_view1.Shop_Arrival_time.text = current_Order_Info.store_time
            Content_view1.Shop_distance.text = current_Order_Info.store_distance + " km"
            Content_view1.Shop_address.text = current_Order_Info.store_address
            Content_view1.Driver_address.text = current_Order_Info.driver_address
            Content_view1.Shop_mobile_no = current_Order_Info.mobile as NSString
            if (current_Order_Info.store_image.characters.count) > 0
            {
                Content_view1.shopImg.sd_setImage(with: URL.init(string: current_Order_Info.store_image_url), placeholderImage: UIImage.init(named: "High5_Logo"), options: .refreshCached)
            }
            else
            {
                Content_view1.shopImg.image = UIImage.init(named: "High5_Logo")
            }
            
            Content_view2.Delivery_name.text  = current_Order_Info.delivery_name
            Content_view2.Deliver_price.text  = "$" + current_Order_Info.final_total
            Content_view2.Deliver_time.text  = current_Order_Info.delivery_time
            Content_view2.deliver_distance.text  = current_Order_Info.delivery_distance + " km"
            Content_view2.deliver_address.text  = current_Order_Info.delivery_address
            Content_view2.ShopAddresh.text  = current_Order_Info.store_address
            Content_view2.Mobile = current_Order_Info.delivery_phone as NSString
            if (current_Order_Info.user_image.characters.count) > 0
            {
                Content_view2.deliver_user_img.sd_setImage(with: URL.init(string: current_Order_Info.user_image_url), placeholderImage: UIImage.init(named: "userPlace"), options: .refreshCached)
            }
            else
            {
                Content_view2.deliver_user_img.image = UIImage.init(named: "userPlace")
            }
            
           
            
        }
        
        
        let views = [Content_view1, Content_view2]
        
        self.DrageScroll.bounces = false
        self.DrageScroll.contentSize = CGSize(width: CGFloat(views.count) * self.frame.size.width, height:  self.DrageScroll.frame.size.height-Constat)
        _ = views.map({ addViewToScrollView($0) })
        _ = views.map({ $0.frame.origin =  CGPoint(x: CGFloat(views.index(of: $0)!) * self.frame.size.width, y: 0) })
        
    }
    
    func addViewToScrollView(_ ViewModal : UIView) {
        self.DrageScroll.addSubview(ViewModal)
       
    }
    func showAlldataInDragView() {
     
        

    }

    
    func ShopDataShow() {
        self.lbl_shop.textColor = UIColor.AppGreen()
        self.lbl_delivery.textColor = UIColor.lightGray
        self.ShopHilightedView.backgroundColor =  UIColor.AppGreen()
        self.DeliveryHilightedview.backgroundColor =  UIColor.lightGray
        
        
           }
    
    func DeliveryDataShow() {
        self.lbl_shop.textColor = UIColor.lightGray
        self.lbl_delivery.textColor = UIColor.AppGreen()
        self.ShopHilightedView.backgroundColor = UIColor.lightGray
        self.DeliveryHilightedview.backgroundColor = UIColor.AppGreen()
    }
    
    

}


private extension DragView {
    
    
    @IBAction func Shop_contoller(_ sender: UIControl) {
        self.ShopDataShow()
        self.DrageScroll.scrollToPage(index: 0, animated: true, after: 0.1)
    }
    @IBAction func Delivery_contoller(_ sender: UIControl) {
        self.DeliveryDataShow()
        self.DrageScroll.scrollToPage(index: 1, animated: true, after: 0.1)
        
    }

    
//    @IBAction func nextPage(_ sender: Any) {
//        if pageControl.currentPage == stepviews.endIndex{
//            return
//        }
//        
//        let nextPageIndex = CGFloat(pageControl.currentPage + 1)
//        
//        UIView.animate(withDuration: 0.3) {
//            self.scrollView.contentOffset.x = self.scrollView.frame.width * nextPageIndex
//        }
//        
//        pageControl.currentPage += 1
//    }
//    
//    @IBAction func skip(_ sender: Any) {
//        pageControl.currentPage = stepviews.endIndex
//        nextPage(self)
//    }
//    
//    func moveControlConstraintsOffScreen () {
//        pageControlBottomConstraint.constant = 40
//        skipButtonTopConstraint.constant = -40
//        nextButtonTopConstraint.constant = -40
//    }
//    
//    func moveControlConstraintsOnScreen () {
//        pageControlBottomConstraint.constant = 0
//        skipButtonTopConstraint.constant = 16
//        nextButtonTopConstraint.constant = 16
//    }
}

extension DragView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.endEditing(true)
        
       // let visibleIndex = Int(self.DrageScroll.contentOffset.x / self.frame.width)
       
        // print("visibleIndex \( visibleIndex)")
//        delegate.doSomething()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let pageNumber = round( self.DrageScroll.contentOffset.x /  self.DrageScroll.frame.size.width)
        let page  = Int(pageNumber)
        
        if page == 0 {
            self.ShopDataShow()
            
        }else{
            self.DeliveryDataShow()
            
            
        }
        print("page \( page)")
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / self.frame.width)
        print("pageNumber \( pageNumber)")
//        pageControl.currentPage = pageNumber
    }
    
    
}
extension UIScrollView {
    func scrollToPage(index: UInt8, animated: Bool, after delay: TimeInterval) {
        let offset: CGPoint = CGPoint(x: CGFloat(index) * frame.size.width, y: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.setContentOffset(offset, animated: animated)
        })
    }
}
//MARK: - Gesture Swipe
extension DragView{
    
    func swipeToDown(_ gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction {
           
            case UISwipeGestureRecognizerDirection.down:
                print("Swipe Down")
                self.hide(2, index: 0)
                break
            case UISwipeGestureRecognizerDirection.up:
                print("Swipe Up")
                self.hide(1, index: 0)
                break
            default:
                print("Default")
                break
            }
        }
    }
    
    //MARK: - Hide Popup
    func hide(_ indexHideDirection: Int,index: Int)
    {
        //Move Animation
       
            var animationDelay:TimeInterval! =  0.35
            UIView.animate(withDuration: animationDelay, animations: {
                //Move Up
                if indexHideDirection == 1
                {
                    self.superview?.frame = CGRect(x: 0,y: ScreenSize.HEIGHT - self.frame.size.height,width: self.frame.size.width,height: self.frame.size.height)
                }
                //Move Down
                else if (indexHideDirection == 2)
                {
                    self.superview?.frame = CGRect(x: 0,y: ScreenSize.HEIGHT - (((self.DrageScroll.frame.size.height * 0.47) * 0.55) + self.Constat) ,width: self.frame.size.width,height: self.frame.size.height)
                }
    
            }, completion: { (finished) in
//                UIView.animate(withDuration: 0.1, animations: {
//                   /// self.viewTransperant.alpha = 0.0
//                }, completion: { (finished) in
//                    if self.handler != nil
//                    {
//                        self.handler!(index)
//                    }
//                    self.removeFromSuperview()
//                })
            })
        
     
    }

    
    
}

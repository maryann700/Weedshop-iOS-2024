//
//  MTRangeSlider.swift
//  weedshop
//
//  Created by Devubha Manek on 06/03/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit


class MTRangeSlider: UIView, UIGestureRecognizerDelegate
{
    @IBOutlet var viewSliderBG: UIView!
    @IBOutlet var viewSliderSmall: UIView!
    @IBOutlet var viewSliderThumb: UIView!
    @IBOutlet var imgSliderThumb: UIImageView!

    var currentValue: Int = 20
    var minValue: Int = 0
    var maxValue: Int = 100
    
    
    
//    class func instanceFromNib() -> UIView
//    {
//        return UINib(nibName: "MTRangeSlider", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
//    }
//    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
       
    }
    
//    func setNib()->UIView
//    {
//       return  UINib(nibName: "MTRangeSlider", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
//    }
    
    var getSlidervalue: ((_ currentValue: Int)-> Void)?
    
    
    func setSlider(strThumb: String, tintColorMax: UIColor, tintColorMin: UIColor, tintColorThumb: UIColor)
    {
        self.viewSliderBG.layer.cornerRadius = self.viewSliderBG.frame.size.height / 2
        self.viewSliderBG.backgroundColor = tintColorMax
    
        self.viewSliderSmall.layer.cornerRadius = self.viewSliderSmall.frame.size.height / 2
        self.viewSliderSmall.backgroundColor = tintColorMin
        
        if strThumb.characters.count > 0
        {
            self.imgSliderThumb.image = UIImage.init(named: strThumb)!
        }
        else
        {
            self.imgSliderThumb.layer.cornerRadius = self.imgSliderThumb.frame.size.height / 2
            self.imgSliderThumb.backgroundColor = tintColorThumb
        }
        
    }
    
    func setInitialSlider(currentSliderValue: CGFloat)
    {
        var currentValue: CGFloat = 0
        if currentSliderValue > 100.0
        {
            currentValue = 100.0
        }
        else if currentSliderValue < 1.0
        {
            currentValue = 1.0
        }
        UIView.animate(withDuration: 0.02, delay: 0.0, options: .curveEaseIn, animations:
            {
                let counter = self.frame.size.width / 100
                
                if currentValue > 90
                {
                     self.viewSliderThumb.frame = CGRect.init(x: (currentValue * counter) - (self.viewSliderThumb.frame.size.width / 2) - 10, y: self.viewSliderThumb.frame.origin.y, width: self.viewSliderThumb.frame.size.width, height: self.viewSliderThumb.frame.size.height)
                }
                else
                {
                     self.viewSliderThumb.frame = CGRect.init(x: currentValue * counter - (self.viewSliderThumb.frame.size.width / 2), y: self.viewSliderThumb.frame.origin.y, width: self.viewSliderThumb.frame.size.width, height: self.viewSliderThumb.frame.size.height)
                }
           
            
            self.viewSliderSmall.frame = CGRect.init(x: 0, y: self.viewSliderSmall.frame.origin.y, width: self.viewSliderSmall.frame.origin.x + self.viewSliderThumb.frame.origin.x + (self.viewSliderThumb.frame.size.width / 2 ), height: self.viewSliderSmall.frame.size.height)
            
            self.currentValue = Int(currentValue)
            
            
        }, completion: { (complition: Bool) in
            
        })
    }
   
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
       return true
       }

   
    @IBAction func panYellowView(_ sender: UIPanGestureRecognizer)
    {
        if sender.state == UIGestureRecognizerState.changed
        {
            let velocity = sender.velocity(in: self)
            
            if velocity.x > 0
            {
                if self.viewSliderThumb.frame.origin.x + self.viewSliderThumb.frame.size.width - 4 < self.frame.size.width
                {
                    UIView.animate(withDuration: 0.02, delay: 0.0, options: .curveEaseIn, animations: {
                        
                        let counter = (self.frame.size.width - (self.viewSliderThumb.frame.size.width / 2)) / 100
                       
                        self.viewSliderThumb.frame = CGRect.init(x: self.viewSliderThumb.frame.origin.x + counter, y: self.viewSliderThumb.frame.origin.y, width: self.viewSliderThumb.frame.size.width, height: self.viewSliderThumb.frame.size.height)
                        
                        self.viewSliderSmall.frame = CGRect.init(x: 0, y: self.viewSliderSmall.frame.origin.y, width: self.viewSliderSmall.frame.origin.x + self.viewSliderThumb.frame.origin.x + (self.viewSliderThumb.frame.size.width / 2 ), height: self.viewSliderSmall.frame.size.height)

                        if self.currentValue <= 100
                        {
                            if let block = self.getSlidervalue
                            {
                                block(self.currentValue)
                            }
                            self.currentValue = self.currentValue + 1
                        }
                        
                    }, completion: { (complition: Bool) in
                        
                    })
                }
            }
            else
            {
                if  (self.viewSliderSmall.frame.size.width / 2) - 3 >=  self.frame.origin.x
                {
                    UIView.animate(withDuration: 0.02, delay: 0.0, options: .curveEaseIn, animations: {
                        
                         let counter = (self.frame.size.width - (self.viewSliderThumb.frame.size.width / 2)) / 100
                        
                        print("Minus Before viewSliderSmall: ",self.viewSliderSmall.frame)
                        self.viewSliderSmall.frame = CGRect.init(x: 0, y: self.viewSliderSmall.frame.origin.y, width: self.viewSliderSmall.frame.origin.x + self.viewSliderThumb.frame.origin.x + (self.viewSliderThumb.frame.size.width / 2 ), height: self.viewSliderSmall.frame.size.height)
                        
                         print("Minus After viewSliderSmall: ",self.viewSliderSmall.frame)
                        
                        print("Minus Before viewSliderThumb: ",self.viewSliderThumb.frame)
                        self.viewSliderThumb.frame = CGRect.init(x: self.viewSliderThumb.frame.origin.x - counter, y: self.viewSliderThumb.frame.origin.y, width: self.viewSliderThumb.frame.size.width, height: self.viewSliderThumb.frame.size.height)
                        
                         print("Minus After viewSliderThumb: ",self.viewSliderThumb.frame)

                        if self.currentValue >= 1
                        {
                            if let block = self.getSlidervalue
                            {
                                block(self.currentValue)
                            }
                            self.currentValue = self.currentValue - 1
                        }
                        
                    }, completion: { (complition: Bool) in
                        
                    })
                }
            }
        }
        else if sender.state == UIGestureRecognizerState.ended
        {
            
        }
        
    }
    
    
    
  
   
    
//    var imgMax : UIImage?
//    {
//        didSet {
//            self.imgSliderBig.image = imgMax
//        }
//    }
//    var imgMin : UIImage?{
//        didSet{
//            self.imgSliderSmall.image = imgMin
//        }
//    }
   
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//
//  CustomView.swift
//  CarouselViewExample
//
//  Created by Matteo Tagliafico on 03/04/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

import UIKit
import TGLParallaxCarousel

@IBDesignable
class CustomView: TGLParallaxCarouselItem {
    
    // MARK: - outlets
    @IBOutlet fileprivate weak var numberLabel: UILabel!
    
    @IBOutlet var imgProduct: UIImageView!
    // MARK: - properties
    fileprivate var containerView: UIView!
    fileprivate let nibName = "CustomView"
    
    @IBInspectable
    var number: Int = 0 {
        didSet{
           numberLabel.text = "\(number)"
        }
    }
    
    
    // MARK: - init
    convenience init(frame: CGRect, number: Int, productImage: UIImage)
    {
        self.init(frame: frame)
        
        self.layer.cornerRadius = 5.0
        self.backgroundColor = .white
        imgProduct.image = productImage
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setup()
    }
    
    func xibSetup()
    {
        containerView = loadViewFromNib()
        containerView.frame = bounds
        containerView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(containerView)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    
    // MARK: - methods
    fileprivate func setup() {
        layer.masksToBounds = false
        layer.shadowRadius = 30
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.65
    }
}

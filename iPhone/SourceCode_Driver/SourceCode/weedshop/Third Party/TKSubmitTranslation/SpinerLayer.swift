import UIKit


class SpinerLayer: CAShapeLayer {
    
    var spinnerColor = UIColor.white {
        didSet {
            strokeColor = spinnerColor.cgColor
        }
    }
    
    init(frame:CGRect) {
        super.init()

        let radius:CGFloat = ((frame.height * DeviceScale.SCALE_X) / 2) * 0.5
        
        print("spinner Frame: - %@", frame)
        print("spinner Radius: - %@", radius)
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS
        {
            if frame.height > 41 || frame.width < 140
            {
                self.frame = CGRect(x: -3, y: -4, width: frame.height, height: frame.height)
            }
            else
            {
                self.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
            }
        }
        else if DeviceType.IS_IPHONE_6
        {
            self.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        }
        else if DeviceType.IS_IPHONE_6PLUS
        {
            self.frame = CGRect(x: 3, y: 3, width: frame.height, height: frame.height)
        }
        
       
        let center = CGPoint(x: frame.height / 2, y: bounds.center.y)
        let startAngle = 0 - Double.pi
        let endAngle = Double.pi * 2 - Double.pi
        let clockwise: Bool = true
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).cgPath

        self.fillColor = nil
        self.strokeColor = spinnerColor.cgColor
        self.lineWidth = 1
        
        self.strokeEnd = 0.4
        self.isHidden = true
        print("spinner Frame2: - %@", frame)
        print("spinner Radius2: - %@", radius)
     }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animation() {
        self.isHidden = false
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = Double.pi * 2
        rotate.duration = 0.4
        rotate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        rotate.repeatCount = HUGE
        rotate.fillMode = kCAFillModeForwards
        rotate.isRemovedOnCompletion = false
        self.add(rotate, forKey: rotate.keyPath)

    }
    
    override func stopAnimation() {
        self.isHidden = true
        self.removeAllAnimations()
    }
}

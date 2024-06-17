//
//  BRCircularProgressView.swift
//  BRCircularProgressBar
//
//  Created by Brammanand Soni on 3/29/17.
//  Copyright © 2017 Brammanand Soni. All rights reserved.
//

import UIKit

class BRDefaultColor {
    static let circleStrokeColor: UIColor = UIColor.white
    static let circleFillColor: UIColor = UIColor.clear
    static let progressCircleStrokeColor: UIColor = UIColor(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
    static let progressCircleFillColor: UIColor = UIColor.clear
}

class BRCircularProgressView: UIView {
    
    // progress: Should be between 0 to 1
    var progress: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var circleStrokeWidth: CGFloat = 0.5
    private var circleStrokeColor: UIColor = BRDefaultColor.circleStrokeColor
    private var circleFillColor: UIColor = BRDefaultColor.circleFillColor
    private var progressCircleStrokeColor: UIColor = BRDefaultColor.progressCircleStrokeColor
    private var progressCircleFillColor: UIColor = BRDefaultColor.progressCircleFillColor
    
    private var textLabel: UILabel!
    private var textFont: UIFont? = UIFont(name: "Roboto-Black", size: 80 * DeviceScale.SCALE_X)
    private var textColor: UIColor? = UIColor(red: 44.0 / 255.0, green: 204.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    // MARK: Public Methods
    
    func setCircleStrokeWidth(_ circleStrokeWidth: CGFloat) {
        self.circleStrokeWidth = circleStrokeWidth
        setCircleStrokeColor()
    }
    
    func setCircleStrokeColor(_ circleStrokeColor: UIColor = BRDefaultColor.circleStrokeColor, circleFillColor: UIColor = BRDefaultColor.circleFillColor, progressCircleStrokeColor: UIColor = BRDefaultColor.progressCircleStrokeColor, progressCircleFillColor: UIColor = BRDefaultColor.progressCircleFillColor) {
        self.circleStrokeColor = circleStrokeColor
        self.circleFillColor = circleFillColor
        self.progressCircleStrokeColor = progressCircleStrokeColor
        self.progressCircleFillColor = progressCircleFillColor
        
        self.setNeedsDisplay()
    }
    
    func setProgressText(_ text: String) {
        textLabel.text = text
    }
    
    func setProgressTextFont(_ font: UIFont = UIFont.boldSystemFont(ofSize: 17), color: UIColor = UIColor.black) {
        textLabel.font = font
        textLabel.textColor = color
    }

    // MARK: Private Methods
    
    private func setupView() {
        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width/2, height: self.frame.size.height/2))
        textLabel.textAlignment = .center
        textLabel.font = textFont
        textLabel.textColor = textColor
        textLabel.numberOfLines = 0
        //textLabel.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
      // textLabel.backgroundColor = UIColor.green
        self.addSubview(textLabel)
    }
    
    // MARK: Core Graphics Drawing
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
       // drawRect(rect, margin: 0, color: circleStrokeColor, percentage: 1)
        drawRect(rect, margin: circleStrokeWidth, color: circleFillColor, percentage: 1)
        drawRect(rect, margin: circleStrokeWidth, color: progressCircleFillColor, percentage: progress)
         drawProgressCircle12(rect)
        drawProgressCircle(rect)
    }
    
    private func drawRect(_ rect: CGRect, margin: CGFloat, color: UIColor, percentage: CGFloat) {
        
        let radius: CGFloat = min(rect.height, rect.width) * 0.5 - margin
        let centerX: CGFloat = rect.width * 0.5
        let centerY: CGFloat = rect.height * 0.5
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        let center: CGPoint = CGPoint(x: centerX, y: centerY)
        context.move(to: center)
        let startAngle: CGFloat = -.pi/2
        let endAngle: CGFloat = -.pi/2 + .pi * 2 * percentage
        
        context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        context.closePath()
        context.fillPath()
    }
    
    private func drawProgressCircle(_ rect: CGRect) {
        
        textLabel.frame = rect
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setLineWidth(circleStrokeWidth)
        context.setStrokeColor(progressCircleStrokeColor.cgColor)
        
        let centerX: CGFloat = rect.width * 0.5
        let centerY: CGFloat = rect.height * 0.5
        let radius: CGFloat = min(rect.height, rect.width) * 0.5 - (circleStrokeWidth / 2)
        let startAngle: CGFloat = -.pi/2
        let endAngle: CGFloat = -.pi/2 + .pi * 2 * progress
        let center: CGPoint = CGPoint(x: centerX, y: centerY)
        
        context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        context.strokePath()
    }
    private func drawProgressCircle12(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setLineWidth(circleStrokeWidth)
        context.setStrokeColor(UIColor.white.cgColor)
        
        let centerX: CGFloat = rect.width * 0.5
        let centerY: CGFloat = rect.height * 0.5
        let radius: CGFloat = min(rect.height, rect.width) * 0.5 - (circleStrokeWidth / 2)
        let startAngle: CGFloat = .pi
        let endAngle: CGFloat = .pi + .pi * 2
        let center: CGPoint = CGPoint(x: centerX, y: centerY)
        
        context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        context.strokePath()
    }
}

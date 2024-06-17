//
//  KVMenuContainerView.swift
//  https://github.com/keshavvishwkarma/KVRootBaseSideMenu-Swift.git
//
//  Distributed under the MIT License.
//
//  Created by Keshav on 7/3/16.
//  Copyright © 2016 Keshav. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//

import UIKit

public struct KVSideMenu
{
    public struct Notifications {
        static public let toggleLeft   = "ToggleLeftSideMenuNotification"
        static public let toggleRight  = "ToggleRightSideMenuNotification"
        static public let close        = "CloseSideMenuNotification"
    }
    
    enum SideMenuState {
        case none, left, right
        init() {
            self = .none
        }
    }
    
    public enum AnimationType
    {
        case `default`, window, folding
        public init() {
            self = .`default`
        }
    }
    
}

open class KVMenuContainerView: UIView
{
    // MARK: - Properties
    
    fileprivate let thresholdFactor: CGFloat = 0.25
    fileprivate let KVSideMenuOffsetValueInRatio : CGFloat = 0.75
    fileprivate let KVSideMenuHideShowDuration   : CGFloat = 0.4
    
    fileprivate let transformScale:CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 0.8)
    
    fileprivate(set) var leftContainerView   :UIView! = UIView.prepareNewViewForAutoLayout()
    fileprivate(set) var centerContainerView :UIView! = UIView.prepareNewViewForAutoLayout()
    fileprivate(set) var rightContainerView  :UIView! = UIView.prepareNewViewForAutoLayout()
    
    fileprivate(set) var currentSideMenuState:KVSideMenu.SideMenuState = KVSideMenu.SideMenuState()
    
    fileprivate var appliedConstraint : NSLayoutConstraint? // may be center, leading, trailling
    fileprivate var panRecognizer     : UIPanGestureRecognizer? {
        didSet {
            panRecognizer?.delegate = self
            panRecognizer?.maximumNumberOfTouches = 1
            addGestureRecognizer(panRecognizer!)
        }
    }
    
    open var animationType   = KVSideMenu.AnimationType()
    open var allowPanGesture :    Bool = true
    
    /// A Boolean value indicating whether the left swipe is enabled.
    open var allowLeftPaning  : Bool = false {
        didSet{
            rightContainerView.subviews.first?.removeFromSuperview()
        }
    }
    
    /// A Boolean value indicating whether the right swipe is enabled.
    open var allowRightPaning : Bool = false {
        didSet{
            leftContainerView.subviews.first?.removeFromSuperview()
        }
    }
    
    // MARK: - Initialization
    
    required public init(superView:UIView!)
    {
        self.init()
        
        prepareViewForAutoLayout()
        backgroundColor = UIColor.clear
        superView.addSubview(self)
        superView.clipsToBounds = true
        
        // apply constraints vai oprator overloading.
        self +== [.height, .width, .centerX, .centerY]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        initialise()
    }
    
    fileprivate func initialise()
    {
        let selector: Selector = #selector(KVMenuContainerView.didReceivedNotification(_:))
        NotificationCenter.default.addObserver(self, selector: selector, name:NSNotification.Name(rawValue: KVSideMenu.Notifications.toggleLeft), object: nil)
        NotificationCenter.default.addObserver(self, selector: selector, name:NSNotification.Name(rawValue: KVSideMenu.Notifications.toggleRight), object: nil)
        NotificationCenter.default.addObserver(self, selector: selector, name:NSNotification.Name(rawValue: KVSideMenu.Notifications.close), object: nil)
       
       // Deepak Commented
       //setupGestureRecognizer()
        
        clipsToBounds = false
        
        leftContainerView.backgroundColor   = backgroundColor
        centerContainerView.backgroundColor = backgroundColor
        rightContainerView.backgroundColor  = backgroundColor
        
        // addSubview order maitter for side shadow
        addSubview(leftContainerView)
        addSubview(rightContainerView)
        addSubview(centerContainerView)
        
        // apply constraints vai oprator overloading.
        leftContainerView   +== [ .top, .bottom ]
        centerContainerView +== [ .top, .bottom, .width, .centerX ]
        rightContainerView  +== [ .top, .bottom ]
        
        leftContainerView  +*== ( .width, KVSideMenuOffsetValueInRatio )
        rightContainerView +*== ( .width, KVSideMenuOffsetValueInRatio )
        
        leftContainerView   <==> (.trailing, .leading, centerContainerView, 0)
        centerContainerView <==> (.trailing, .leading, rightContainerView,  0)
        
    }
    
    // MARK: - Deinitialization
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: KVSideMenu.Notifications.close), object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: KVSideMenu.Notifications.toggleLeft), object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: KVSideMenu.Notifications.toggleRight), object: nil)
    }
    
    // Must be public or internal but not private other wise app will crashed.
    func didReceivedNotification(_ notify:Notification)
    {
        print("\(notify)")
        print("\(notify.name)")
        print("\(notify.object)")
        print("\(notify.userInfo)")
        
        if (notify.name.rawValue == KVSideMenu.Notifications.toggleLeft as String)
        {
            toggleLeftSideMenu()
        } else if (notify.name.rawValue == KVSideMenu.Notifications.toggleRight as String)
        {
            toggleRightSideMenu()
        } else if (notify.name.rawValue == KVSideMenu.Notifications.close as String)
        {
            closeSideMenu()
        }
        else{
            
        }
    }
    
    /// Close the side menu if the menu is showed.
    open func closeSideMenu()
    {
        
        switch (currentSideMenuState)
        {
        case .left:  closeOpenedSideMenu(leftContainerView,  attribute: .leading)
        case .right: closeOpenedSideMenu(rightContainerView, attribute: .trailing)
            
        default: appliedConstraint?.constant = 0
        applyAnimations({
            self.centerContainerView.transform = CGAffineTransform.identity
        })
        }
        
    }
    
    /// Toggles the state (open or close) of the left side menu.
    open func toggleLeftSideMenu()
    {
        if allowRightPaning
        {
            endEditing(true)
            backgroundColor  = leftContainerView.subviews.first?.backgroundColor
            
            if (currentSideMenuState == .right) {
                closeOpenedSideMenu(rightContainerView, attribute: .trailing)
            }
            
            centerContainerView.accessAppliedConstraintBy(attribute: .centerX)  { (appliedConstraint) -> Void in
                if appliedConstraint != nil {
                    self.currentSideMenuState = .left
                    
                    self.centerContainerView.superview! - appliedConstraint!
                    self.leftContainerView +== .leading
                    
                    self.handelTransformAnimations()
                }
                else {
                    
                    NotificationCenter.default.post(name: Notification.Name("SlideCloseHomeview"), object: nil,userInfo:nil)

                    self.closeOpenedSideMenu(self.leftContainerView, attribute: .leading, completion: { _ in
                        self.applyAnimations({
                            self.centerContainerView.transform = CGAffineTransform.identity
                        })
                    })
                }
            }
        }
        else {
            debugPrint("Left SideMenu has beed disable, because leftSideMenuViewController is nil.")
        }
        
    }
    
    /// Toggles the state (open or close) of the right side menu.
    open func toggleRightSideMenu()
    {
        if allowLeftPaning
        {
            endEditing(true)
            backgroundColor  = rightContainerView.subviews.first?.backgroundColor
            
            if (currentSideMenuState == .left) {
                closeOpenedSideMenu(leftContainerView, attribute: .leading)
            }
            
            centerContainerView.accessAppliedConstraintBy(attribute: .centerX) { (appliedConstraint) -> Void in
                if appliedConstraint != nil {
                    self.currentSideMenuState = .right
                    
                    self.centerContainerView.superview! - appliedConstraint!
                    self.rightContainerView +== .trailing
                    
                    self.handelTransformAnimations()
                }
                else {
                    self.closeOpenedSideMenu(self.rightContainerView, attribute: .trailing, completion: { _ in
                        self.applyAnimations({
                            self.centerContainerView.transform = CGAffineTransform.identity
                        })
                    })
                }
            }
        }
        else{
            debugPrint("Right SideMenu has beed disable, because rightSideMenuViewController is nil.")
        }
    }
    
    fileprivate func handelTransformAnimations()
    {
        if self.animationType == KVSideMenu.AnimationType.default
        {
            // update Top And Bottom Pin Constraints Of SideMenu
            (centerContainerView +== .bottom).constant = 0
            (centerContainerView +== .top).constant    = 0
            // this valus is fixed for orientation so try to avoid it
        }
        
        self.applyAnimations({
            
            if self.animationType == KVSideMenu.AnimationType.folding
            {
                self.applyTransformAnimations(self.centerContainerView, transform_d: self.transformScale.d )
            }
            else if self.animationType == KVSideMenu.AnimationType.default
            {
              //  self.applyTransform3DAnimations(self.centerContainerView, transformRotatingAngle: -22.5)
            }
            else{
                
            }
        })
    }
    
    
}

// MARK: -  Helpper Methods to Open & Close the SideMenu

extension KVMenuContainerView: UIGestureRecognizerDelegate
{
    // MARK: Gesture recognizer
    
    fileprivate func setupGestureRecognizer()
    {
        if allowPanGesture {
            panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(KVMenuContainerView.handlePanGesture(_:)))
        }
    }
    
    fileprivate dynamic func handlePanGesture(_ recognizer: UIPanGestureRecognizer)
    {
        let translation = recognizer.translation(in: recognizer.view)
        
        switch(recognizer.state)
        {
        case .began:
            switch (currentSideMenuState)
            {
            case .left:
                appliedConstraint = leftContainerView.accessAppliedConstraintBy(attribute: .leading)
            case .right:
                appliedConstraint = rightContainerView.accessAppliedConstraintBy(attribute: .trailing)
            default:
                appliedConstraint = centerContainerView.accessAppliedConstraintBy(attribute: .centerX)
            }
            
        case .changed:
            
            if appliedConstraint != nil {
                var xPoint : CGFloat = appliedConstraint!.constant + translation.x
                
                switch (currentSideMenuState)
                {
                case .left:
                    xPoint = max(-leftContainerView.bounds.width, min(CGFloat(xPoint), 0))
                    
                case .right:
                    xPoint = max(0, min(CGFloat(xPoint), rightContainerView.bounds.width))
                    
                default:
                    
                    if allowLeftPaning && allowRightPaning {
                        xPoint = max(-rightContainerView.bounds.width, min(CGFloat(xPoint), leftContainerView.bounds.width))
                    }
                    else if allowLeftPaning {
                        xPoint = max(-leftContainerView.bounds.width, min(CGFloat(xPoint), 0))
                    }
                    else if allowRightPaning {
                        xPoint = max(0, min(CGFloat(xPoint), rightContainerView.bounds.width))
                    }
                    else {
                        xPoint = max(0, min(CGFloat(xPoint), 0))
                    }
                    
                }
                
                if animationType == KVSideMenu.AnimationType.folding
                {
                    let dy = abs(CGFloat(Int(xPoint)))*(1.0 - transformScale.d)/leftContainerView.bounds.width
                    debugPrint(dy)
                    
                    if (currentSideMenuState == .left || currentSideMenuState == .right) {
                        applyTransformAnimations(centerContainerView, transform_d: min(1.0, transformScale.d + dy))
                    }
                    else{
                        applyTransformAnimations(centerContainerView, transform_d: min(1.0, abs(1-dy)) )
                    }
                }
                
                self.appliedConstraint?.constant = CGFloat(Int(xPoint))
                recognizer.setTranslation(CGPoint.zero, in: self)
            }
            
        default:
            
            let constaint = appliedConstraint?.constant ?? 0
            
            switch (currentSideMenuState)
            {
            case .left:     // Negative value
                if abs(constaint) > leftContainerView.bounds.width*thresholdFactor {
                    self.toggleLeftSideMenu();
                }else{
                    // Keep open left SideMenu here
                    self.appliedConstraint?.constant = 0
                    self.handelTransformAnimations()
                }
                
            case .right:    // Possitive value
                if constaint > rightContainerView.bounds.width*thresholdFactor {
                    self.toggleRightSideMenu();
                }else{
                    // Keep open right SideMenu here
                    self.appliedConstraint?.constant = 0
                    self.handelTransformAnimations()
                }
                
            default:  // None state
                if constaint > 0
                {
                    if constaint > leftContainerView.bounds.width*thresholdFactor {
                        self.toggleLeftSideMenu();
                    }else{
                        self.closeSideMenu()
                    }
                }
                else if constaint < 0
                {
                    if abs(constaint) > rightContainerView.bounds.width*thresholdFactor {
                        self.toggleRightSideMenu();
                    }else{
                        self.closeSideMenu()
                    }
                }
            }
            
            appliedConstraint = nil
        }
        
    }
    
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panRecognizer {
            return (allowPanGesture && (allowLeftPaning || allowRightPaning ))
        }
        
        return false
    }
    
}

// MARK: -  Helpper methods to Open & Close the SideMenu

private extension KVMenuContainerView
{
    func closeOpenedSideMenu(_ view:UIView, attribute attr: NSLayoutAttribute, completion: ((Void) -> Void)? = nil )
    {
        view.accessAppliedConstraintBy(attribute: attr, completionHandler: { (appliedConstraint) -> Void in
            if appliedConstraint != nil {
                self.currentSideMenuState = .none
                view.superview! - appliedConstraint!
                self.centerContainerView +== [.top, .centerX, .bottom]
                if completion == nil {
                    self.layoutIfNeeded()
                    self.setNeedsLayout()
                }else{
                    completion?()
                }
            }
        })
    }
    
}

// MARK: -  Helpper methods to apply animation & shadow with SideMenu

private extension KVMenuContainerView
{
    func applyAnimations(_ completionHandler: ((Void) -> Void)? = nil)
    {
        // let options : UIViewAnimationOptions = [.AllowUserInteraction, .OverrideInheritedCurve, .LayoutSubviews, .BeginFromCurrentState, .CurveEaseOut]
        
        let options : UIViewAnimationOptions = [.allowUserInteraction, .layoutSubviews, .beginFromCurrentState, .curveLinear, .curveEaseOut]
        let duration = TimeInterval(self.KVSideMenuHideShowDuration)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 10, options: options, animations: { _ in
            self.layoutIfNeeded()
            self.setNeedsLayout()
            self.setNeedsUpdateConstraints()
            self.applyShadow(self.centerContainerView)
            completionHandler?()
            }, completion: nil)
    }
    
    func applyTransformAnimations(_ view:UIView!,transform_d:CGFloat) {
        view.transform.d = transform_d
    }
    
    func applyTransform3DAnimations(_ view:UIView!,transformRotatingAngle:CGFloat)
    {
        let layerTemp : CALayer = view.layer
        layerTemp.zPosition = 1000
        
        var tRotate : CATransform3D = CATransform3DIdentity
        tRotate.m34 = 1.0/(500)
        
        let aXpos: CGFloat = CGFloat(22.5*((currentSideMenuState == .right) ? -1.0 : 1.0)*(M_PI/180))
        tRotate = CATransform3DRotate(tRotate,aXpos, 0, 1, 0)
        layerTemp.transform = tRotate
        
    }
    
    func applyShadow(_ shadowView:UIView)
    {
        let shadowViewLayer : CALayer = shadowView.layer
        shadowViewLayer.shadowColor = shadowView.backgroundColor?.cgColor
        shadowViewLayer.shadowOpacity = 0.4
        shadowViewLayer.shadowRadius = 4.0
       // shadowViewLayer.rasterizationScale = (self.window?.screen.scale)!
        
        if (self.currentSideMenuState == .left) {
            shadowViewLayer.shadowOffset = CGSize(width: -2, height: 2)
        } else if (self.currentSideMenuState == .right){
            shadowViewLayer.shadowOffset = CGSize(width: 0, height: 2)
        } else {
            shadowViewLayer.shadowRadius = 3
            shadowViewLayer.shadowOpacity = 0
            shadowViewLayer.shadowOffset = CGSize(width: 0, height: -3)
            shadowViewLayer.shadowColor = nil
        }
    }
    
    
}

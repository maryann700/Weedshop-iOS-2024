//
//  SideMenuViwController.swift
//  KVRootBaseSideMenu-Swift
//
//  Created by Keshav on 7/3/16.
//  Copyright © 2016 Keshav. All rights reserved.
//

public extension KVSideMenu
{
    // Here define the roots identifier of side menus that must be connected from KVRootBaseSideMenuViewController
    // In Storyboard using KVCustomSegue
    
    
    static public let leftSideViewController   =  "LeftSideMenu"
    static public let rightSideViewController  =  "CartVC"
    
    struct RootsIdentifiers
    {
        static public let initialViewController  =  "HomeviewVC"
        
        // All roots viewcontrollers
        static public let HomeviewVC    =  "HomeviewVC"
        static public let ProfileVC   =  "ProfileVC"
        static public let OrderHistory   =  "OrderHistoryVC"
//        static public let thirdViewController   =   "VideoVC"
    }
    
}

class SideMenuViewController: KVRootBaseSideMenuViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure The SideMenu
        
//        if AppSettings.MenuIconPosition == "Left"
//        {
            leftSideMenuViewController  =  self.storyboard?.instantiateViewController(withIdentifier: KVSideMenu.leftSideViewController)

//        }
//        else
//        {
//            rightSideMenuViewController =  self.storyboard?.instantiateViewController(withIdentifier: KVSideMenu.rightSideViewController)
//
//        }
        
        // Set default root
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.initialViewController)
        
        // Set freshRoot value to true/false according to your roots managment polity. By Default value is false.
        // If freshRoot value is ture then we will always create a new instance of every root viewcontroller.
        // If freshRoot value is ture then we will reuse already created root viewcontroller if exist otherwise create it.
        
        // self.freshRoot = true
        
    }
}




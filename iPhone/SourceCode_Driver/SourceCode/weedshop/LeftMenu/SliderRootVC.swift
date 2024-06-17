//
//  SliderRootVC.swift
//  weedshop
//
//  Created by Devubha Manek on 16/03/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class SliderRootVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.performSegue(withIdentifier: "SlideMenu", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

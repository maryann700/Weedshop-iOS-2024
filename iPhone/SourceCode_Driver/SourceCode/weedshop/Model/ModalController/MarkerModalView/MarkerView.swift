//
//  MarkerView.swift
//  weedshop
//
//  Created by Devubha Manek on 18/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit


class MarkerView: UIView {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var imag: UIImageView!
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var img_marker: UIImageView!
    
 
    class func instanceFromNib(Marker_image:UIImage,Window_image:UIImage,MakerTitle:String,Window_title:String) -> MarkerView {
        //return
        
        let view : MarkerView = UINib(nibName: "MarkerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MarkerView
        view.img_marker.image = Marker_image
        view.imag.image = Window_image
        view.lbl_title.text = Window_title
        view.subLbl.text = MakerTitle
        return view
        
    }
//    func custom_marker(Marker_image:UIImage,Window_image:UIImage,MakerTitle:String,Window_title:String) -> UIView{
//       
//    }
    
}




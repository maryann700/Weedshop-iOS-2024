//
//  MarkerSmallView.swift
//  weedshop
//
//  Created by Devubha Manek on 19/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class MarkerSmallView: UIView {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imag_wind: UIImageView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var img_marker: UIImageView!
    
    
    class func instanceFromNibSmall(Marker_image:UIImage,Window_image:UIImage,MakerTitle:String,Window_title:String) -> MarkerSmallView {
      
        let view : MarkerSmallView = UINib(nibName: "MarkerSmallView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MarkerSmallView
        view.img_marker.image = Marker_image
        view.imag_wind.image = Window_image
        view.title.text = Window_title
        view.subtitle.text = MakerTitle
        
        return view
        
    }


}

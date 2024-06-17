//
//  OrderHistory.swift
//  weedshop
//
//  Created by Devubha Manek on 03/04/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit


class Filter: NSObject, NSCoding
{
    var title: String = ""
    var id: String = ""
    var status: String = ""
    var isSelected: Bool = false
    
    struct KeyOrderHistoryFilter
    {
        static let title = "title"
        static let id = "is"
        static let status = "status"
        static let isSelected = "isSelected"
    }
    
    override init() {
        
        self.title = ""
        self.id = ""
        self.status = ""
        self.isSelected = false
    }
    
    init(title: String, id: String,status: String ,isSelected: Bool)
    {
        self.title = title
        self.id = id
        self.status = status
        self.isSelected = isSelected
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(title, forKey: KeyOrderHistoryFilter.title)
        aCoder.encode(id, forKey: KeyOrderHistoryFilter.id)
        aCoder.encode(status, forKey: KeyOrderHistoryFilter.status)
        aCoder.encode(isSelected, forKey: KeyOrderHistoryFilter.isSelected)
        
    }
    required convenience init?(coder aDecoder: NSCoder)
    {
        let title = aDecoder.decodeObject(forKey: KeyOrderHistoryFilter.title) as? String
        let id = aDecoder.decodeObject(forKey: KeyOrderHistoryFilter.id) as? String
        let status = aDecoder.decodeObject(forKey: KeyOrderHistoryFilter.status) as? String
        let isSelected = aDecoder.decodeObject(forKey: KeyOrderHistoryFilter.isSelected) as? Bool
        
        self.init(title: title!, id: id!, status: status!, isSelected: isSelected!)
    }
}

//
//  Item.swift
//  Yaddoey
//
//  Created by Khalid SH on 25/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import Foundation

class Item: Codable{
    var title: String = ""
    var done:Bool = false
    
    init(_ title: String){
        self.title = title
    }
}

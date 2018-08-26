//
//  Category.swift
//  Yaddoey
//
//  Created by Khalid SH on 26/08/2018.
//  Copyright © 2018 Khalid SH. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

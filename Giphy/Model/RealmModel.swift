//
//  RealmModel.swift
//  Giphy
//
//  Created by Ferrakkem Bhuiyan on 2020-11-23.
//

import Foundation
import RealmSwift

class RealmModel:Object {
    @objc dynamic var title = ""
    @objc dynamic var image = ""
    @objc dynamic var id = ""
    @objc dynamic var isFavourite:Bool = false
    
    
    override class func primaryKey() -> String {
        return "id"
    }
    
}


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
    

}



/*
 override class func primaryKey() -> String {
     return "id"
 }
 
 
 
 func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(RealmModel.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
 */
/*
let newGipy = RealmModel()
newGipy.title = giphy.title
newGipy.isFavourite = false
newGipy.image = giphy.images.original.url
newGipy.id = newGipy.incrementID()
trendingViewModel.save(gipy: newGipy)
cell.delegate = self
cell.favouriteBtn.tag = newGipy.id
*/

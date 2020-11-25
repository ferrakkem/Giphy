//
//  PopularMovieViewModel.swift
//  Rest API
//
//  Created by Ferrakkem Bhuiyan on 2020-10-30.
//  Copyright © 2020 Niso. All rights reserved.
//

import Foundation
import RealmSwift

class FavouritViewModel {
    
    let realm = try! Realm()
    var favouritGip: Results<RealmModel>?
    
    func loadGiphies(){
        print("loadInformation 2")
        favouritGip = realm.objects(RealmModel.self)
        //favouritGip = realm.objects(RealmModel.self).filter(NSPredicate(format: "%K == true", "isFavourite"))
    }
    

    func numberOfRowsInSection(section: Int) -> Int {
        if favouritGip!.count != 0 {
            return favouritGip!.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> RealmModel {
        print(favouritGip![indexPath.row])
        return favouritGip![indexPath.row]
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return favouritGip!.count
    }

    func didSelect(at indexPath: Int) -> RealmModel {
        return favouritGip![indexPath]
    }
    
}

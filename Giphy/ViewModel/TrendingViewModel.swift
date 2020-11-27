//
//  TrendingViewModel.swift
//  Giphy
//
//  Created by Ferrakkem Bhuiyan on 2020-11-21.
//

import Foundation
import RealmSwift

class TrendingViewModel{
    private var apiService = NetwrokManager()
    private var treadingGiphies = [Datum]()
    
    //var realmModel = [RealmModel]()
    let realm = try! Realm()
    var searchGip: Results<RealmModel>?
    
    //MARK: -
    func fetchGipData(page: Int, completion: @escaping () -> ()) {
        // weak self - prevent retain cycles
        apiService.getTrendingGiphy(pageNumber: page) { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                print("success")
                self?.treadingGiphies = listOf.data
                completion()
            //self?.addProduct()
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
    
    //MARK: - Save data
    func numberOfRowsInSection(section: Int) -> Int {
        if treadingGiphies.count != 0 {
            return treadingGiphies.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Datum {
        return treadingGiphies[indexPath.row]
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return treadingGiphies.count
    }
    
    func didSelect(at indexPath: Int) -> Datum {
        return treadingGiphies[indexPath]
    }
    
    
    //MARK: - Saving favourite gip
    func saveFavGipyToLocal(title: String, isFavourite: Bool, imageUrl: String, gipyId: String ){
        let favGipy = RealmModel()
        favGipy.title = title
        favGipy.isFavourite = isFavourite
        favGipy.image = imageUrl
        favGipy.id = gipyId
        save(gipy: favGipy)
    }
    
    func save(gipy: RealmModel){
        
        do{
            try realm.write{
                realm.add(gipy)
                //realm.add(gipy, update: Realm.UpdatePolicy.modified)
            }
        }catch{
            print("Error during saving time: \(error)")
        }
    }
    
    //MARK: - Checking object is Exists or by primarykey
    func objectExists(id: String) -> Bool{
        return realm.object(ofType: RealmModel.self, forPrimaryKey: id) != nil
    }
    
    func searchGip(indexPath: IndexPath) -> Datum {
        //print("Status: \(searchGip)")
        return treadingGiphies[indexPath.row]
    }
    
    //MARK: - Delete records
    func deleteRecord(gipy: RealmModel) {
        // Persist your data easily
        try! realm.write {
            realm.delete(gipy)
        }
    }
    
    
    
    func updateData(gipyId: Int){
        try! realm.write {
            realm.create(RealmModel.self, value: ["id": gipyId, "isFavourite": true], update: .modified)
            // the book's `title` property will remain unchanged.
        }
    }
}

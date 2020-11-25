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
    
    
    
    func fetchNowPlayingMoviesData(page: Int, completion: @escaping () -> ()) {
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
    
    func save(gipy: RealmModel){
        
        do{
            try realm.write{
                realm.add(gipy)
            }
        }catch{
            print("Error during saving time: \(error)")
        }
    }
    
    func objectExists(id: String) -> Bool{
        return realm.object(ofType: RealmModel.self, forPrimaryKey: id) != nil
    }
    
    func searchGip(indexPath: IndexPath) -> Datum {
        //print("Status: \(searchGip)")
        return treadingGiphies[indexPath.row]
    }
    
    func deleteRecord(gipy: RealmModel) {
        // Persist your data easily
        try! realm.write {
            realm.delete(gipy)
            //delegate?.RecordDeleted() // Notify for succesful deletion
        }
    }
    
    
}

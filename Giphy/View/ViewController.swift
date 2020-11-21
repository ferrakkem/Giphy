//
//  ViewController.swift
//  Giphy
//
//  Created by Ferrakkem Bhuiyan on 2020-11-21.
//

import UIKit

class ViewController: UIViewController {

    private var apiService = NetwrokManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        //calling
        setUpBar()
        
        apiService.getTrendingGiphy { (result) in
            switch result{
            
            case .success(let giphy):
                giphy.data.forEach { (gip) in
                    print(gip.title)
                    print(gip.images.original.url)
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - setup navigationController
    func setUpBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

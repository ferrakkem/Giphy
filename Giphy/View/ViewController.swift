//
//  ViewController.swift
//  Giphy
//
//  Created by Ferrakkem Bhuiyan on 2020-11-21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //calling
        setUpBar()
        
    }
    
    //MARK: - setup navigationController
    func setUpBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    

}



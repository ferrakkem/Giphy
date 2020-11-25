//
//  FavouritesCollectionViewController.swift
//  Giphy
//
//  Created by Ferrakkem Bhuiyan on 2020-11-24.
//

import UIKit
import SkeletonView

class FavouritesCollectionViewController: UIViewController {
    
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    
    private var favViewModel = FavouritViewModel()
    private var trendingViewModel = TrendingViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("FavouritesCollectionViewController")
        setUpBar()
        loadInformation()
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    //MARK: - setup navigationController
    func setUpBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func loadInformation(){
        print("loadInformation 1")
        favViewModel.loadGiphies()
        favouritesCollectionView.dataSource = self
        favouritesCollectionView.delegate = self
        favouritesCollectionView.reloadData()
    }
    
    @IBAction func refereshButtonPressed(_ sender: UIBarButtonItem) {
        loadInformation()
    }
    
}
//MARK: - UICollectionView
extension  FavouritesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if favViewModel.numberOfRows(inSection: section) == 0{
            self.favouritesCollectionView.setEmptyMessage("Nothing to show :(")
        } else {
            self.favouritesCollectionView.restore()
        }
        return favViewModel.numberOfRows(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = favouritesCollectionView.dequeueReusableCell(withReuseIdentifier: K.favouritesGiphyCellIdentifier, for: indexPath) as! FavouritesCollectionViewCell
        
        let favGip = favViewModel.cellForRowAt(indexPath: indexPath)
        print("*favGip*** \(favGip)")
        cell.setCellWithValuesOfCollection(with: favGip)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let value = favViewModel.cellForRowAt(indexPath: indexPath)
        print("***collectionView \(value)")
        trendingViewModel.deleteRecord(gipy: value)
        favouritesCollectionView.reloadData()
        self.openAlert(title: "Alert",
                              message: "Deleted as your favpurite",
                              alertStyle: .alert,
                              actionTitles: ["Okay", "Cancel"],
                              actionStyles: [.default, .cancel],
                              actions: [
                                  {_ in
                                       print("okay")
                                  },
                                  {_ in
                                       print("cancel")
                                  }
                             ])

      
    }
}


extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}

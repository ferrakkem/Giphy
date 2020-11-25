//
//  FavouritesCollectionViewCell.swift
//  Giphy
//
//  Created by Ferrakkem Bhuiyan on 2020-11-24.
//

import UIKit
import SwiftGifOrigin

class FavouritesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gipImage: UIImageView!
    @IBOutlet weak var cellView: UIImageView!
    @IBOutlet weak var unFavourite: UIButton!
    
    
    var customView = CustomView()
    var roundedRectButton = RoundedRectButton()
    
    @IBAction func makeUnFavourite(_ sender: UIButton) {
        
    }
    
    private var urlString: String = ""
    // Setup movies values
    func setCellWithValuesOfCollection(with giphy: RealmModel) {
        print("popularMovie***** \(giphy)")
 
        updateUI(poster: giphy.image)
        
    }
    // Update the UI Views
    private func updateUI(poster: String?) {
        
        //self.movieOverview.text = overview
        
        guard let posterString = poster else {return}
        urlString = posterString
        
        guard let posterImageURL = URL(string: urlString) else {
            self.gipImage.image = UIImage(named: "noImageAvailable")
            return
        }
        
        // Before we download the image we clear out the old one
        self.gipImage.image = nil
        getImageDataFrom(url: posterImageURL)
        
        customView.shadowDecorate(userview: cellView)
        roundedRectButton.customBtn(userBtn: unFavourite)
        
    }
    
    // MARK: - Get image data
    private func getImageDataFrom(url: URL) {
        print("****url \(url)")
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage.gif(data: data) {
                    self.gipImage.image = image
                }
            }
        }.resume()
    }

}

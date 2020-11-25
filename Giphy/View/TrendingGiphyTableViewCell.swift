//
//  TrendingGiphyTableViewCell.swift
//  Giphy
//
//  Created by Ferrakkem Bhuiyan on 2020-11-21.
//

import UIKit
import SwiftGifOrigin

protocol YourCellDelegate: class {
    func didTapButton(_ sender: UIButton)
}

class TrendingGiphyTableViewCell: UITableViewCell {
    
    weak var delegate: YourCellDelegate?
    
    @IBOutlet weak var giphyImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var favouriteBtn: UIButton!
    
    var customView = CustomView()
    var roundedRectButton = RoundedRectButton()
    
        
    private var urlString: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Setup movies values
    func setCellWithValuesOf(_ giphy :Datum) {
        print("giphy***** \(giphy)")
        updateUI(title: giphy.title, poster: giphy.images.downsizedLarge.url)
    }
    
    // Update the UI Views
    private func updateUI(title: String?,  poster: String) {
        self.title.text = title
        
        urlString = poster
        
        guard let posterImageURL = URL(string: urlString) else {
            self.giphyImage.image = UIImage(named: "noImageFound")
            return
        }
        
        // Before we download the image we clear out the old one
        self.giphyImage.image = nil
        getImageDataFrom(url: posterImageURL)
        customView.customView(userview: cardView)
        roundedRectButton.customBtn(userBtn: favouriteBtn)
        
    }
    // MARK: - Get image data
    private func getImageDataFrom(url: URL) {
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
                if let image = UIImage.gif(data: data){
                    self.giphyImage.image = image
                }
            }
        }.resume()
    }
    
    @IBAction func makeFavouriteButtonPressed(_ sender: UIButton) {
        delegate?.didTapButton(sender)
    }
}

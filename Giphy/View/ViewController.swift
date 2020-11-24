//
//  ViewController.swift
//  Giphy
//
//  Created by Ferrakkem Bhuiyan on 2020-11-21.
//

import UIKit

class ViewController: UIViewController {

    private var apiService = NetwrokManager()
    private var trendingViewModel = TrendingViewModel()
    
    @IBOutlet weak var trendingGipyTableView: UITableView!
    
    var limit : Int = 25
    var isLoadingList : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //calling
        setUpBar()
        //trendingViewModel.addProduct()
//        apiService.getTrendingGiphy { (result) in
//            switch result{
//
//            case .success(let giphies):
//                giphies.data.forEach { (giphy) in
//                    print(giphy.title)
//                    print(giphy.images.original.url)
//                    print(giphy.trendingDatetime)
//                    print(giphy.type)
//                    print("rating: \(giphy.rating)")
//                    print("------------------------")
//
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        
        //loadMoreItemsForList()
        
        loadNowPlayMoviesData(pageNumber: limit)

    }
    
    func loadMoreItemsForList(){
        limit += 25
        print("currentPage: \(limit)")
        loadNowPlayMoviesData(pageNumber: limit)
    }
    
    //MARK: - setup navigationController
    func setUpBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func loadNowPlayMoviesData(pageNumber: Int) {
        trendingViewModel.fetchNowPlayingMoviesData(page: pageNumber) { [weak self] in
            self?.isLoadingList = false
            self?.trendingGipyTableView.dataSource = self
            self?.trendingGipyTableView.delegate = self
            //self?.tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            self?.trendingGipyTableView.reloadData()
        }
    }
    
}

// MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingViewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = trendingGipyTableView.dequeueReusableCell(withIdentifier: K.cellReuseIdentifier, for: indexPath) as! TrendingGiphyTableViewCell
        
        let giphy = trendingViewModel.cellForRowAt(indexPath: indexPath)
        print("giphy:::: \(giphy)")
        cell.setCellWithValuesOf(giphy)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.loadMoreItemsForList()
        }
    }
    
}

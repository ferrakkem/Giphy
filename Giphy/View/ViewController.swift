//
//  ViewController.swift
//  Giphy
//
//  Created by Ferrakkem Bhuiyan on 2020-11-21.
//

import UIKit
import SkeletonView
import RealmSwift


class ViewController: UIViewController {
    
    let realm = try! Realm()
    var searchGip: Results<RealmModel>?
    
    private var apiService = NetwrokManager()
    private var trendingViewModel = TrendingViewModel()
    
    @IBOutlet weak var trendingGipyTableView: UITableView!
    
    var limit : Int = 25
    var isLoadingList : Bool = false
    
    
    var filteredData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //calling
        setUpBar()
        
        //loadMoreItemsForList()
        loadNowPlayMoviesData(pageNumber: limit)
        trendingGipyTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    //MARK: - setup navigationController
    func setUpBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func loadMoreItemsForList(){
        limit += 25
        print("currentPage: \(limit)")
        loadNowPlayMoviesData(pageNumber: limit)
        
    }
    
    func loadNowPlayMoviesData(pageNumber: Int) {
        trendingViewModel.fetchNowPlayingMoviesData(page: pageNumber) { [weak self] in
            self?.isLoadingList = false
            self?.trendingGipyTableView.dataSource = self
            self?.trendingGipyTableView.delegate = self
            self?.trendingGipyTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.50))
            self?.trendingGipyTableView.reloadData()
        }
    }
    
}

// MARK: - TableView
extension ViewController: UITableViewDelegate, SkeletonTableViewDataSource, UIScrollViewDelegate, YourCellDelegate {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return K.cellReuseIdentifier
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingViewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = trendingGipyTableView.dequeueReusableCell(withIdentifier: K.cellReuseIdentifier, for: indexPath) as! TrendingGiphyTableViewCell
        
        let giphy = trendingViewModel.cellForRowAt(indexPath: indexPath)
        //print("giphy:::: \(giphy)")
        cell.setCellWithValuesOf(giphy)
        cell.delegate = self
        return cell
    }
    
    
    func didTapButton(_ sender: UIButton) {
        
        if let indexPath = getCurrentCellIndexPath(sender) {
            print(indexPath.row)
            let giphy = trendingViewModel.didSelect(at: indexPath.row)
            
            let isExists = trendingViewModel.objectExists(id: giphy.id)
            
            if isExists {
                self.openAlert(title: "Exist",
                                      message: "Already Added",
                                      alertStyle: .alert,
                                      actionTitles: ["Okay", "Cancel"],
                                      actionStyles: [.default, .cancel],
                                      actions: [
                                          {_ in
                                               //print("okay")
                                          },
                                          {_ in
                                               //print("cancel")
                                          }
                                     ])
            }else{
                let newGipy = RealmModel()
                newGipy.title = giphy.title
                newGipy.isFavourite = true
                newGipy.image = giphy.images.original.url
                newGipy.id = giphy.id
                trendingViewModel.save(gipy: newGipy)
                
                self.openAlert(title: "Successfully",
                                      message: "Added",
                                      alertStyle: .alert,
                                      actionTitles: ["Okay", "Cancel"],
                                      actionStyles: [.default, .cancel],
                                      actions: [
                                          {_ in
                                               //print("okay")
                                          },
                                          {_ in
                                               //print("cancel")
                                          }
                                     ])
            }
                        
        }
    }
    
    
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: trendingGipyTableView)
        if let indexPath: IndexPath = trendingGipyTableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            trendingGipyTableView.isSkeletonable = true
            trendingGipyTableView.showAnimatedSkeleton(usingColor: .gray, transition: .crossDissolve(0.200))
            self.loadMoreItemsForList()
            
            }
        }
    }
    
    //MARK: - UISearchBarDelegate
    extension ViewController: UISearchBarDelegate{
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            print("searchBarSearchButtonClicked")
            searchGip = searchGip?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "title ")
            trendingGipyTableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("searchBar")
            if searchBar.text?.count == 0{
                //loadTodoList()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
    }
    
extension UIViewController{
    public func openAlert(title: String,
                          message: String,
                          alertStyle:UIAlertController.Style,
                          actionTitles:[String],
                          actionStyles:[UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)]){

        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        self.present(alertController, animated: true)
    }
}

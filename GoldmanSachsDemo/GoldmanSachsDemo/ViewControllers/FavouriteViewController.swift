//
//  FavouriteViewController.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import UIKit

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /// <#Description#>
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var favoriteList: [APODModel]? = PlistManager.sharedInstance.favouriteImages
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteList = PlistManager.sharedInstance.favouriteImages
        favoriteTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : FavoriteCell = tableView.dequeueReusableCell(withIdentifier: Constants.k_CELLIDENTIFIER, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        
        let obj = favoriteList?[indexPath.row]
        cell.dataModel = obj
        cell.titleLabel.text = obj?.title
        cell.dateLabel.text = obj?.date
        cell.imgView.image = #imageLiteral(resourceName: "loading")
        
        //Load Image for the cell
        cell.loadImage(fromImageURL: obj?.url) {
            tableView.beginUpdates()
            cell.setNeedsLayout()
            tableView.endUpdates()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteFavorite(obj: favoriteList?[indexPath.row])
        }
    }
    
    func deleteFavorite(obj: APODModel?) {
        guard let obj = obj else { return }
        var favoriteList = PlistManager.sharedInstance.favouriteImages
        guard let index = favoriteList.firstIndex(where: { $0.url == obj.url }) else { return }
        favoriteList.remove(at: index)
        PlistManager.sharedInstance.favouriteImages = favoriteList
        self.favoriteList = favoriteList
        favoriteTableView.reloadData()
        print("deleted")
    }
}

//
//  FavouriteViewController.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import UIKit

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var favoriteList: [APODModel]? = PlistManager.sharedInstance.readPlist()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteList = PlistManager.sharedInstance.readPlist()
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
}

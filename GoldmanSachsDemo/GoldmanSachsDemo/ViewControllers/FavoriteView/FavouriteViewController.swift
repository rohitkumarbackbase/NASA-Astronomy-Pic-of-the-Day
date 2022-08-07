//
//  FavouriteViewController.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import UIKit

// MARK: - 'FavouriteViewController'

/// Provides UI for displaying the favorite images
class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /// `UITableView` for faourite astronomy images .
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshFavoriteList()
        favoriteTableView.reloadData()
    }
    
    /// Tells the data source to return the number of rows in a given section of a table view.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - section: An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteList?.count ?? 0
    }
    
    /// Asks the data source for a cell to insert in a particular location of the table view.
    ///
    /// - Parameters:
    ///   - tableView: A tableView object requesting the cell.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: an object inheriting from UITableViewCell that the table view can use for the specified row. UIKit raises an assertion if you return nil.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : FavoriteCell = tableView.dequeueReusableCell(withIdentifier: Constants.k_CELLIDENTIFIER, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        
        let obj = viewModel.favoriteList?[indexPath.row]
        cell.dataModel = obj
        cell.setupCell()
        //Load Image for the cell
        cell.loadImage(fromImageURL: obj?.url) {
            tableView.beginUpdates()
            cell.setNeedsLayout()
            tableView.endUpdates()
        }
        return cell
    }
    
    /// Tells the data source to enable editing for the table view cells.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index number identifying a section in tableView.
    /// - Returns: cn edit or not that particular cell.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Inherited from UITableViewDataSource.tableView(_:commit:forRowAt:).
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - editingStyle: The editing control used by a cell.
    ///   - indexPath: An index path locating a row in tableView.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteFavorite(mdoel: viewModel.favoriteList?[indexPath.row])
        }
    }
    
    /// Removes the selected image from the favorites
    /// - Parameter model: Object to be removed form favorite
    func deleteFavorite(mdoel: APODModel?) {
        guard let obj = mdoel else { return }
        var favoriteList = PlistManager.sharedInstance.favouriteImages
        guard let index = favoriteList.firstIndex(where: { $0.url == obj.url }) else { return }
        favoriteList.remove(at: index)
        PlistManager.sharedInstance.favouriteImages = favoriteList
        viewModel.favoriteList = favoriteList
        favoriteTableView.reloadData()
        print("deleted")
    }
}

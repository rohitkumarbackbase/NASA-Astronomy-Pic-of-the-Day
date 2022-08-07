//
//  FavoriteViewModel.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import Foundation

// MARK: - 'FavoriteViewModel'

/// ViewModel describing function for Favorite list screen
class FavoriteViewModel {
    
    /// Array of `APODModel` fetched from the persistent memory
    var favoriteList: [APODModel]? = PlistManager.sharedInstance.favouriteImages
    
    /// Refreshes the fvorite list from PlistManager
    func refreshFavoriteList() {
        favoriteList = PlistManager.sharedInstance.favouriteImages
    }
}

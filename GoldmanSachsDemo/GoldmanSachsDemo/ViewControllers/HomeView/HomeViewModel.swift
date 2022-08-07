//
//  HomeViewModel.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import Foundation
import UIKit

// MARK: - 'HomeViewModel'

/// ViewModel describing function for Home screen
class HomeViewModel {
    
    /// Instance of `APODModel` for storing the image meta data
    var model: APODModel?
    
    /// Block to execute after image data fetched.
    var didLoadData: () -> Void = {}
    
    init() {
        loadImageData(for: nil)
    }
    
    /// Fetch data form the network for the selected date
    /// - Parameter date: String containg date for which image needed
    func loadImageData(for date: String?) {
        NetworkService.sharedInstance.fetchingImageData(for: date) { [weak self] (data) in
            self?.model = data
            self?.didLoadData()
        }
    }
}

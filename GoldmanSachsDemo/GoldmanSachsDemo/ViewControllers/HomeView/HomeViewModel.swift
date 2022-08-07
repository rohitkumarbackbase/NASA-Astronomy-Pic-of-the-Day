//
//  HomeViewModel.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import Foundation
import UIKit

class HomeViewModel {
    
    var dataModel: APODModel?
    
    /// Reload Logbook view.
    var didLoadData: () -> Void = {}
    
    /// Reload Logbook view.
    var didLoadImage: () -> Void = {}
    
    var image: UIImage
    
    init() {
        loadImageData(for: nil)
    }
    
    func loadImageData(for date: String?) {
        NetworkService.sharedInstance.fetchingData(for: date) { [weak self] (data) in
            self?.dataModel = data
            self?.didLoadData()
            self?.loadImage(fromImageURL: data.hdurl, completion: {
                print("image downloaded")
            })
        }
    }
}

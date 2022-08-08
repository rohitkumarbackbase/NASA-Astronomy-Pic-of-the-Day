//
//  ViewController.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 04/08/22.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

// MARK: - 'HomeViewController'

/// Provides UI for displaying the image of the day
class HomeViewController: UIViewController {
    
    /// `UIDatePicker` for selecting the date for whcih picture is to be fetxhed
    @IBOutlet weak var datePicker: UIDatePicker!
    
    /// `UIImageView` for displaying the image fetched
    @IBOutlet weak var imageView: UIImageView!
    
    /// `UILabel` for displaying the title text of the image
    @IBOutlet weak var titleLabel: UILabel!
    
    /// `UILabel` for displaying the explanation of the image
    @IBOutlet weak var explanationLabel: UILabel!
    
    /// `UIButton` for marking the image as favorite
    @IBOutlet weak var favoriteButton: UIButton!
    
    /// Instance of `HomeViewModel`
    var viewModel = HomeViewModel()
    
    /// Instance of `ImageCacheManager`
    var cacheManager = ImageCacheManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        viewModel.didLoadData = {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setText()
            weakSelf.loadImage(fromImageURL: weakSelf.viewModel.model?.url, completion: {
                print("Image downloaded")
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !Connectivity.isConnectedToInternet {
            let alert = UIAlertController(title: Constants.k_NOT_CONNECTED, message: Constants.k_NOT_CONNECTED_MSG, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Constants.k_DISMISS, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Selects the date from the date picker
    /// - Parameter sender: Represents `UIDatePicker` on which selection event occurred.
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        viewModel.loadImageData(for: sender.date.onlyDate)
        imageView.image = #imageLiteral(resourceName: "loading")
        favoriteButton.isSelected = false
        view.endEditing(true)
    }
    
    /// Marks the image as favorite
    ///
    /// - Parameter sender: Represents `UIButton`
    @IBAction func favoriteTapped(_ sender: Any) {
        guard let dataModel = viewModel.model else { return }
        favoriteButton.isSelected = !favoriteButton.isSelected
        if !favoriteButton.isSelected { return }
        var favoriteList = PlistManager.sharedInstance.readPlist()
        if !(favoriteList.contains(where: { $0.url == dataModel.url }))
        {
            favoriteList.append(dataModel)
            PlistManager.sharedInstance.favouriteImages = favoriteList
        }
    }
    
    /// Sets the text form the fetched data to the labels
    func setText() {
        DispatchQueue.main.async {
            self.titleLabel.text = self.viewModel.model?.title
            self.explanationLabel.text = self.viewModel.model?.explanation
            super.updateViewConstraints()
        }
    }

    /// Sets the fetched image to the image view
    /// - Parameter image: `UIImage` fetched from API
    private func displayImage(image : UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
            super.updateViewConstraints()
        }
    }
    
    /// Fetches image for the seletced date
    /// - Parameters:
    ///   - imageURL: URL fetched for the metadata of the image
    ///   - completion: Block to be executed after r\the image fetched
    func loadImage(fromImageURL imageURL: String? , completion: @escaping ()->()) {
        
        guard let imagePath = imageURL else {
            return
        }
        if let imageURL: URL = URL(string: imagePath) {
            if cacheManager.checkImageCacheExistance(fromURL: imagePath) {
                let imageData = cacheManager.fetchImageFromCache(imagePath: imagePath)
                displayImage(image: imageData)
                completion()
            } else {
                imageView.af_setImage(withURL: imageURL,
                                      imageTransition: .crossDissolve(0.5),
                                      runImageTransitionIfCached: true,
                                      completion: { response in
                    if response.result.error != nil {
                        self.cacheManager.saveImageIntoCache(imageURL: imagePath, withImageData: #imageLiteral(resourceName: "loading"))
                        self.displayImage(image: self.cacheManager.fetchImageFromCache(imagePath: imagePath))
                    } else {
                        if let imageToCache = response.result.value {
                            self.cacheManager.imageCache.setObject(imageToCache, forKey: imagePath as NSString)
                            completion()
                        }
                    }
                })
            }
        }
    }
}

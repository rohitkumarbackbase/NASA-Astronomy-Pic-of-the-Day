//
//  FavoriteCell.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import UIKit

// MARK: - 'FavoriteCell'

/// Provides custom UI for entry of selected favorite images
class FavoriteCell: UITableViewCell {
    
    /// `UIImageView` for displaying the favorite image
    @IBOutlet weak var imgView: UIImageView!
    /// `UILabel` for displaying the title of the image
    @IBOutlet weak var titleLabel: UILabel!
    /// `UILabel` for displaying the date of the image
    @IBOutlet weak var dateLabel: UILabel!
    /// Optional `APODModel` storing the image metadata
    var dataModel: APODModel?
    /// `ImageCacheManager` for accessing the cached images
    var cacheManager = ImageCacheManager()
 
    /// This will load image from cache
    ///
    /// - Parameter imageURL: path(URL) to load image form cache.
    private func displayImage(image : UIImage) {
        self.imgView.image = image
    }
    
    func setupCell() {
        titleLabel.text = dataModel?.title
        dateLabel.text = dataModel?.date
        imgView.image = #imageLiteral(resourceName: "loading")
    }
    
    /// Fetches the image form network if not availble in cache
    /// - Parameters:
    ///   - imageURL: `URL` of the image to be fetched
    ///   - completion: Block to be executed after the image fetched
    func loadImage(fromImageURL imageURL: String? , completion: @escaping ()->()) {
        
        guard let imagePath = imageURL else {
            return
        }
        if let imageURL: URL = URL(string: imagePath) {
            if cacheManager.checkImageCacheExistance(fromURL: imagePath) {
                let imageData = cacheManager.fetchImageFromCache(imagePath: imagePath)
                displayImage(image: imageData)
                setNeedsLayout()
                completion()
            }
            else{
                self.imgView.af_setImage(withURL: imageURL,
                                         imageTransition: .crossDissolve(0.5),
                                         runImageTransitionIfCached: true,
                                         completion: { response in
                                            if response.result.error != nil{
                                                self.cacheManager.saveImageIntoCache(imageURL: imagePath, withImageData: #imageLiteral(resourceName: "loading"))
                                                self.displayImage(image: self.cacheManager.fetchImageFromCache(imagePath: imagePath))
                                            } else {
                                                if let imageToCache = response.result.value{
                                                    self.cacheManager.imageCache.setObject(imageToCache, forKey: imagePath as NSString)
                                                    self.setNeedsLayout()
                                                    completion()
                                                }
                                            }
                })
            }
        }
    }
}

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

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var explanationLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!

    var cacheManager = ImageCacheManager()
    
    var dataModel: APODModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadImage(for: nil)
    }

    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        loadImage(for: sender.date.onlyDate)
        view.endEditing(true)
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        favoriteButton.isSelected = !favoriteButton.isSelected
        var favoriteList = PlistManager.sharedInstance.favouriteImages
        if !favoriteList.contains(where: { $0 in
            $0.url == dataModel.url
        }) {
            favoriteList.append(dataModel!)
        }
        
    }
    
    func loadImage(for date: String?) {
//        ImageCacheManager().restCache()
        NetworkService.sharedInstance.fetchingData(for: date) { [self] (data) in
            print(data)
            dataModel = data
            DispatchQueue.main.async {
                self.setText()
            }
            self.loadImage(fromImageURL: data.hdurl, completion: {
                print("image downloaded")
            })
        }
    }
    
    func setText() {
        self.titleLabel.text = self.dataModel?.title
        self.explanationLabel.text = self.dataModel?.explanation
        super.updateViewConstraints()
    }

    
    private func displayImage(image : UIImage) {
        self.imageView.image = image
    }
    
    func loadImage(fromImageURL imageURL: String? , completion: @escaping ()->()) {
        
        guard let imagePath = imageURL else {
            return
        }
        if let imageURL: URL = URL(string: imagePath) {
            if cacheManager.checkImageCacheExistance(fromURL: imagePath) {
                let imageData = cacheManager.fetchImageFromCache(imagePath: imagePath)
                displayImage(image: imageData)
                completion()
            }
            else{
                self.imageView.af_setImage(withURL: imageURL,
                                         imageTransition: .crossDissolve(0.5),
                                         runImageTransitionIfCached: true,
                                         completion: { response in
                                            if response.result.error != nil{
                                                self.cacheManager.saveImageIntoCache(imageURL: imagePath, withImageData: #imageLiteral(resourceName: "loading"))
                                                self.displayImage(image: self.cacheManager.fetchImageFromCache(imagePath: imagePath))
                                            } else {
                                                if let imageToCache = response.result.value{
                                                    self.cacheManager.imageCache.setObject(imageToCache, forKey: imagePath as NSString)
//                                                    self.setNeedsLayout()
                                                    completion()
                                                }
                                            }
                })
            }
        }
    }
}

extension Date {

    var onlyDate: String {
        
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: self)
        }
    }
}

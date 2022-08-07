//
//  PlistManager.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import Foundation

struct PlistManager {
    
    static let sharedInstance = PlistManager()
    
    var favouriteImages = [APODModel]()
    
    func pListCreation() {
        let fileManager = FileManager.default
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/favourite_images.json")
        
        if (!fileManager.fileExists(atPath: path)) {
            
            let dicContent: NSArray = [jsonString]
//            let plistContent = NSDictionary(dictionary: dicContent)
            let success:Bool = dicContent.write(toFile: path, atomically: true)
            if success {
                print("file has been created!")
            }else{
                print("unable to create the file")
            }
            
        }else{
            print("file already exist")
        }
    }
    
    func writePlist(array: [APODModel]) {
        var res: [[String: String?]] = []
        for obj in array {
            res.append(obj.toDict())
        }
        let dicContent = NSArray(array: res)
        
        let fileManager = FileManager.default
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/favourite_images.json")
        
        if (!fileManager.fileExists(atPath: path)) {
            let success:Bool = dicContent.write(toFile: path, atomically: true)
            if success {
                print("file has been created!")
            }else{
                print("unable to create the file")
            }
            
        } else {
            print("file already exist")
            let success:Bool = dicContent.write(toFile: path, atomically: true)
            if success {
                print("file has been edited!")
            }else{
                print("unable to create the file")
            }
        }

    }
    
    func readPlist() -> [APODModel]? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/favourite_images.json")
        let url = URL(fileURLWithPath: path)
        let obj = NSDictionary(contentsOf: url)
        print(obj)
        return [obj1]
    }
    
    let obj1 = APODModel(copyright: "Fritz\nHelmut Hemmerich",
                        date: "2022-08-07",
                        explanation: "What's that green streak in front of the Andromeda galaxy? A meteor. While photographing the Andromeda galaxy in 2016, near the peak of the Perseid Meteor Shower, a small pebble from deep space crossed right in front of our Milky Way Galaxy's far-distant companion. The small meteor took only a fraction of a second to pass through this 10-degree field.  The meteor flared several times while braking violently upon entering Earth's atmosphere.  The green color was created, at least in part, by the meteor's gas glowing as it vaporized. Although the exposure was timed to catch a Perseid meteor, the orientation of the imaged streak seems a better match to a meteor from the Southern Delta Aquariids, a meteor shower that peaked a few weeks earlier.  Not coincidentally, the Perseid Meteor Shower peaks later this week, although this year the meteors will have to outshine a sky brightened by a nearly full moon.",
                        hdurl: "https://apod.nasa.gov/apod/image/2208/MeteorM31_hemmerich_1948.jpg",
                        mediaType: "image",
                        serviceVersion: "v1",
                        title: "Meteor before Galaxy",
                        url: "https://apod.nasa.gov/apod/image/2208/MeteorM31_hemmerich_960.jpg")
    
    let jsonString = """
  {
    /"copyright/": /"Fritz\nHelmut Hemmerich/",
    /"date/": /"2022-08-07/",
    /"explanation/": /"What's that green streak in front of the Andromeda galaxy? A meteor. While photographing the Andromeda galaxy in 2016, near the peak of the Perseid Meteor Shower, a small pebble from deep space crossed right in front of our Milky Way Galaxy's far-distant companion. The small meteor took only a fraction of a second to pass through this 10-degree field.  The meteor flared several times while braking violently upon entering Earth's atmosphere.  The green color was created, at least in part, by the meteor's gas glowing as it vaporized. Although the exposure was timed to catch a Perseid meteor, the orientation of the imaged streak seems a better match to a meteor from the Southern Delta Aquariids, a meteor shower that peaked a few weeks earlier.  Not coincidentally, the Perseid Meteor Shower peaks later this week, although this year the meteors will have to outshine a sky brightened by a nearly full moon./",
    /"hdurl/": /"https://apod.nasa.gov/apod/image/2208/MeteorM31_hemmerich_1948.jpg/",
    /"media_type/": /"image/",
    /"service_version/": /"v1/",
    /"title/": /"Meteor before Galaxy/",
    /"url/": /"https://apod.nasa.gov/apod/image/2208/MeteorM31_hemmerich_960.jpg/"
  }
"""
    
}

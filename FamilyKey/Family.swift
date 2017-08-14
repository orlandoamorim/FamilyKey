//
//  Family.swift
//  FamilyKey
//
//  Created by Orlando Amorim on 01/06/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import RealmSwift

class FamilyRealm: Object {
    dynamic var name = ""
    dynamic var desc = ""
    let images = List<FamilyImage>()
    
    func delete() {
        let realm = try! Realm()
        for image in images {
            try! realm.write {
                realm.delete(image)
            }
        }
    }
}

class FamilyImage: Object {
    dynamic var name = ""
}
//-----------------------------
class Family {
    
    var desc : String!
    var image : [AnyObject]!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        desc = dictionary["desc"] as? String
        image = dictionary["image"] as? [AnyObject]
        name = dictionary["name"] as? String
    }
    
    func getImages() -> List<FamilyImage>? {
        guard let image = image as? [String] else {
            return nil
        }
        let listImages: List<FamilyImage> = List<FamilyImage>()
        for imageName in image{
            let familyImage = FamilyImage()
            familyImage.name = imageName
            listImages.append(familyImage)
        }
        return listImages
    }
}

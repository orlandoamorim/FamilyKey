//
//  Key.swift
//  FamilyKey
//
//  Created by Orlando Amorim on 01/06/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import RealmSwift

//Realm Key Class
class KeyRealm: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var desc = ""
    dynamic var isFamily = false
    dynamic var family: FamilyRealm?
    
    func delete() {
        let realm = try! Realm()
        if let family = self.family {
            family.delete()
            try! realm.write {
                realm.delete(family)
            }
        }
 
    }
}

//Key Class
class Key : NSObject, NSCoding{
    
    var descriptionField : String!
    var id : String!
    var image : [AnyObject]!
    var isFamily : Bool!
    var name : String!
    var nextKeys : [String]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        descriptionField = dictionary["description"] as? String
        id = dictionary["id"] as? String
        image = dictionary["image"] as? [AnyObject]
        isFamily = dictionary["isFamily"] as? Bool
        name = dictionary["name"] as? String
        nextKeys = dictionary["next_keys"] as? [String]
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if isFamily != nil{
            dictionary["isFamily"] = isFamily
        }
        if name != nil{
            dictionary["name"] = name
        }
        if nextKeys != nil{
            dictionary["next_keys"] = nextKeys
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        image = aDecoder.decodeObject(forKey: "image") as? [AnyObject]
        isFamily = aDecoder.decodeObject(forKey: "isFamily") as? Bool
        name = aDecoder.decodeObject(forKey: "name") as? String
        nextKeys = aDecoder.decodeObject(forKey: "next_keys") as? [String]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if isFamily != nil{
            aCoder.encode(isFamily, forKey: "isFamily")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if nextKeys != nil{
            aCoder.encode(nextKeys, forKey: "next_keys")
        }
        
    }
    
}

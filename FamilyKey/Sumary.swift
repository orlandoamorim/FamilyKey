//
//  Sumary.swift
//  FamilyKey
//
//  Created by Orlando Amorim on 01/06/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import RealmSwift

class SumaryRealm: Object {
    dynamic var fantasyName = ""
    dynamic var name = ""
    let keys = List<KeyRealm>()
    dynamic var id = 0
    
    func delete() {
        let realm = try! Realm()
        for key in keys {
            key.delete()
            try! realm.write {
                realm.delete(key)
            }
        }
    }
}

class Sumary : NSObject, NSCoding{
    
    var descriptionField : String!
    var id : Int!
    var image : [AnyObject]!
    var key : String!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        descriptionField = dictionary["description"] as? String
        id = dictionary["id"] as? Int
        image = dictionary["image"] as? [AnyObject]
        key = dictionary["key"] as? String
        name = dictionary["name"] as? String
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
        if key != nil{
            dictionary["key"] = key
        }
        if name != nil{
            dictionary["name"] = name
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
        id = aDecoder.decodeObject(forKey: "id") as? Int
        image = aDecoder.decodeObject(forKey: "image") as? [AnyObject]
        key = aDecoder.decodeObject(forKey: "key") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        
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
        if key != nil{
            aCoder.encode(key, forKey: "key")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}

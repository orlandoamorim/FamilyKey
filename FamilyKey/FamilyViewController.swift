//
//  FamilyViewController.swift
//  FamilyKey
//
//  Created by Orlando Amorim on 02/06/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import Eureka
import ImageSlideshow
import RealmSwift

public enum FamilyViewType{
    case Add
    case Detail
}

class FamilyViewController: FormViewController {
    
    public var familyType: FamilyViewType = .Detail
    public var familyName: String?
    private var family: FamilyRealm!
    
    public var saveSumary:Sumary!
    public var realmKeys = List<KeyRealm>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Family"
        setFamily()
        setButtons()
    }

    fileprivate func setButtons() {
        switch familyType {
        case .Add:
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
            //navigationItem.leftBarButtonItem = cancelButton
            
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(alert))
            navigationItem.rightBarButtonItem = addButton
        case .Detail: print("Detail")
        }
    }
    
    private func setFamily() {
        guard let familyName = self.familyName else {
            return
        }
        
        guard let data = DataManager.getDataFromFile("Family") else {
            return 
        }
        
        var json: Any?
        do {
            json = try JSONSerialization.jsonObject(with: data)
        } catch {
            print(error)
        }
        
        guard let dict = json as? [String : [String:Any]] else {
            return
        }
        
       guard let val = dict[familyName] else {
            return
        }
        
        let family = Family(fromDictionary: val)
        let familyRealm = FamilyRealm()
        
        familyRealm.name = family.name
        familyRealm.desc = family.desc
        
        guard let imageNames = family.image as? [String] else {
            return
        }
        
        for imageName in imageNames {
            let familyImage = FamilyImage()
            familyImage.name = imageName
            familyRealm.images.append(familyImage)
        }
        
        self.family = familyRealm
        
        //If everythink is ok, load the form
        initializeForm()
        
    }
    
    //Set the form on table
    private func initializeForm() {
        form +++ Section("Family")
            <<< TextAreaRow() {
                $0.value = familyName != nil ? familyName : "Erro"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
                $0.disabled = true
                }.cellUpdate { cell, row in
                    cell.textView.isUserInteractionEnabled = false
                    cell.textLabel?.textColor = .black
                    cell.textView.textColor = .black
                    cell.textView.textAlignment = .center
                    cell.textView.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightLight)
            }
            +++ Section("Description"){
                $0.hidden = self.family.desc == "" ? true : false
            }
        
            <<< TextAreaRow() {
                $0.value = self.family.desc
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
                $0.disabled = true
                }.cellUpdate { cell, row in
                    cell.textView.isUserInteractionEnabled = false
                    cell.textLabel?.textColor = .black
                    cell.textView.textColor = .black
                    cell.textView.textAlignment = .justified
                    cell.textView.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
            }
        
            +++ Section() {
                var imageImputs: [ImageSource] = [ImageSource]()
                
                for image in self.family.images {
                    imageImputs.append(ImageSource(imageString: image.name)!)
                }
                $0.hidden = imageImputs.count > 0 ? false : true
                
                var header = HeaderFooterView<ImageSlideShow>(.nibFile(name: "ImageSlideShow", bundle: nil))
                header.onSetupView = { (view, section) -> () in
                    
                    view.delegate = self as ImageSlideShowDelegate
                    view.slideshow.setImageInputs(imageImputs)

                }
                $0.header = header
        }
    }
    
    func cancelTapped(_ barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func alert() {
        let alertController = UIAlertController(title: "Ola!", message: "Estamos prestes a salvar a familia que voce achou, mas antes digite um nome para associarmos a ela.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Salvar", style: UIAlertActionStyle.default, handler: { (save) in
            let fNameField = alertController.textFields![0] as UITextField
            
            if let name = fNameField.text {
                //TODO: Do something with this data
                self.save(name: name)
            } else {
                //TODO: Add error handling
                self.alert()
            }
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Ex: Trabalho de Campo"
            textField.textAlignment = .center
        })
        
        self.present(alertController, animated: true, completion: nil)

    }
    
    
    func save(name: String) {
        let sumary = SumaryRealm()
        sumary.id = self.saveSumary.id
        sumary.name = self.saveSumary.name
        sumary.fantasyName = name
        for key in realmKeys {
            sumary.keys.append(key)
        }
        
        sumary.keys.last?.family = self.family
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(sumary)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension FamilyViewController: ImageSlideShowDelegate {
    
    func slideShowTapped(cell: ImageSlideShow) {
        cell.slideshow.presentFullScreenController(from: self)
    }
    
}

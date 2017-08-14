//
//  AddFamilyViewController.swift
//  FamilyKey
//
//  Created by Orlando Amorim on 01/06/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

public enum KeyViewType{
    case Add(isFirst: Bool)
    case Detail(isFirst: Bool)
}

protocol KeyViewDelegate {
    func removeLastKey()
}

class KeyViewController: FormViewController {
    
    public var keyType: KeyViewType = .Detail(isFirst: false)
    public var keyHelper: KeyHelper?
    public var nextKeys : [String]? //Apenas para ser usado depois de passar a tela summary
    private var keys:[Key] = [Key]()
    
    public var saveSumary:Sumary!
    public var realmKeys = List<KeyRealm>()
    public var sumaryRealm: SumaryRealm?

    
    var delegate: KeyViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()
    }
    
    private func setValues() {
        switch keyType {
        case .Add(let isFirst):
            isFirst == true ? isFirstForm() : initializeForm()
        case .Detail(let isFirst):
            isFirst == true ? isFirstForm() : initializeForm()
        }
    }
    
    fileprivate func getKeys(isFirst: Bool) -> [Key]{
        var keys: [Key] = [Key]()
        
        if isFirst, let keyHelper = keyHelper {
            for firstKey in keyHelper.firstKeys {
                for key in keyHelper.keys {
                    if key.id == firstKey {
                        keys.append(key)
                        self.keys.append(key)
                    }
                }
            }
        }else if let nextKeys = self.nextKeys, let keyHelper = self.keyHelper {
                for nextKey in nextKeys {
                    for key in keyHelper.keys {
                        if key.id == nextKey {
                            keys.append(key)
                            self.keys.append(key)
                        }
                    }
                }
        }
        
        return keys
    }
    
    
    private func initializeForm() {
        form +++ Section()
        for key in getKeys(isFirst: false) {
            switch keyType {
            case .Add(isFirst: _):
                form.last!
                    <<< TextAreaRow() {
                        $0.value = key.name
                        $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
                        $0.disabled = true
                        }.onCellSelection { cell, row in
                            self.showVC(cell, row: row)
                        }.cellUpdate { cell, row in
                            cell.textView.isUserInteractionEnabled = false
                            cell.accessoryType = .detailDisclosureButton
                            cell.textLabel?.textColor = .black
                            cell.textView.textColor = .black
                }
            case .Detail(isFirst: _):
                form.last!
                    <<< TextAreaRow() {
                        $0.value = key.name
                        $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
                        $0.disabled = true
                        }.onCellSelection { cell, row in
                            if let sumary = self.sumaryRealm, sumary.keys.contains(where: {$0.id == key.id}) {
                                self.showVC(cell, row: row)
                            }
                        }.cellUpdate { cell, row in
                            if let sumary = self.sumaryRealm, sumary.keys.contains(where: {$0.id == key.id}) {
                                cell.textView.isUserInteractionEnabled = false
                                cell.accessoryType = .detailDisclosureButton
                                cell.textLabel?.textColor = .black
                                cell.textView.textColor = .black
                            }
                }
            }
        }
    }
    
    private func isFirstForm() {
        form +++ Section(keyHelper != nil ? keyHelper!.name : "Erro")
            <<< TextAreaRow() {
                $0.value = keyHelper != nil ? keyHelper!.descriptionField : "Erro"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
                $0.disabled = true
                }.cellUpdate { cell, row in
                    cell.textView.isUserInteractionEnabled = false
                    cell.textLabel?.textColor = .black
                    cell.textView.textColor = .black
                    cell.textView.textAlignment = .center
            }
        
        +++ Section()
        for key in getKeys(isFirst: true) {
            switch keyType {
            case .Add(isFirst: _):
                form.last!
                <<< TextAreaRow() {
                    $0.value = key.name
                    $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
                    $0.disabled = true
                    }.onCellSelection { cell, row in
                        self.showVC(cell, row: row)
                    }.cellUpdate { cell, row in
                        cell.textView.isUserInteractionEnabled = false
                        cell.accessoryType = .detailDisclosureButton
                        cell.textLabel?.textColor = .black
                        cell.textView.textColor = .black
                }
            case .Detail(isFirst: _):
                form.last!
                <<< TextAreaRow() {
                    $0.value = key.name
                    $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
                    $0.disabled = true
                    }.onCellSelection { cell, row in
                        if let sumary = self.sumaryRealm, sumary.keys.contains(where: {$0.id == key.id}) {
                            self.showVC(cell, row: row)
                        }
                    }.cellUpdate { cell, row in
                        if let sumary = self.sumaryRealm, sumary.keys.contains(where: {$0.id == key.id}) {
                            cell.textView.isUserInteractionEnabled = false
                            cell.accessoryType = .detailDisclosureButton
                            cell.textLabel?.textColor = .black
                            cell.textView.textColor = .black
                        }
                }
            }
        }
    }
    
    @objc(tableView:accessoryButtonTappedForRowWithIndexPath:) func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("Hi \(indexPath.row)")
    }
    
    func cancelTapped(_ barButtonItem: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showVC(_ cell: AreaCell, row: TextAreaRow) {
        let key = keys[row.indexPath!.row]

        if let keyRealm = self.realmKeys.last, keyRealm.isFamily == true  {
            let familyView = FamilyViewController()
            
            self.realmKeys.append(generate(key: key, isFamily: true))
            familyView.realmKeys = self.realmKeys
            familyView.saveSumary = saveSumary
            familyView.familyName = key.nextKeys[0]

            switch keyType {
            case .Add(isFirst: _):
                familyView.familyType = .Add
            case .Detail(isFirst: _):
                familyView.familyType = .Detail
            }
            
            navigationController?.show(familyView, sender: self)
        } else if key.isFamily {
            let familyView = FamilyViewController()
            
            self.realmKeys.append(generate(key: key, isFamily: true))
            familyView.realmKeys = self.realmKeys
            familyView.saveSumary = saveSumary
            familyView.familyName = key.nextKeys[0]
            
            switch keyType {
            case .Add(isFirst: _):
                familyView.familyType = .Add
            case .Detail(isFirst: _):
                familyView.familyType = .Detail
            }
            
            navigationController?.show(familyView, sender: self)
            
        }
        else {
            
            let keyView = KeyViewController()
            keyView.nextKeys = key.nextKeys
            keyView.keyHelper = self.keyHelper
            self.realmKeys.append(generate(key: key, isFamily: true))
            keyView.realmKeys = self.realmKeys
            keyView.delegate = self

            switch keyType {
            case .Add(isFirst: _):
                keyView.keyType = .Add(isFirst: false)
                keyView.saveSumary = self.saveSumary
            case .Detail(isFirst: _):
                keyView.keyType = .Detail(isFirst: false)
                keyView.sumaryRealm = sumaryRealm
            }
            navigationController?.show(keyView, sender: self)
        }
    }
    
    func generate(key: Key, isFamily: Bool) -> KeyRealm{
        let realmKey = KeyRealm()
        realmKey.id = key.id
        realmKey.name = key.name
        realmKey.desc = key.descriptionField
        realmKey.isFamily = key.isFamily
        return realmKey
    }
    
}


extension KeyViewController:KeyViewDelegate {
    func removeLastKey() {
         self.realmKeys.removeLast()
    }
}

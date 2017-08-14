//
//  SumaryViewController.swift
//  FamilyKey
//
//  Created by Orlando Amorim on 01/06/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import Eureka

public enum SumaryViewType {
    case Add
    case Detail
    case None
}

class SumaryViewController: FormViewController {
    
    public var sumaryType: SumaryViewType = .None
    private var sumarys: [Sumary] = [Sumary]()
    public var sumaryRealm: SumaryRealm?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sumary"
        setButtons()
        setValues()
    }
    
    private func setButtons() {
        switch sumaryType {
        case .Add:
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
            navigationItem.leftBarButtonItem = cancelButton
        case .Detail: print("Detail")
        case .None:   print("None")
        }
    }
    
    private func setValues() {
        switch sumaryType {
        case .Add: loadSumary()
        case .Detail: loadSumary()
        case .None:   print("None")
        }
    }
    
    private func loadSumary() {
        
        guard let data = DataManager.getDataFromFile("Sumary") else {
            return
        }
        
        var json: Any?
        do {
            json = try JSONSerialization.jsonObject(with: data)
        } catch {
            print(error)
        }
        
        guard let array = json as? [[String:Any]] else {
            return
        }
        
        for sumary in array {
            self.sumarys.append(Sumary(fromDictionary: sumary))
        }
        self.initializeForm()
    }
    
    private func initializeForm() {
        form +++ Section()
        for sumary in sumarys {
            
            switch sumaryType {
            case .Add:
                form.last!
                <<< TextAreaRow() {
                    $0.tag = String(sumary.id)
                    $0.value = sumary.name
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
            case .Detail:
                form.last!
                <<< TextAreaRow() {
                    $0.tag = String(sumary.id)
                    $0.value = sumary.name
                    $0.textAreaHeight = .dynamic(initialTextViewHeight: 25)
                    $0.disabled = true
                    }.onCellSelection { cell, row in
                        if let sumaryRealm = self.sumaryRealm, sumaryRealm.id == sumary.id {
                                self.showVC(cell, row: row)
                        }
                    }.cellUpdate { cell, row in
                        if let sumaryRealm = self.sumaryRealm, sumaryRealm.id == sumary.id {
                            cell.textView.isUserInteractionEnabled = false
                            cell.accessoryType = .detailDisclosureButton
                            cell.textLabel?.textColor = .black
                            cell.textView.textColor = .black
                        }
                }
            case .None:   print("None")
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
        let keyView = KeyViewController()
        switch sumaryType {
        case .Add: keyView.keyType = .Add(isFirst: true)
        case .Detail:
            keyView.keyType = .Detail(isFirst: true)
            keyView.sumaryRealm = self.sumaryRealm
        case .None:   print("None")
        }
        
        let sumary = sumarys[Int(row.tag!)!]
        
        keyView.keyHelper = loadKey(sumary.key)
        keyView.saveSumary = sumary
        
        navigationController?.show(keyView, sender: self)
    }
    
    private func loadKey(_ named: String) -> KeyHelper? {
        var json: Any?
        
        guard let data = DataManager.getDataFromFile(named) else {
            return nil
        }
        
        do {
            json = try JSONSerialization.jsonObject(with: data)
        } catch {
            print(error)
        }
        
        guard let array = json as? [String:Any] else {
            return nil
        }
        
        return KeyHelper(fromDictionary: array)
    }
}

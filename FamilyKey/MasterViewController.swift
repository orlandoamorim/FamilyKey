//
//  MasterViewController.swift
//  FamilyKey
//
//  Created by Orlando Amorim on 01/06/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {

    var detailViewController: SumaryViewController? = nil
    var objects = [SumaryRealm]()
    
    let realm = try! Realm()
    
    let sumaries: Results<SumaryRealm> = {
        let realm = try! Realm()
        return realm.objects(SumaryRealm.self).sorted(byKeyPath: "fantasyName", ascending: true)
    }()
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Family"
        request()
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFamily(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? SumaryViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func request() {
//        let sumarys = realm.objects(SumaryRealm.self)
//        for sumary in sumarys {
//            objects.append(sumary)
//        }
//        tableView.reloadData()
        
        
        token = sumaries.addNotificationBlock {[weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(let results, let deletions, let insertions, let modifications):
                
                tableView.beginUpdates()
                
                //re-order repos when new pushes happen
                tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                                     with: .fade)
                
                //flash cells when repo gets more stars
                for row in modifications {
                    let indexPath = IndexPath(row: row, section: 0)
                    let sumary = results[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                    cell.textLabel!.text = sumary.fantasyName
                    
                }
                
                tableView.endUpdates()
                break
            case .error(let error):
                print(error)
                break
            }
        }
    }

    func addFamily(_ sender: Any) {
        self.performSegue(withIdentifier: "AddRegister", sender: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = sumaries[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! SumaryViewController
                controller.sumaryType = .Detail
                controller.sumaryRealm = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }else if segue.identifier == "AddRegister" {
            let controller = (segue.destination as! UINavigationController).topViewController as! SumaryViewController
            controller.sumaryType = .Add

        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sumaries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = sumaries[indexPath.row]
        cell.textLabel!.text = object.fantasyName
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sumary = sumaries[indexPath.row]
            sumary.delete()
            try! realm.write {
                realm.delete(sumary)
            }
            
//            objects.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}


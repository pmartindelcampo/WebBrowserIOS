//
//  TableViewController.swift
//  WebBrowser
//
//  Created by Pablo on 13/01/2019.
//  Copyright © 2019 Pablo. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet var editButton: UIBarButtonItem!
    var favorites: [String] = []
    var selected: String = ""
    var currentWeb: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.object(forKey: "favorites") != nil {
            favorites = UserDefaults.standard.object(forKey: "favorites") as! [String]
        } else {
            UserDefaults.standard.set(favorites, forKey: "favorites")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = favorites[indexPath.row]
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            favorites.remove(at: indexPath.row)
            UserDefaults.standard.set(favorites, forKey: "favorites")
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let web : String = favorites.remove(at: fromIndexPath.row)
        favorites.insert(web, at: to.row)
        UserDefaults.standard.set(favorites, forKey: "favorites")
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    @IBAction func toggleEdit(_ sender: Any) {
        if isEditing {
            setEditing(false, animated: true)
            editButton.title = "Editar"
        }
        else {
            setEditing(true, animated: true)
            editButton.title = "Hecho"
        }
    }
    /*
    // MARK: - Navigation 

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addFavorite(_ sender: Any) {
        let alert = UIAlertController(title: "Añadir página favorita", message: "Introduzca la url de la página", preferredStyle: .alert)
        
        alert.addTextField { textField -> Void in
            textField.placeholder = "URL"
        }
        
        let action = UIAlertAction(title: "Añadir", style: .default, handler: { action in
            let pageName = alert.textFields![0].text!
            if self.favorites.contains(pageName) {
                let alertExist = UIAlertController(title: "Error", message: "La página ya está añadida", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                alertExist.addAction(ok)
                self.present(alertExist, animated: true)
            } else {
                self.favorites.append(pageName)
                self.tableView.reloadData()
                UserDefaults.standard.set(self.favorites, forKey: "favorites")
            }
        })
        let cancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if tableView.indexPathForSelectedRow != nil {
            selected = favorites[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}

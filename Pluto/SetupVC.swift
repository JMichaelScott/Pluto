//
//  SetupVC.swift
//  Pluto
//
//  Created by Faisal Lalani on 9/12/16.
//  Copyright © 2016 Faisal M. Lalani. All rights reserved.
//

import AVFoundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import UIKit

class SetupVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Outlets
    
    // Constraints
    @IBOutlet weak var questionLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBoxTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var goButtonTopConstraint: NSLayoutConstraint!
    
    // Buttons
    @IBOutlet weak var goButton: Button!
    
    // Search
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchPreview: UITableView!

    // MARK: - Variables
    
    // Animation Engine
    var animEngine: AnimationEngine!
    
    // Booleans
    var inSearchMode = false
    
    // Arrays
    var boards = [Board]()
    var filteredBoards = [Board]()
    
    // MARK: - View Functions
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Starts the animation engine and brings all elements up.
        self.animEngine.animateOnScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gives the animation engine the constraints it needs to modify in order to create the animation.
        self.animEngine = AnimationEngine(constraints: [questionLabelTopConstraint, searchBoxTopConstraint, goButtonTopConstraint])
        
        // Sets the search delegates accordingly.
        searchBar.delegate = self
        searchPreview.dataSource = self
        searchPreview.delegate = self
        
        // Changes the font and font size for text inside the search bar.
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.font = UIFont(name: "Open Sans", size: 15)
        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.font = UIFont(name: "Open Sans", size: 15)
        
        parseSchoolsCSV()
    }
    
    // MARK: - Firebase
    
    /**
 
     Saves the user's school to his/her account on Firebase.
 
    */
    func saveSchool(schoolName: String!) {
        
        //let ref = FIRDatabase.database().reference()
        
    }
    
    // MARK: - Helpers
    
    func dismissKeyboard() {
        
        // Dismisses the keyboard.
        searchBar.resignFirstResponder()
    }
    
    /**
     
     Reads the schools.csv file to compile list of all schools in the nation.
 
    */
    func parseSchoolsCSV() {
        
        let path = Bundle.main.path(forResource: "schools", ofType: "csv")!
        
        do {
         
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows

            for row in rows {
                
                let name = row["Institution_Name"]
                let school = Board(name: name!)
                boards.append(school)
            }
        } catch let error as NSError {
            
            print(error.debugDescription)
        }
    }
    
    // MARK: - Search Bar Functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            // This means the user is NOT typing in the search bar.
            inSearchMode = false
            
            // Hides the search result previews.
            searchPreview.alpha = 0
            
        } else {
            
            // This means the user is typing in the search bar.
            inSearchMode = true
            
            // Brings up the search result previews.
            searchPreview.alpha = 1.0
            
            // Filters the list of schools as the user types into a new array.
            filteredBoards = boards.filter({$0.name.range(of: searchBar.text!) != nil})
            searchPreview.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        dismissKeyboard()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        AnimationEngine.animateToPosition(view: self.goButton, position: CGPoint(x: AnimationEngine.centerPosition.x, y: AnimationEngine.offScreenBottomPosition.y + 1000))
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        AnimationEngine.animateToPosition(view: self.goButton, position: CGPoint(x: AnimationEngine.centerPosition.x, y: AnimationEngine.centerPosition.y))
    }
    
    // MARK: - Table View Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // Returns only 1 column.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Returns only the number of suggestions the filter has for the user's query.
        return filteredBoards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResult", for: indexPath) as UITableViewCell
        
        // Makes the text of each search preview result match what the filter churns out.
        cell.textLabel?.text = filteredBoards[indexPath.row].name
        
        // Changes the text color and font to the app style.
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Open Sans", size: 15)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Changes the search bar text to match the selection the user made.
        searchBar.text = filteredBoards[indexPath.row].name
        
        // Hides the search suggestions.
        searchPreview.alpha = 0
        
        dismissKeyboard()
    }
    
}

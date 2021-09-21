//
//  ViewController.swift
//  My Book
//
//  Created by Reza Kashkoul on 6/30/1400 AP.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate {
    
    var books = [BookModel]()
    var searchedItems = String()

    
    
    
    @IBOutlet weak var bookListTableView: UITableView!
    @IBOutlet weak var searchTexField: UITextField!
    
    @IBOutlet weak var changeSearchStyleButtonOutlet: UIButton!
    @IBAction func changeSearchStyleButtonAction(_ sender: Any) {
        
        
    }
    @IBAction func searchByFilterSegment(_ sender: Any) {
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookListTableView.delegate = self
        bookListTableView.dataSource = self
        bookListTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        return cell
        
    }
    
    //for author
    //https://www.googleapis.com/books/v1/volumes?q=\()+inauthor

    //for title
    //https://www.googleapis.com/books/v1/volumes?q=\()+intitle
    
    func getDataFromApi() {
        let urlString =  "https://api.github.com/users/\(searchedItems)/repos"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let gitHUbJson = try? decoder.decode([GitHubData].self, from: json) {
            resultArray = gitHUbJson
            resultTableView.reloadData()
        }
    }
    
    
}


//
//  ViewController.swift
//  My Book
//
//  Created by Reza Kashkoul on 6/30/1400 AP.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate {
    
    @IBOutlet weak var bookListTableView: UITableView!
    @IBOutlet weak var searchTexField: UITextField!
    @IBOutlet weak var segmentState: UISegmentedControl!
    @IBOutlet weak var changeSearchButton: UIButton!
    @IBAction func changeSearchButtonTapped(_ sender: Any) {
        if changeSearchButton.currentImage == UIImage(systemName: "person") {
            changeSearchButton.setImage(UIImage(systemName: "person"), for: .normal)
            textUpdaterByFilter = "+inauthor"
        } else if changeSearchButton.currentImage == UIImage(systemName: "book.closed") {
            changeSearchButton.setImage(UIImage(systemName: "book.closed"), for: .normal)
            textUpdaterByFilter = "+inauthor"
        }
    }
    @IBAction func searchByFilterSegment(_ sender: Any) {
    }
    
    var books = [Items]()
    var searchedItems = String()
    var textUpdaterByFilter = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTexField.delegate = self
        bookListTableView.delegate = self
        bookListTableView.dataSource = self
        bookListTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
        changeSearchButton.setImage(UIImage(systemName: "person"), for: .normal)
        segmentState.selectedSegmentIndex = 1
        segmentManagement()
        overrideUserInterfaceStyle = .light
        bookListTableView.keyboardDismissMode = .onDrag
        getDataFromApi()

        
        
        
        
    }
    
    func segmentManagement() {
        if segmentState.selectedSegmentIndex == 0 {
            //stars
            books = books.sorted(by: { firstItem, SecondItem in
                firstItem.volumeInfo.pageCount! < SecondItem.volumeInfo.pageCount!
            })
        } else if segmentState.selectedSegmentIndex == 1 {
            // forks
            books = books.sorted(by: { firstItem, SecondItem in
                firstItem.volumeInfo.ratingCount! < SecondItem.volumeInfo.ratingCount!
            })
        }
        bookListTableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        cell.titleDataLabel.text = books[indexPath.row].volumeInfo.title
        cell.PageCountDataLabel.text = books[indexPath.row].volumeInfo.pageCount?.description
        cell.ratingCountDataLabel.text = books[indexPath.row].volumeInfo.ratingCount?.description
        
        let urlString = books[indexPath.row].volumeInfo.imageLinks?.thumbnail!
        guard let url = URL(string: urlString!) else { return cell}
        let getDataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                cell.imageView!.image = image
            }
        }
        getDataTask.resume()
        
        return cell
    }
    //for author
    //https://www.googleapis.com/books/v1/volumes?q=+inauthor
    
    //for title
    //https://www.googleapis.com/books/v1/volumes?q=+intitle
    
    func getDataFromApi() {
        let urlString =  "https://www.googleapis.com/books/v1/volumes?q=\(searchedItems)+\(textUpdaterByFilter)"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let googleBooks = try? decoder.decode(BookModel.self, from: json) {
            books = googleBooks.items
            bookListTableView.reloadData()
        }
    }
}


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
     
    //        bookListTableView.reloadData() dar actione text
    
    
    
    let iconImage = UIImage(systemName: "person",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular, scale: .medium))
    
    @IBAction func changeSearchButtonTapped(_ sender: Any) {
        if changeSearchButton.currentImage == UIImage(systemName: "person") {
            searchTexField.placeholder = "Search by book title!"
            changeSearchButton.setImage(UIImage(systemName: "book.closed"), for: .normal)
            textUpdaterByFilter = "+intitle"
            
            
            //            changeSearchButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .regular, scale: .medium), forImageIn: .normal)
            
            
        } else {
            changeSearchButton.setImage(UIImage(systemName: "person"), for: .normal)
            searchTexField.placeholder = "Search by book Author!"
            
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
        performSearch()
        segmentState.selectedSegmentIndex = 1
        segmentManagement()
        overrideUserInterfaceStyle = .light
        bookListTableView.keyboardDismissMode = .onDrag
        changeSearchButton.setImage(UIImage(systemName: "book.closed"), for: .normal)
        changeSearchButton.layer.cornerRadius = 5
        changeSearchButton.layer.borderWidth = 2
        changeSearchButton.layer.borderColor = UIColor.appColor(.borderColor)?.cgColor
    }
    
    func segmentManagement() {
        if segmentState.selectedSegmentIndex == 0 {
            books = books.sorted(by: { firstItem, SecondItem in
                firstItem.volumeInfo.pageCount! < SecondItem.volumeInfo.pageCount!
            })
        } else if segmentState.selectedSegmentIndex == 1 {
            books = books.sorted(by: { firstItem, SecondItem in
                firstItem.volumeInfo.averageRating! < SecondItem.volumeInfo.ratingCount!
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        
        cell.titleDataLabel.text = books[indexPath.row].volumeInfo.title
        
        if (books[indexPath.row].volumeInfo.pageCount?.description) != nil {
            cell.pageCountStackView.isHidden = false
            cell.PageCountDataLabel.text = books[indexPath.row].volumeInfo.pageCount?.description
        } else {
            cell.pageCountStackView.isHidden = true
        }
        if (books[indexPath.row].volumeInfo.ratingCount?.description) != nil {
            cell.ratingCountStackView.isHidden = false
            cell.ratingCountDataLabel.text = books[indexPath.row].volumeInfo.ratingCount?.description
        } else {
            cell.ratingCountStackView.isHidden = true
        }
        if (books[indexPath.row].volumeInfo.averageRating?.description) != nil {
            cell.avarageRatingStackView.isHidden = false
            cell.avarageRatingDataLabel.text = books[indexPath.row].volumeInfo.averageRating?.description
        } else {
            cell.avarageRatingDataLabel.text = books[indexPath.row].volumeInfo.averageRating?.description
        }
        
        let urlString = books[indexPath.row].volumeInfo.imageLinks?.smallThumbnail!
        guard let url = URL(string: urlString!) else { return cell}
        let getDataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                
                
                if (self.books[indexPath.row].volumeInfo.imageLinks?.smallThumbnail!) != nil {
                    cell.bookImage.isHidden = false
                    cell.bookImage!.image = image
                    
                } else {
                    cell.bookImage.isHidden = true
                }
                
                
                cell.bookImage!.image = image
            }
        }
        getDataTask.resume()
        
        return cell
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField code
        textField.resignFirstResponder()
        
        if searchTexField.text!.count > 3 {
            performSearch()
        }
        return true
    }
    
    
    func performSearch() {
        getDataFromApi()
    }
    
    //for author
    //https://www.googleapis.com/books/v1/volumes?q=+inauthor
    
    //for title
    //https://www.googleapis.com/books/v1/volumes?q=+intitle
    
    
    
    //https://www.googleapis.com/books/v1/volumes?q=flower+inauthor
    func getDataFromApi() {
        //searchedItems
        let urlString =  "https://www.googleapis.com/books/v1/volumes?q=\(searchTexField.text! + textUpdaterByFilter)"
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
enum AssetsColor: String {
    case bookColor
    case borderColor
    case segmentColor
    case tabBarColor
}
extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}

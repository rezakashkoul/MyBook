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
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        doSearch()
    }
    
    @IBAction func changeSearchButtonTapped(_ sender: Any) {
        if changeSearchButton.currentImage == UIImage(systemName: "person") {
            searchTexField.placeholder = "Search by book title!"
            changeSearchButton.setImage(UIImage(systemName: "book.closed"), for: .normal)
            textUpdaterByFilter = "+intitle"
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
        
        tabBarController?.selectedIndex = 0
        tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        segmentState.selectedSegmentIndex = 1
       // segmentManagement()
        overrideUserInterfaceStyle = .light
        bookListTableView.keyboardDismissMode = .onDrag
        textUpdaterByFilter = "+inauthor"
        changeSearchButton.setImage(UIImage(systemName: "book.closed"), for: .normal)
        changeSearchButton.layer.cornerRadius = 5
        changeSearchButton.layer.borderWidth = 2
        changeSearchButton.layer.borderColor = UIColor.appColor(.borderColor)?.cgColor
    }
    
//    func segmentManagement() {
//        if segmentState.selectedSegmentIndex == 0 {
//            books = books.sorted(by: { firstItem, SecondItem in
//                firstItem.volumeInfo.pageCount! < SecondItem.volumeInfo.pageCount!
//            })
//        } else if segmentState.selectedSegmentIndex == 1 {
//            books = books.sorted(by: { firstItem, SecondItem in
//                firstItem.volumeInfo.averageRating! < SecondItem.volumeInfo.ratingCount!
//            })
//        }
//    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newPage = storyboard?.instantiateViewController(withIdentifier: "BookDetailController") as? BookDetailController
        
        if let showImage = books[indexPath.row].volumeInfo.imageLinks?.thumbnail
        {
            newPage?.passedImage = showImage
        } else {
            newPage?.bigImage.isHidden = true
        }
        if let showDownloadLink = books[indexPath.row].accessInfo.epub?.downloadLink {
            newPage?.passedDownloadLink = showDownloadLink
        } else {
            //newPage?.downloadLinkDataLabel.isHidden = true

        }
//        if let showAthors = books[indexPath.row].volumeInfo.authors {
//            newPage?.authorsListDataLabel.text = showAthors[indexPath.row]
//        } else {
//            newPage?.authorsListDataLabel.isHidden = true
//        }
        
        present(newPage!, animated: true, completion: nil)
        
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
            cell.avarageRatingStackView.isHidden = true
        }
        
        if let smallThumbnail = self.books[indexPath.row].volumeInfo.imageLinks?.smallThumbnail {
            cell.bookImage.isHidden = false
            //            cell.bookImage!.image = image
            guard let url = URL(string: smallThumbnail) else { return cell}
            let getDataTask = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data , error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    cell.bookImage?.image = image
                }
            }
            getDataTask.resume()
        } else {
            cell.bookImage.isHidden = true
        }
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField code
        textField.resignFirstResponder()
        performSearch()
        return true
    }
    
    func doSearch() {
        if self.searchTexField.text != nil {
            if searchTexField.text!.count >= 3 {
                getDataFromApi()
            }
        }
    }
    
    func performSearch() {
        getDataFromApi()
        bookListTableView.reloadData()
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


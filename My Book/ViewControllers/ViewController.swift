//
//  ViewController.swift
//  My Book
//
//  Created by Reza Kashkoul on 6/30/1400 AP.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var nothngLabel: UILabel!
    @IBOutlet weak var bookListTableView: UITableView!
    @IBOutlet weak var searchTexField: UITextField!
    @IBOutlet weak var segmentState: UISegmentedControl!
    @IBOutlet weak var changeSearchButton: UIButton!
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        doSearchActionWhileTyping()
    }
    @IBAction func changeSearchButtonTapped(_ sender: Any) {
        if changeSearchButton.currentImage == UIImage(systemName: "person") {
            searchByTitleRequirements()
            performSearch()
        } else {
            searchByAuthorRequirements()
            performSearch()
        }
    }
    
    @IBAction func searchByFilterSegment(_ sender: Any) {
        sortingResultsOrder()
        reloadTableView()
    }
    
    var books = [Items]()
    var searchedItems = String()
    var textUpdaterByFilter = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        bookListTableView.keyboardDismissMode = .onDrag
        
        searchTexField.delegate = self
        bookListTableView.delegate = self
        bookListTableView.dataSource = self
        bookListTableView.register(UINib(nibName: "TabsTableViewCell", bundle: nil), forCellReuseIdentifier: "TabsTableViewCell")
        
        if searchTexField.text == "" {
            nothngLabel.isHidden = false
            bookListTableView.isHidden = true
            reloadTableView()
        } else {
            nothngLabel.isHidden = false
            bookListTableView.isHidden = true
            bookListTableView.isHidden = false
            reloadTableView()
        }
        
        performSearch()
        
        tabBarController?.selectedIndex = 0
        tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        segmentState.selectedSegmentIndex = 1
        sortingResultsOrder()
        reloadTableView()
        
        textUpdaterByFilter = "+inauthor"
        changeSearchButton.setImage(UIImage(systemName: "book.closed"), for: .normal)
        
        changeSearchButton.layer.cornerRadius = 5
        changeSearchButton.layer.borderWidth = 2
        changeSearchButton.layer.borderColor = UIColor.appColor(.borderColor)?.cgColor
        changeSearchButton.layer.backgroundColor = UIColor.appColor(.bookColor)?.cgColor
    }
    
    func sortingResultsOrder() {
        if segmentState.selectedSegmentIndex == 0 {
            books = books.sorted(by: { firstItem, secondItem in
                guard let first = firstItem.volumeInfo.pageCount, let second = secondItem.volumeInfo.pageCount else { return  true }
                return first > second
            })
        }
        if segmentState.selectedSegmentIndex == 1 {
            books = books.sorted(by: { firstItem, secondItem in
                guard let first = firstItem.volumeInfo.averageRating, let second = secondItem.volumeInfo.averageRating else { return  true }
                return first > second
            })
        }
    }
    
    func searchByTitleRequirements() {
        changeSearchButton.layer.backgroundColor = UIColor.appColor(.bookColor)?.cgColor
        searchTexField.placeholder = "Search by book title!"
        changeSearchButton.setImage(UIImage(systemName: "book.closed"), for: .normal)
        changeSearchButton.layer.borderWidth = 2
        changeSearchButton.layer.borderColor = UIColor.appColor(.borderColor)?.cgColor
        textUpdaterByFilter = "+intitle"
    }
    
    func searchByAuthorRequirements() {
        changeSearchButton.setImage(UIImage(systemName: "person"), for: .normal)
        changeSearchButton.layer.backgroundColor = UIColor.appColor(.borderColor)?.cgColor
        changeSearchButton.layer.borderWidth = 2
        changeSearchButton.layer.borderColor = UIColor.appColor(.bookColor)?.cgColor
        searchTexField.placeholder = "Search by book Author!"
        textUpdaterByFilter = "+inauthor"
    }
    
    func reloadTableView() {
        bookListTableView.reloadData()
    }
    
    
    func doSearchActionWhileTyping() {
        if self.searchTexField.text != nil {
            
            if searchTexField.text == "" {
                nothngLabel.isHidden = false
                bookListTableView.isHidden = true
                reloadTableView()
            } else {
                nothngLabel.isHidden = false
                bookListTableView.isHidden = true
                bookListTableView.isHidden = false
                reloadTableView()
            }
            if searchTexField.text!.count >= 3 {
                getDataFromApi()
            }
        }
    }
    
    func performSearch() {
        getDataFromApi()
        reloadTableView()
    }
    
    func getDataFromApi() {
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
            reloadTableView()
        }
    }
}





extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField code
        textField.resignFirstResponder()
        performSearch()
        return true
    }
}



extension ViewController :  UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabsTableViewCell", for: indexPath) as! TabsTableViewCell
        cell.selectionStyle = .none
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
            guard let url = URL(string: smallThumbnail) else { return cell }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newPage = storyboard?.instantiateViewController(withIdentifier: "BookDetailController") as? BookDetailController
        
        tableView.deselectRow(at: indexPath, animated: false)
        let specificBookDetail = books[indexPath.row]
        newPage?.chosenBookCellArray = specificBookDetail
        present(newPage!, animated: true, completion: nil)
    }
    
}

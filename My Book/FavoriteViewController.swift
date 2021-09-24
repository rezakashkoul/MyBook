//
//  FavoriteViewController.swift
//  My Book
//
//  Created by Reza Kashkoul on 7/2/1400 AP.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noFavoriteLabel: UILabel!
    @IBOutlet weak var favoriteListTableView: UITableView!
    
    var passedToFavoriteBookID = String()
    
    var passedToFavoriteSmallBookImage = String()
    var passedToFavoriteTitleDataLabel = String()
    var passedToFavoritePageCountDataLabel = Int()
    var passedToFavoriteRatingCountDataLabel = Int()
    var passedToFavoriteAvarageRatingDataLabel = Int()
    //    pageCountStackView: UIStackView!
    //    ratingCountStackView: UIStackView!
    //    avarageRatingStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        
        if favoriteList.count == 0 {
            noFavoriteLabel.isHidden = false
            favoriteListTableView.isHidden = true
        } else {
            noFavoriteLabel.isHidden = true
            favoriteListTableView.isHidden = false
        }
        
        favoriteListTableView.delegate = self
        favoriteListTableView.dataSource = self
        favoriteListTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
    }
    
    var favoriteList = [Items]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return favoriteList.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        cell.selectionStyle = .none
        cell.titleDataLabel.text = passedToFavoriteTitleDataLabel
        
        if passedToFavoritePageCountDataLabel != nil {
            cell.pageCountStackView.isHidden = false
            cell.PageCountDataLabel.text = passedToFavoritePageCountDataLabel.description
        } else {
            cell.pageCountStackView.isHidden = true
        }
        if passedToFavoriteRatingCountDataLabel != nil {
            cell.ratingCountStackView.isHidden = false
            cell.ratingCountDataLabel.text = passedToFavoriteRatingCountDataLabel.description
        } else {
            cell.ratingCountStackView.isHidden = true
        }
        if passedToFavoriteAvarageRatingDataLabel != nil {
            cell.avarageRatingStackView.isHidden = false
            cell.avarageRatingDataLabel.text = passedToFavoriteAvarageRatingDataLabel.description
        } else {
            cell.avarageRatingStackView.isHidden = true
        }
        
        
        //        if let smallThumbnail = self.favoriteList[indexPath.row].volumeInfo.imageLinks?.smallThumbnail {
        //            cell.bookImage.isHidden = false
        //            guard let url = URL(string: smallThumbnail) else { return cell }
        //            let getDataTask = URLSession.shared.dataTask(with: url) { data, _, error in
        //                guard let data = data , error == nil else {
        //                    return
        //                }
        //                DispatchQueue.main.async {
        //                    let image = UIImage(data: data)
        //                    cell.bookImage?.image = image
        //                }
        //            }
        //            getDataTask.resume()
        //        } else {
        //            cell.bookImage.isHidden = true
        //        }
        return cell
    }
    
    
    
    
}

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
    
    
    //    pageCountStackView: UIStackView!
    //    ratingCountStackView: UIStackView!
    //    avarageRatingStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        
        favoriteListTableView.delegate = self
        favoriteListTableView.dataSource = self
        favoriteListTableView.register(UINib(nibName: "TabsTableViewCell", bundle: nil), forCellReuseIdentifier: "TabsTableViewCell")
        
        // favoriteListTableView.reloadData()
        //        if favoriteList.count == 0 {
        //            noFavoriteLabel.isHidden = false
        //            favoriteListTableView.isHidden = true
        //        } else {
        //            noFavoriteLabel.isHidden = true
        //            favorite ListTableView.isHidden = false
        //        }
        
        
    }
    
    var favoriteItem : Items?
    // var favoriteList : [favoriteItem]?
    var passedToFavoriteTitleDataLabel : String?
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  return [favoriteItem]?.count
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabsTableViewCell", for: indexPath) as! TabsTableViewCell
        cell.selectionStyle = .none
        cell.bookImage.image = UIImage(named: favoriteItem?.volumeInfo.imageLinks?.smallThumbnail?.description ?? "")
        cell.titleDataLabel.text = favoriteItem?.volumeInfo.title
        cell.PageCountDataLabel.text = favoriteItem?.volumeInfo.pageCount?.description
        cell.ratingCountDataLabel.text = favoriteItem?.volumeInfo.ratingCount?.description
        cell.avarageRatingDataLabel.text = favoriteItem?.volumeInfo.averageRating?.description
        
        guard let url = URL(string: favoriteItem?.volumeInfo.imageLinks?.smallThumbnail ?? "") else { return cell}
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
        
        return cell
    }
    
}

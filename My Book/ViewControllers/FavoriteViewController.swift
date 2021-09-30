//
//  FavoriteViewController.swift
//  My Book
//
//  Created by Reza Kashkoul on 7/2/1400 AP.
//

import UIKit

//MARK: This ViewController is the controller of the "Favorite" tab
class FavoriteViewController: UIViewController {
    
    //MARK:  Outlets:
    @IBOutlet weak var noFavoriteLabel: UILabel! //MARK:  present label to show the list is empty
    @IBOutlet weak var favoriteListTableView: UITableView!
    
    // TODO: These stackView IBOutlets must be define when you need hiding UI parts in the tableView
    //    pageCountStackView: UIStackView!
    //    ratingCountStackView: UIStackView!
    //    avarageRatingStackView: UIStackView!
    
    //MARK:  Variables
    // FIXME: Needs to be implemented and also show the output in the tableView
   // var favoriteItem : Items!
     var favoriteList : [Items]?
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteListTableView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        tabBarController?.selectedIndex = 1
        setTheTabBarStyle()
        favoriteListTableView.delegate = self
        favoriteListTableView.dataSource = self
        favoriteListTableView.register(UINib(nibName: "TabsTableViewCell", bundle: nil), forCellReuseIdentifier: "TabsTableViewCell")
        
        // FIXME: This part of code needs to be implemented to work fine. It has some problems. It suposes to show a label when the tableView is empty and hide the label when it gets data as well.
        
        // favoriteListTableView.reloadData()
        //        if favoriteList.count == 0 {
        //            noFavoriteLabel.isHidden = false
        //            favoriteListTableView.isHidden = true
        //        } else {
        //            noFavoriteLabel.isHidden = true
        //            favorite ListTableView.isHidden = false
        //        }
    }
    
    //MARK:  Functions
    /**
     This fuction makes a title and image for both selected and deselected tabBarState in this tab
     
     */
    func setTheTabBarStyle() {
        tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
    }
}


//MARK: To keep the code cleaner, divided the UITableView Main methods into an extension.
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  return [favoriteItem]?.count
        return 1 // MARK: a temperary value to insure if the tableView setup is Okay
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabsTableViewCell", for: indexPath) as! TabsTableViewCell
        cell.selectionStyle = .none
        cell.bookImage.image = UIImage(named: modalDataPasser?.volumeInfo.imageLinks?.smallThumbnail?.description ?? "")
        cell.titleDataLabel.text = modalDataPasser?.volumeInfo.title
        cell.PageCountDataLabel.text = modalDataPasser?.volumeInfo.pageCount?.description
        cell.ratingCountDataLabel.text = modalDataPasser?.volumeInfo.ratingCount?.description
        cell.avarageRatingDataLabel.text = modalDataPasser?.volumeInfo.averageRating?.description
        
        //MARK: The needed reqirements for showing image from URL through the tableViewCells
        guard let url = URL(string: modalDataPasser?.volumeInfo.imageLinks?.smallThumbnail ?? "") else { return cell}
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

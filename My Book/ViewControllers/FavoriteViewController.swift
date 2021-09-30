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
    var favoriteList = [modalDataPasser]
    
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
        
        
        if modalDataPasser?.volumeInfo.pageCount?.description != nil {
            cell.PageCountDataLabel.text = modalDataPasser?.volumeInfo.pageCount?.description
        } else {
            cell.pageCountStackView.isHidden = true
        }
        
        if modalDataPasser?.volumeInfo.ratingCount?.description != nil {
            cell.ratingCountDataLabel.text = modalDataPasser?.volumeInfo.ratingCount?.description
        } else {
            cell.ratingCountStackView.isHidden = true
        }
        if modalDataPasser?.volumeInfo.averageRating?.description != nil {
            cell.avarageRatingDataLabel.text = modalDataPasser?.volumeInfo.averageRating?.description
        } else {
            cell.avarageRatingStackView.isHidden = true
        }
        
        
        
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
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            favoriteList.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //            //        } else if editingStyle == .insert {
    //            //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    //            //        }
    //        }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Remove Item :(") { (action, view, completion) in
            // Perform your action here
            
            completion(true)
        }
        
        
        deleteAction.image = UIImage(systemName: "minus.circle")
        deleteAction.backgroundColor = UIColor.appColor(.borderColor)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    
    
    
}

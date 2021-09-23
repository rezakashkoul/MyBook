//
//  BookDetailController.swift
//  My Book
//
//  Created by Reza Kashkoul on 6/31/1400 AP.
//

import UIKit


class BookDetailController: UIViewController {


    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var downloadLinkDataLabel: UILabel!
    @IBOutlet weak var authorsListDataLabel: UILabel!
    @IBOutlet weak var FavoriteOutletButton: UIButton!
    @IBAction func addAndRemoveFavoriteButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var passedImage = String()
    var passedDownloadLink = String()
    var passedAthors = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        FavoriteOutletButton.layer.cornerRadius = 5
        
        tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        
        bigImage.image = UIImage(named: "\(passedImage)")
        downloadLinkDataLabel.text = passedDownloadLink
        authorsListDataLabel.text = passedAthors
        
        FavoriteOutletButton.layer.cornerRadius = FavoriteOutletButton.bounds.height / 2
    
    }
    

}

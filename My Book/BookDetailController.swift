//
//  BookDetailController.swift
//  My Book
//
//  Created by Reza Kashkoul on 6/31/1400 AP.
//

import UIKit


class BookDetailController: UIViewController , UIGestureRecognizerDelegate {
    
    var chosenBookCellArray : Items?
    
    
    
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var downloadLinkDataLabel: UILabel!
    @IBOutlet weak var authorsListDataLabel: UILabel!
    @IBOutlet weak var FavoriteOutletButton: UIButton!
    
    @IBAction func addAndRemoveFavoriteButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        
        vc.passedToFavoriteBookID = passedToDetailBookID
        vc.passedToFavoriteSmallBookImage = passedToDetailSmallBookImage
        vc.passedToFavoriteTitleDataLabel = passedToDetailTitleDataLabel
        vc.passedToFavoritePageCountDataLabel = passedToDetailPageCountDataLabel
        vc.passedToFavoriteRatingCountDataLabel = passedToDetailRatingCountDataLabel
        vc.passedToFavoriteAvarageRatingDataLabel = passedToDetailAvarageRatingDataLabel

        self.dismiss(animated: true, completion: nil)
        
    }
    //for present in this page and also favoritePage
    var passedToDetailBigImage = String()
    var passedToDetailDownloadLink = String()
    var passedToDetailAthors = String()
    var passedToDetailBookID = String()
    
    //just to pass in favoritePage
    
    var passedToDetailSmallBookImage = String()
    var passedToDetailTitleDataLabel = String()
    var passedToDetailPageCountDataLabel = Int()
    var passedToDetailRatingCountDataLabel = Int()
    var passedToDetailAvarageRatingDataLabel = Int()
    
    @objc func didTapLabelDemo(sender: UITapGestureRecognizer)
    {
        print("****** Open the link! \(sender) ******")
        guard let url = URL(string: passedToDetailDownloadLink) else { return }
        UIApplication.shared.open(url)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadLinkDataLabel.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapLabelDemo))
        downloadLinkDataLabel.addGestureRecognizer(tap)
        tap.delegate = self
        
        guard let url = URL(string: passedToDetailBigImage) else { return  }
        let getDataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.bigImage?.image = image
            }
        }
        getDataTask.resume()
        
        bigImage.image = UIImage(named: "\(passedToDetailBigImage)")
        if downloadLinkDataLabel.text == "" {
            downloadLinkDataLabel.text = "Unfortunatly there's no download link for this Book"
        } else {
            downloadLinkDataLabel.text = passedToDetailDownloadLink
        }
        bigImage.layer.cornerRadius = 30
        authorsListDataLabel.text = passedToDetailAthors
        FavoriteOutletButton.layer.cornerRadius = FavoriteOutletButton.bounds.height / 2
    }
}

//
//  BookDetailController.swift
//  My Book
//
//  Created by Reza Kashkoul on 6/31/1400 AP.
//

import UIKit


class BookDetailController: UIViewController , UIGestureRecognizerDelegate {
    
    
    
    
    
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var titleDataLabel: UILabel!
    @IBOutlet weak var PageCountDataLabel: UILabel!
    @IBOutlet weak var ratingCountDataLabel: UILabel!
    @IBOutlet weak var avarageRatingDataLabel: UILabel!
    
    @IBOutlet weak var pageCountStackView: UIStackView!
    @IBOutlet weak var ratingCountStackView: UIStackView!
    @IBOutlet weak var avarageRatingStackView: UIStackView!
    
    @IBOutlet weak var downloadLinkDataLabel: UILabel!
    @IBOutlet weak var authorsListDataLabel: UILabel!
    @IBOutlet weak var FavoriteOutletButton: UIButton!
    
    @IBAction func addAndRemoveFavoriteButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        if let unWrappedSavedBookArray = chosenBookCellArray {
            if chosenBookCellArray != nil {
                print("______________LOG = Not nil______________")
                vc.favoriteItem = unWrappedSavedBookArray
            }
            vc.passedToFavoriteTitleDataLabel = unWrappedSavedBookArray.volumeInfo.title
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    var chosenBookCellArray : Items!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadLinkDataLabel.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapLabelDemo))
        downloadLinkDataLabel.addGestureRecognizer(tap)
        tap.delegate = self
        
        guard let url = URL(string: chosenBookCellArray?.volumeInfo.imageLinks?.thumbnail ?? "") else { return  }
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
        
        bigImage.image = UIImage(named: (chosenBookCellArray?.volumeInfo.imageLinks?.thumbnail)!)
        if chosenBookCellArray?.accessInfo.epub?.downloadLink == nil {
            downloadLinkDataLabel.textColor = .black
            downloadLinkDataLabel.text = "Unfortunatly there's no download link for this Book"
        } else {
            downloadLinkDataLabel.text = chosenBookCellArray?.accessInfo.epub?.downloadLink
        }
        bigImage.layer.cornerRadius = 30
        titleDataLabel.text = chosenBookCellArray?.volumeInfo.title
        
        if chosenBookCellArray?.volumeInfo.pageCount?.description != nil {
            PageCountDataLabel.text = chosenBookCellArray?.volumeInfo.pageCount?.description
        } else {
            pageCountStackView.isHidden = true
        }
        if chosenBookCellArray?.volumeInfo.ratingCount?.description != nil {
            ratingCountDataLabel.text = chosenBookCellArray?.volumeInfo.ratingCount?.description
        } else {
            ratingCountStackView.isHidden = true
        }
        if chosenBookCellArray?.volumeInfo.averageRating?.description != nil {
            avarageRatingDataLabel.text = chosenBookCellArray?.volumeInfo.averageRating?.description
        } else {
            avarageRatingStackView.isHidden = true
        }
        authorsListDataLabel.text = chosenBookCellArray?.volumeInfo.authors?.first
        FavoriteOutletButton.layer.cornerRadius = FavoriteOutletButton.bounds.height / 2
    }
    
    @objc func didTapLabelDemo(sender: UITapGestureRecognizer) {
        print("Open the link! \(sender)")
        guard let url = URL(string: chosenBookCellArray?.volumeInfo.imageLinks?.thumbnail ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
}

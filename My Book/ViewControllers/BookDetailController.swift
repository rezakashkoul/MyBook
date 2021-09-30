//
//  BookDetailController.swift
//  My Book
//
//  Created by Reza Kashkoul on 6/31/1400 AP.
//
var modalDataPasser : Items?
var favoriteCollection : [Items]?

import UIKit

//MARK: This ViewController is the controller of the "Modal page" that shows when choosing a cell in tab "Search"
class BookDetailController: UIViewController , UIGestureRecognizerDelegate {
    
    //MARK:  Page Outlets:
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var titleDataLabel: UILabel!
    @IBOutlet weak var PageCountDataLabel: UILabel!
    @IBOutlet weak var ratingCountDataLabel: UILabel!
    @IBOutlet weak var avarageRatingDataLabel: UILabel!
    @IBOutlet weak var downloadLinkDataLabel: UILabel!
    @IBOutlet weak var authorsListDataLabel: UILabel!
    @IBOutlet weak var FavoriteOutletButton: UIButton!
    //MARK:  stackView IBOutlets that can hide/show parts of view when the releated peice of data are available or not
    @IBOutlet weak var pageCountStackView: UIStackView!
    @IBOutlet weak var ratingCountStackView: UIStackView!
    @IBOutlet weak var avarageRatingStackView: UIStackView!
    //MARK:  Page Actions:
    @IBAction func addAndRemoveFavoriteButton(_ sender: Any) {
        //Passing Data to FavoriteVIewController
        let vc = storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        
        if let unWrappedSavedBookArray = chosenBookCellArray {
            if chosenBookCellArray != nil {
                modalDataPasser = chosenBookCellArray
                //favoriteCollection?.append(modalDataPasser!)

                print("______________LOG = Not nil______________")
               // vc.favoriteList?.append(modalDataPasser!)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:  Variables
    var chosenBookCellArray : Items!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        downloadLinkDataLabel.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(goToSafariAndDownloadTheBook))
        downloadLinkDataLabel.addGestureRecognizer(tap)
        tap.delegate = self
        
        //MARK: The needed reqirements for showing image from URL through the tableViewCells
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
    //MARK: Functions
    /**
     This method is created to open the safari and go to book URL just by touching the shown label "downloadLinkDataLabel"
     */
    @objc func goToSafariAndDownloadTheBook(sender: UITapGestureRecognizer) {
        print("Open the link! \(sender)")
        guard let url = URL(string: chosenBookCellArray?.accessInfo.epub?.downloadLink ?? "") else { return }
        UIApplication.shared.open(url)
    }
}

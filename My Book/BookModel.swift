//
//  Network.swift
//  My Book
//
//  Created by Reza Kashkoul on 6/30/1400 AP.
//

import UIKit

//for author
//https://www.googleapis.com/books/v1/volumes?q=\()+inauthor

//for title
//https://www.googleapis.com/books/v1/volumes?q=\()+intitle


struct BookModel : Codable {
    var items : [Items]
}
struct Items : Codable {
    var id : String?
    var volumeInfo : VolumeInfo
    var accessInfo : AccessInfo
}
struct VolumeInfo : Codable {
    var title : String?
    var authors : [String]?
    var pageCount : Int?
    var ratingCount : Int?
    var averageRating : Int?
    var imageLinks : ImageLink?
}
struct ImageLink : Codable {
    var smallThumbnail : String?
    var thumbnail : String?
}

struct AccessInfo : Codable {
    var epub : Epub?
}
struct Epub : Codable {
    var downloadLink : String?
}

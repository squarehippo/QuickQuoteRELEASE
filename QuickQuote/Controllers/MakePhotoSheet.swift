//
//  MakePhotoSheet.swift
//  QuickQuote
//
//  Created by Brian Wilson on 12/18/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//
import UIKit

class MakePhotoSheet {
    
    var maxPhotosPerPage = 2
    var sheetArray = [UIView]()
    
    func makeSheet(quote: Quote) -> [UIView] {
        if let totalPhotos = quote.images?.count {
            
            for index in 0..<totalPhotos {
                if index % maxPhotosPerPage == 0 {
                    let newPhotoSheet = PhotoSheet()
                    newPhotoSheet.quoteNumber.text = quote.quoteNumber
                    newPhotoSheet.photoStack2.isHidden = true
                    
                    let photos = (Array(quote.images!) as? [Image])!.sorted(by: { ($0.dateCreated!).compare($1.dateCreated!) == .orderedAscending })
                    
                    for (thisIndex, photo) in Array(photos).enumerated() where thisIndex >= index && thisIndex < index + maxPhotosPerPage {
                        switch thisIndex {
                        case index + 0:
                            newPhotoSheet.photo1.image = UIImage(data: photo.imageData!)
                            newPhotoSheet.caption1.text = photo.caption
                        case index + 1:
                            newPhotoSheet.photoStack2.isHidden = false
                            newPhotoSheet.photo2.image = UIImage(data: photo.imageData!)
                            newPhotoSheet.caption2.text = photo.caption
                        default:
                            break
                        }
                    }
                    sheetArray.append(newPhotoSheet)
                }
            }
        }
        return sheetArray
    }
}

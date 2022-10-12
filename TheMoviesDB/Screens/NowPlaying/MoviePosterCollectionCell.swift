//
//  MoviePosterCollectionCell.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import UIKit

class MoviePosterCollectionCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var video: Movie? {
      didSet {
        titleLabel.text = video?.title
        
      }
    }
}


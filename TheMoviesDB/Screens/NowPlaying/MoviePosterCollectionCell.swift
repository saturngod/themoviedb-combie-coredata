//
//  MoviePosterCollectionCell.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import UIKit
import SDWebImage

class MoviePosterCollectionCell: UICollectionViewCell {
    
    static var nibName: String = "MoviePosterCollectionCell"
    
    static var reuseIdentifier: String {
      return String(describing: MoviePosterCollectionCell.self)
    }
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var video: Movie? {
        didSet {
            titleLabel.text = video?.title
            if let imgPath = video?.posterPath {
                thumbnailView.sd_setImage(with: URL(string: "\(ApiConstants.smallImageUrl)/\(imgPath)"), placeholderImage: UIImage(named: "cover"))
            }
        }
    }
}


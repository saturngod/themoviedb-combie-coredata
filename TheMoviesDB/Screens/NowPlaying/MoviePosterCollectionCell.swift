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
    
    var video: Movie? {
        didSet {
            if let imgPath = video?.posterPath {
                
                if self.frame.width > self.frame.height, let backdrop = video?.backdropPath {
                    thumbnailView.sd_setImage(with: URL(string: "\(ApiConstants.smallImageUrl)/\(backdrop)"), placeholderImage: UIImage(named: "cover"))
                }
                else {
                    thumbnailView.sd_setImage(with: URL(string: "\(ApiConstants.smallImageUrl)/\(imgPath)"), placeholderImage: UIImage(named: "cover"))
                }
            }
        }
    }
}


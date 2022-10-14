//
//  SearchResultCell.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 14/10/2022.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    
    var video: Movie? {
        didSet {
            titleLabel.text = video?.title
            dateLabel.text = video?.dateInfo
            genreLabel.text = video?.genreText
            voteAverageLabel.text = "\(video?.voteAverage ?? 0)"
            voteCount.text = "\(video?.voteCount ?? 0)"
            
            if let imgPath = video?.posterPath {
 
                    thumbnailView.sd_setImage(with: URL(string: "\(ApiConstants.smallImageUrl)/\(imgPath)"), placeholderImage: UIImage(named: "cover"))
            
            }
        }
    }
}

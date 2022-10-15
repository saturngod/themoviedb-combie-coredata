//
//  DetailViewController.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 15/10/2022.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    @IBOutlet weak var backDropImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var vm: DefaultViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        guard let video = vm?.getMovie() else {
            return
        }
        self.navigationItem.title = video.title
        
        titleLabel.text = video.title
        releaseDateLabel.text = video.dateInfo
        genreLabel.text = video.genreText
        ratingLabel.text = "\(video.voteAverage)"
        voteCountLabel.text = "\(video.voteCount)"
        descriptionLabel.text = video.overview
        
        if let imgPath = video.posterPath {

            coverImage.sd_setImage(with: URL(string: "\(ApiConstants.smallImageUrl)/\(imgPath)"), placeholderImage: UIImage(named: "cover"))
        
        }
        
        if let backdrop = video.backdropPath {
            backDropImage.sd_setImage(with: URL(string: "\(ApiConstants.originalImageUrl)/\(backdrop)"), placeholderImage: UIImage(named: "cover"))
        }
    }
    
    
    
}

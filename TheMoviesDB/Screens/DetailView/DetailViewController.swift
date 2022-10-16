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
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<DetailViewModel.Input,Never> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        input.send(.appear)
    }
    
    @objc private func changeFav() {
        input.send(.toggleFavourite)
    }
    
    func bind() {
        if let viewmodel = vm as? DetailViewModel {
            let output = viewmodel.transform(input: self.input.eraseToAnyPublisher())
            output.receive(on: DispatchQueue.main)
                .sink {[weak self] event in
                    switch event {
                    case .changeFav(let fav):
                        self?.setupUI(fav: fav)
                    
                    }
                }.store(in: &cancellables)
            
        }
    }
    
    private func setupUI(fav: Bool) {
        var image:UIImage!
        if(fav) {
            image = UIImage(systemName: "star.fill")
        }
        else {
            image = UIImage(systemName: "star")
        }
        
        let favBtn = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(changeFav))
        self.navigationItem.rightBarButtonItem = favBtn
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

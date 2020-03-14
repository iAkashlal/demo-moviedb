//
//  movieDetailsVC.swift
//  TMDb-Client
//
//  Created by Akashlal on 14/03/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import UIKit

class MovieDetailsVC: UIViewController {

    var movie: MovieBinding!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = movie.originalTitle
        ratingsLabel.text = "\(movie.rating)"
        releaseDateLabel.text = movie.released
        thumbnailImage.sd_setImage(with: URL(string: movie.thumbnail)) { (image, error, cache, url) in
//            for Debugs
//            debugPrint(url)
        }
        synopsisTextView.text = movie.synopsis
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

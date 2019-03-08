//
//  MovieDetailViewController.swift
//  HeadyTest
//
//  Created by Deeksha on 3/7/19.
//  Copyright © 2019 Deeksha. All rights reserved.
//

import UIKit
import MBProgressHUD

class MovieDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var movieDetailTableVIew: UITableView!
    var movieID : Int!
    var movieDetail:Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieDetailTableVIew.tableFooterView = UIView()
        if movieID != nil && movieID > 0 {
            getMovieDetails()
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK: Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movieDetail != nil {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 300
        case 1:
            var cellHeight = heightForLabel(text: self.movieDetail.overview, font: UIFont.systemFont(ofSize: 14.0), width: UIScreen.main.bounds.width-30)+59
            if cellHeight < 69 {
                cellHeight = 69
            }
            return cellHeight
        case 2:
            return 69
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.af_setImage(withURL: URL(string: imageURLPrefix + self.movieDetail.posterPath)!)
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "synopsis", for: indexPath)
            let plotSynopsis = cell.viewWithTag(1) as! UILabel
            plotSynopsis.text = self.movieDetail.overview
            break
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "rating", for: indexPath)
            let rating = cell.viewWithTag(1) as! UILabel
            rating.text = "\(self.movieDetail.rating)"
            let releaseDate = cell.viewWithTag(2) as! UILabel
            releaseDate.text = self.movieDetail.releaseDate
            break
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }

    //MARK: Movie Details
    func getMovieDetails() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkHelper.getInstance().getRequest(url: "https://api.themoviedb.org/3/movie/\(movieID ?? 0)?api_key=\(APIKey)",callBack: { (data, error) -> (Void) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    do  {
                        
                       self.movieDetail = try JSONDecoder().decode(Movie.self, from: data!)
                        self.title = self.movieDetail.title
                        self.movieDetailTableVIew.reloadData()
                    } catch {
                    }
                }
            }
        })
    }
    
    //MARK: Calculate Dynamic Height For Label
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}

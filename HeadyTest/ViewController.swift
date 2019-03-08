//
//  ViewController.swift
//  HeadyTest
//
//  Created by Deeksha on 3/7/19.
//  Copyright © 2019 Deeksha. All rights reserved.
//

import UIKit
import MBProgressHUD
import AlamofireImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var pageNumber = 1
    var popularityBool = true
    var movieListImage = [String]()
    var movieId = [Int]()
    var movieName = [String]()
    var loadMore = true
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = VerticalFlowLayout()
        self.addNavigationRightButton()
        getMovieList(page: pageNumber)
    }
    //MARK: Add Sort Button
    func addNavigationRightButton() {
        let menu = UIButton(type: .custom)
        menu.frame = CGRect(x: 0, y: -10, width: 30, height: 20)
        menu.setTitle("Sort", for: .normal)
        menu.addTarget(self, action: #selector(self.openActionSheet), for: .touchUpInside)
        menu.backgroundColor = UIColor.lightGray
        menu.layer.cornerRadius = 5.0
        let item1 = UIBarButtonItem(customView: menu)
        navigationItem.rightBarButtonItems = [item1]
    }
    
    /// Sorting Options
    @objc func openActionSheet() {
        let actionSheet = UIAlertController.init(title: "Sort", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Most Popular", style: UIAlertAction.Style.default, handler: { (action) in
            if !self.popularityBool {
                self.popularityBool = true
                self.pageNumber = 1
                self.loadMore = true
                self.movieListImage = [String]()
                self.movieId = [Int]()
                self.movieName = [String]()
                self.collectionView.reloadData()
                self.getMovieList(page: self.pageNumber)
            }
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Highest Rated", style: UIAlertAction.Style.default, handler: { (action) in
            if self.popularityBool {
                self.popularityBool = false
                self.pageNumber = 1
                self.loadMore = true
                self.movieListImage = [String]()
                self.movieId = [Int]()
                self.movieName = [String]()
                self.collectionView.reloadData()
                self.getMovieList(page: self.pageNumber)
            }
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: Collection View Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movieListImage.count > 0 {
            return movieListImage.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MovieListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieListCollectionViewCell
        DispatchQueue.main.async {
            cell.imageView.af_setImage(withURL: URL(string: imageURLPrefix + self.movieListImage[indexPath.row])!)
        }
        cell.movieName.text = movieName[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        nextViewController.movieID = movieId[indexPath.row]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //AMRK: Function for Pagination
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height) {
    //            pageNumber += 1
    //            print(pageNumber)
    //            self.getMovieList(page: self.pageNumber)
    //        }
    //    }
    
    //MARK: Search Bar Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func  searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.popularityBool = true
        self.pageNumber = 1
        loadMore = true
        movieListImage = [String]()
        movieId = [Int]()
        movieName = [String]()
        self.collectionView.reloadData()
        if (searchBar.text?.count)! > 0 {
            self.searchList(page: pageNumber, searchText: searchBar.text!)
        } else {
            self.getMovieList(page: pageNumber)
        }
    }
    
    //MARK: Search A Movie
    func searchList(page:Int,searchText:String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = APIURLPrefix+searchApi+"api_key=\(APIKey)&query=\(searchText.replacingOccurrences(of: " ", with: "+"))"
        NetworkHelper.getInstance().getRequest(url: url,callBack: { (data, error) -> (Void) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    do  {
                        let movie = try JSONDecoder().decode(APIResults.self, from: data!)
                        if movie.movies.count > 0 {
                            for i in 0..<movie.movies.count {
                                if self.movieId.count > 0 {
                                    if !self.movieId.contains(movie.movies[i].id!) {
                                        self.movieListImage.append(movie.movies[i].posterPath)
                                        self.movieId.append(movie.movies[i].id!)
                                        self.movieName.append(movie.movies[i].title)
                                    }
                                } else {
                                    self.movieListImage.append(movie.movies[i].posterPath)
                                    self.movieId.append(movie.movies[i].id!)
                                    self.movieName.append(movie.movies[i].title)
                                }
                            }
                        } else {
                            self.loadMore = false
                        }
                        self.collectionView.reloadData()
                    } catch {
                        self.loadMore = false
                    }
                }
            }
        })
        
    }
    
    //MARK: Get List of Movies
    func getMovieList(page:Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        searchBar.text = ""
        var url = ""
        if !popularityBool {
            url = APIURLPrefix+highestRated+"page=\(page)&api_key=\(APIKey)"
        } else {
            url = APIURLPrefix+popularity+"page=\(page)&api_key=\(APIKey)"
        }
        print(url)
        NetworkHelper.getInstance().getRequest(url: url,callBack: { (data, error) -> (Void) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    do  {
                        let movie = try JSONDecoder().decode(APIResults.self, from: data!)
                        if movie.movies.count > 0 {
                            for i in 0..<movie.movies.count {
                                if self.movieId.count > 0 {
                                    if !self.movieId.contains(movie.movies[i].id!) {
                                        self.movieListImage.append(movie.movies[i].posterPath)
                                        self.movieId.append(movie.movies[i].id!)
                                        self.movieName.append(movie.movies[i].title)
                                    }
                                } else {
                                    self.movieListImage.append(movie.movies[i].posterPath)
                                    self.movieId.append(movie.movies[i].id!)
                                    self.movieName.append(movie.movies[i].title)
                                }
                            }
                            print(self.movieListImage)
                        } else {
                            self.loadMore = false
                        }
                        self.collectionView.reloadData()
                    } catch {
                        self.loadMore = false
                    }
                }
            }
        })
    }
}

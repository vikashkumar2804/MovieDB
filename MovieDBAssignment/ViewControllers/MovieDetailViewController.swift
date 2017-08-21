//
//  MovieDetailViewController.swift
//  MovieDBAssignment
//
//  Created by Vikash on 02/08/17.
//  Copyright © 2017 Vikash. All rights reserved.
//

import UIKit
import Kingfisher
class MovieDetailViewController: UIViewController {
    //MARK:- Outlet Connection -
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var DescriptionLbl: UILabel!
    @IBOutlet var voteAverageLbl : UILabel!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var posterimageView: UIImageView!
    @IBOutlet var checkUnchackImageView: UIImageView!
    @IBOutlet var adultLbl: UILabel!
    //MARK:-  Variable Declearation -
    var moviesDataArray = [String : Any]()
    //MARK:- View LIfe Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        dispalyContent()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    func dispalyContent()
    {
        //        self.title = self.moviesDataArray.object(forKey: "original_title") as? String
        //        let imageUrl = constant.imageBaseUrl + (self.moviesDataArray.object(forKey: "backdrop_path") as? String)!
        //        posterimageView.kf.setImage(with: URL(string: imageUrl ), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        //        self.DescriptionLbl.text = self.moviesDataArray.object(forKey: "overview") as? String
        //        self.titleLbl.text = self.moviesDataArray.object(forKey: "original_title") as? String
        //        self.voteAverageLbl.text = "Rating: " + String(describing: self.moviesDataArray.object(forKey: "vote_average") as! NSNumber) + " / 10"
        //        self.releaseDate.text =  "Release Date : " + String(describing: self.moviesDataArray.object(forKey: "release_date") as! String)
        //        let adult = self.moviesDataArray.object(forKey: "adult") as! Bool
        //        if(adult)
        //        {
        //            self.adultLbl.text = "A"
        //        }else{
        //            self.adultLbl.text = "U/A"
        //
        //        }
        print("array data=\(moviesDataArray)")
        
        self.title = self.moviesDataArray["original_title"] as? String
        self.DescriptionLbl.text = self.moviesDataArray["overview"] as? String
        self.titleLbl.text = self.moviesDataArray["original_title"] as? String
        self.voteAverageLbl.text = "Rating: " + String(self.moviesDataArray["vote_average"] as! Int) + " / 10"
        self.releaseDate.text = "Release Date: " + String(describing: self.moviesDataArray["release_date"] as! String)
        let adult = self.moviesDataArray["adult"] as! Bool
        if(adult)
        {
            self.adultLbl.text = "A"
        }else{
            self.adultLbl.text = "U/A"
        }
        guard self.moviesDataArray["backdrop_path"] != nil else{
            posterimageView.kf.setImage(with: URL(string: "" ), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            return
        }
        
        let  imageUrl = constant.imageBaseUrl + (self.moviesDataArray["backdrop_path"] as? String)!
        posterimageView.kf.setImage(with: URL(string: imageUrl ), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        
    }
        
    
}

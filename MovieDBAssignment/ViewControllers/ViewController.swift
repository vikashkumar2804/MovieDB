//
//  ViewController.swift
//  MovieDBAssignment
//
//  Created by Vikash on 31/07/17.
//  Copyright © 2017 Vikash. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import NVActivityIndicatorView
private let reuseIdevarfier = "CollectionCell"

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate{
    //MARK: - outlet connection -
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var filterView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterButton: UIBarButtonItem!
    @IBOutlet var mostPopularButton: UIButton!
    @IBOutlet var heightRatedButton: UIButton!
    @IBOutlet var noDataLbl: UILabel!
    
    //MARK: - variable declearation -
    var loaderView : NVActivityIndicatorView? = nil
    var loaderBackgrounView : UIView = UIView()
    var searchString : NSString = ""
    var moviesArray = NSMutableArray()
    var dict = NSDictionary()
    var pageNO: Int = 0
    var totalPage : Int = 0
    var barButtonClick : Bool = false
    var filter : Bool = false
    var filterselected : Bool = false
    var isSearching : Bool = false
    
    //MARK: - view Lifecyle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies List"
        self.searchBar.delegate = self
        self.filterView.isHidden = true
        let layout: UICollectionViewFlowLayout? = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let screen : CGRect = UIScreen.main.bounds
        layout?.itemSize=CGSize(width: screen.size.width/2-4, height: screen.size.height/2-32)
        pageNO = 1
        callWebService(pageNo: "\(pageNO)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Call webservice -
    
    func callWebService(pageNo:String)
    {
        if Connectivity.isConnectedToInternet(){
            setloader()
            self.loaderView?.startAnimating()
            
            let url : String
            
            if(isSearching)
            {
                url =  constant.searchUrl  + (searchString as String)
            }else if(filterselected){
                if(filter)
                {
                    url =  constant.popularUrl  + "\(pageNo)"
                    
                }else{
                    url =  constant.topRatedUrl  + "\(pageNo)"
                }
            }else{
                url =  constant.popularUrl  + "\(pageNo)"
            }
            
            Alamofire.request(url, headers:nil).responseJSON { response in
                //                print("response:\(response)")
                switch response.result
                {
                case .success: print("response: \(response.result)")
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: response.data! as Data, options: .allowFragments)
                    self.dict = jsonData as! NSDictionary
                    self.totalPage = self.dict.object(forKey: "total_pages") as! Int
                    if(self.pageNO==1)
                    {
                        self.moviesArray.removeAllObjects()
                        self.moviesArray.addObjects(from: self.dict.object(forKey: "results") as! [Any])
                        
                    }else{
                        self.moviesArray.addObjects(from: self.dict.object(forKey: "results") as! [Any])
                        
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.loaderBackgrounView.removeFromSuperview()
                        self.loaderView?.stopAnimating()
                    }
                } catch {
                    print("error in JSONSerialization")
                }
                    break
                case .failure: break
                }
            }
        }else{
            let alertView = UIAlertController(title: "Alert", message: "No internet connection", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func setloader()
    {
        let animationFrame = CGRect(x: (self.view.frame.size.width/2)-25, y: (self.view.frame.size.height/2)-25, width: 50, height: 50)
        self.loaderBackgrounView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.loaderBackgrounView.backgroundColor = UIColor.clear
        self.loaderView = NVActivityIndicatorView(frame: animationFrame, type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballClipRotatePulse.rawValue), color: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
        self.loaderView?.layer.masksToBounds=true;
        self.loaderBackgrounView.addSubview(self.loaderView!);
        self.view.addSubview(self.loaderBackgrounView)
        UIApplication.shared.keyWindow?.addSubview(self.loaderBackgrounView)
    }
    
    // MARK:- UICollectionViewDataSource -
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moviesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdevarfier, for: indexPath as IndexPath) as! CollectionViewCell
        let imageUrl = constant.imageBaseUrl + ((self.moviesArray.object(at: indexPath.row)as! NSDictionary).object(forKey: "poster_path") as? String)!
        print(imageUrl)
        cell.imageView.kf.setImage(with: URL(string: imageUrl ), placeholder: #imageLiteral(resourceName: "placeHolderImage"), options: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if(indexPath.row == self.moviesArray.count - 1)
        {
            if(pageNO<totalPage)
            {
                pageNO = pageNO + 1
                callWebService(pageNo: "\(pageNO)")
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        detailVC.moviesDataArray = self.moviesArray.object(at: indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.filterView.isHidden = true
    }
    
    
    // MARK: - Button Action Methods -
    
    @IBAction func FilterClicked(_ sender: Any) {
        
        if(barButtonClick)
        {
            barButtonClick = false
            self.filterView.isHidden = true
            filterselected = true
        }else{
            barButtonClick = true
            self.filterView.isHidden = false
            filterselected = true
        }
    }
    
    @IBAction func mostPopularBtnAction(_ sender: Any) {
        FilterClicked(true)
        filter = true
        pageNO=1;
        callWebService(pageNo: "\(pageNO)")
        self.mostPopularButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        self.heightRatedButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    
    @IBAction func highestRatedBtnAction(_ sender: Any) {
        FilterClicked(true)
        filter = false
        pageNO = 1;
        callWebService(pageNo: "\(pageNO)")
        self.mostPopularButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.heightRatedButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        
    }
    
    // MARK: - Searbar delegate methods -
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        self.filterButton.isEnabled=false
        searchBar.resignFirstResponder()
        isSearching=true
        let string = searchBar.text! as NSString
        self.searchString = string.replacingOccurrences(of: " ", with: "+") as NSString
        pageNO=1;
        callWebService(pageNo: "\(pageNO)")
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        pageNO=1;
        callWebService(pageNo: "\(pageNO)")
        self.filterButton.isEnabled = true
        
    }
}

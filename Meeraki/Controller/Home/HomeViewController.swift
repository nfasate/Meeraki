//
//  HomeViewController.swift
//  Meeraki
//
//  Created by Nilesh's MAC on 3/29/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    //MARK:- IBOutlet variables
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK:- Variables
    var photos = Photo.allPhotos()
    var filtered: [Photo] = []
    var navSearchBtn : UIBarButtonItem!
    var navAddProductBtn : UIBarButtonItem?
    var navSignOutBtn: UIBarButtonItem?
    var searchActive : Bool = false
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    //MARK:- Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Macros.Variables.isProfileCreated {
            Macros.Variables.isProfileCreated = false
            showLetsBeginScreen()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK:- Custom methods
    func setupView() {
        self.title = "My Product"
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        //self.automaticallyAdjustsScrollViewInsets = false
        
        addBarButtons()
    }
    
    func setGradientBackground() {
        let colorTop = UIColor(red: 80/255.0, green: 184/255.0, blue: 146/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 97/255.0, green: 202/255.0, blue: 146/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1.0)  //
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addBarButtons()
    {
        navSearchBtn = createNavSearchBtn()
        navAddProductBtn = createAddProductBtn()
        navSignOutBtn = createSignoutBtn()
        navigationItem.rightBarButtonItems  = [navAddProductBtn!, navSearchBtn]
        navigationItem.leftBarButtonItems = [navSignOutBtn!]
        //addRefreshControl()
    }
    
    func createSignoutBtn() -> UIBarButtonItem {
        let btnImage = #imageLiteral(resourceName: "download")
        let imageButton : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageButton.setBackgroundImage(btnImage, for: UIControlState())
        imageButton.addTarget(self, action: #selector(signOut(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: imageButton)
    }
    
    /**
     Create group button on for adding view right corner.
     */
    func createNavSearchBtn() -> UIBarButtonItem
    {
        let btnImage = #imageLiteral(resourceName: "search")
        let imageButton : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageButton.setBackgroundImage(btnImage, for: UIControlState())
        imageButton.addTarget(self, action: #selector(showNavSearchBar(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: imageButton)
    }
    
    /**
     Create group button on for adding view right corner.
     */
    func createAddProductBtn() -> UIBarButtonItem
    {
        let btnImage = #imageLiteral(resourceName: "addProduct")
        let imageButton : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageButton.setBackgroundImage(btnImage, for: UIControlState())
        imageButton.addTarget(self, action: #selector(showProductListScreen(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: imageButton)
    }
    
    func showSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems  = []
        navigationItem.leftBarButtonItems = []
        self.navigationItem.titleView = self.searchBar
        self.searchBar.alpha = 1
        searchBar.transform = CGAffineTransform(translationX: -500, y: searchBar.frame.origin.y)
        searchBar.subviews[0].subviews.flatMap(){ $0 as? UITextField }.first?.tintColor = UIColor.gray
        
        UIView.animate(withDuration: 0.4, animations: {
            self.searchBar.transform = .identity
        }) { (success) in
            self.searchBar.keyboardType = UIKeyboardType.asciiCapable
            self.searchBar.becomeFirstResponder()
        }
    }

    func hideSearchBar() {
        searchActive = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.6, animations: {
            self.searchBar.transform = CGAffineTransform(translationX: 5000, y: self.searchBar.frame.origin.y)
        }) { (success) in
            self.searchBar.alpha = 0.0
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItems  = [self.navAddProductBtn!, self.navSearchBtn]
            self.navigationItem.leftBarButtonItems = [self.navSignOutBtn!]
        }
    }
    
    func showLetsBeginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let letsBeginController = storyboard.instantiateViewController(withIdentifier: "LetsBeginViewController") as! LetsBeginViewController
        letsBeginController.isAfterReg = true
        letsBeginController.isSuccess = true
        letsBeginController.modalPresentationStyle = .overCurrentContext
        present(letsBeginController, animated: false, completion: nil)
    }
    
    func showProductInfoScreen(_ item: Photo) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productInfo = storyboard.instantiateViewController(withIdentifier: "ProductInfoViewController") as! ProductInfoViewController
        productInfo.title = item.caption
        //self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(productInfo, animated: true)
    }
    
    func showWebViewScreen(_ item: Photo) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webViewController.title = item.caption
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    //MARK:- Selector methods
    /**
     Present create group view controller on create group button tapped.
     */
    @objc func showNavSearchBar(_ sender: AnyObject)
    {
        showSearchBar()
    }
    
    @objc func signOut(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showProductListScreen(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productList = storyboard.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(productList, animated: true)
    }
}

//MARK:- UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(photos.count)
        if searchActive {
            return filtered.count
        }
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath)
        if let annotateCell = cell as? AnnotatedPhotoCell {
            if searchActive {
                annotateCell.photo = filtered[indexPath.item]
            }else {
                annotateCell.photo = photos[indexPath.item]
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        var item: Photo?
        if searchActive {
            hideSearchBar()
            item = filtered[indexPath.item]
        }else {
            item = photos[indexPath.item]
        }
        
        if item?.caption == "Samsung" {
            showWebViewScreen(item!)
        }else {
            showProductInfoScreen(item!)
        }
    }
}

//MARK:- PinterestLayoutDelegate
extension HomeViewController: PinterestLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if searchActive {
            return filtered[indexPath.item].image.size.height
        }
        return photos[indexPath.item].image.size.height
    }
}

//MARK:- UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        
        searchBar.text = nil
        searchBar.resignFirstResponder()
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        hideSearchBar()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true
        
        let searchString = searchBar.text
        if searchString != "" {
            filtered = photos.filter({ (item) -> Bool in
                let captionText: NSString = item.caption as NSString
                
                return (captionText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
        }else {
            searchActive = false
        }
        
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

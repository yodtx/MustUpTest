//
//  SlideUpViewController.swift
//  MustAppTest
//
//  Created by Антон Погремушкин on 05.03.17.
//  Copyright © 2017 Антон Погремушкин. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Alamofire
import AlamofireImage

class SlideUpViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var labelOne: UILabel!
    
    @IBOutlet weak var textDesc: UITextView!

    var searchResultsFilms = try! Realm().objects(Films.self)
    var searchResultsArt = try! Realm().objects(Artists.self)
    
    var labelTexts = ["One", "Two"]
    var textSearchName: String = ""
    
    var labelString:String? {
        didSet{
            configureView()
        }
    }
    
    func filterContent(_ searchText: String){
        let predicate = NSPredicate(format: "name BEGINSWITH [c] %@", searchText)
        let realm = try! Realm()
        searchResultsFilms = realm.objects(Films.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
        searchResultsArt = realm.objects(Artists.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
    }
    
    func configureView() {
        labelOne.text = labelString
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibs = UINib(nibName: "CollectionViewCellSlide", bundle: nil)
        
        self.collectionView.register(CollectionViewCellSlide.self, forCellWithReuseIdentifier: "Cells")
        self.collectionView.register(nibs, forCellWithReuseIdentifier: "Cells")
        
        filterContent(textSearchName)
        
       collectionView.delegate = self
        collectionView.dataSource = self
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchResultsFilms.count != 0
        {
        return searchResultsFilms.count
        } else {
            return searchResultsArt.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        


        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cells", for: indexPath) as! CollectionViewCellSlide
        
        if searchResultsFilms.count != 0
        {
            let imageString = searchResultsFilms[indexPath.row].image
            Alamofire.request(imageString).responseImage
                {
                    response in
                    if let image = response.result.value
                    {
                        cell.imageCellView.image = image
                    }
            }
        }else{
            let imageString = searchResultsArt[indexPath.row].image
            Alamofire.request(imageString).responseImage
                {
                    response in
                    if let image = response.result.value
                    {
                        cell.imageCellView.image = image
                    }
            }
        }

        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tittleString = searchResultsFilms[indexPath.row].name
        let informationView = InformationViewController()
        informationView.initSelf(label: tittleString)
        navigationController?.pushViewController(informationView, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

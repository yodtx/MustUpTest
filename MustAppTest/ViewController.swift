
//
//  ViewController.swift
//  MustAppTest
//
//  Created by Антон Погремушкин on 01.03.17.
//  Copyright © 2017 Антон Погремушкин. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Alamofire
import AlamofireImage

class ViewController: UIViewController, HorizontalScrollDelegate, UISearchBarDelegate{
    
    let realm = try! Realm()
    lazy var filmsRealm: Results<Films> = self.realm.objects(Films.self)
    lazy var artistRealm: Results<Artists> = self.realm.objects(Artists.self)
    lazy var relationsRealm: Results<Relations> = self.realm.objects(Relations.self)
    
    var searchResultsFilms = try! Realm().objects(Films.self)
    var searchResultsArt = try! Realm().objects(Artists.self)
    
    var filmsArray = [Films]()
    var artistsArray = [Artists]()

    @IBOutlet weak var searchBarStory: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarStory.delegate = self
        searchBarStory.enablesReturnKeyAutomatically = false
        searchBarStory.showsCancelButton = true
        
        defoultFilms()
        let hScroll1 = HorizontalScroll(frame: CGRect(x: 0, y: 200, width: 400, height: 200))
        hScroll1.delegate = self
        hScroll1.backgroundColor = UIColor.black
        self.view.addSubview(hScroll1)
        
        //Artists
        let hScroll2 = HorizontalScroll(frame: CGRect(x: 0, y: 450, width: 400, height: 200), flag: 1)
        hScroll2.delegate = self
        hScroll2.backgroundColor = UIColor.black
        self.view.addSubview(hScroll2)
        
        self.view.endEditing(true)
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBarStory.text != nil
        {
            let searchText = searchBarStory.text
            filterContent(searchText!)
            for index in 0..<searchResultsFilms.count
            {
                print(searchResultsFilms[index].name)
            }
            for index in 0..<searchResultsArt.count
            {
                print(searchResultsArt[index].name)
            }
            self.reload()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarStory.text = nil
        searchResultsFilms = try! Realm().objects(Films.self)
        searchResultsArt = try! Realm().objects(Artists.self)
        self.reload()
    }
    
    func reload (){
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    
    func filterContent(_ searchText: String){
        let predicate = NSPredicate(format: "name BEGINSWITH [c] %@", searchText)
        let realm = try! Realm()
        searchResultsFilms = realm.objects(Films.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
        searchResultsArt = realm.objects(Artists.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
        
    }
    
    func defoultFilms()
    {
        
        if (filmsRealm.count == 0 && artistRealm.count == 0)
        {
            
            try! realm.write
            {
                
                filmsArray = DataManagerInit.getToFilms()
                artistsArray = DataManagerInit.getToArtists()
                
                for film in filmsArray
                {
                    let newFilm = Films()
                    newFilm.name = film.name
                    newFilm.desc = film.desc
                    newFilm.image = film.image
                    self.realm.add(newFilm)
                }
                for artist in artistsArray
                {
                    let newArtist = Artists()
                    newArtist.name = artist.name
                    newArtist.desc = artist.desc
                    newArtist.image = artist.image
                    self.realm.add(newArtist)
                }
            }
        }
        
        if relationsRealm.count == 0   // Otnoshenie Tables 1 to 1 don't dodelannye
        {
            try! realm.write
            {
                for index in 0..<filmsRealm.count
                {
                    let newRelation = Relations()
                    newRelation.relationFilm = filmsRealm[index]
                    newRelation.relationArtist = artistRealm[index]
                    self.realm.add(newRelation)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfScrollViewElementsFilms() -> Int {
        return searchResultsFilms.count
    }
    
    func numberOfScrollViewElementsArt() -> Int {
        return searchResultsArt.count
    }

    
    func elementAtScrollViewIndex(index: Int) -> UIView
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))
        let button = UIButton()
        let name = searchResultsFilms[index].name
        
        button.center.x += self.view.bounds.width
        UIView.animate(withDuration: 1.7, delay: 0.4, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: ({
            button.center.x -= self.view.bounds.width
        }), completion: nil)
        
        
        let imageString = searchResultsFilms[index].image
        
        Alamofire.request(imageString).responseImage
            {
                response in
                if let image = response.result.value
                {
                    button.setImage(image, for: UIControlState.normal)
                }
            }
        
        
        button.frame = view.frame
        button.setTitle("\(name)", for: UIControlState.normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(clickButto(sender:)), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
        return view
    }
    
    func elementAtScrollViewIndexArtist(index: Int) -> UIView
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 130))
        let button = UIButton()
        let name = searchResultsArt[index].name
        
        button.center.x += self.view.bounds.width
        UIView.animate(withDuration: 1.7, delay: 0.4, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: ({
            button.center.x -= self.view.bounds.width
        }), completion: nil)
        
        let imageString = searchResultsArt[index].image
        
        Alamofire.request(imageString).responseImage
            {
                response in
                if let image = response.result.value
                {
                    button.setImage(image, for: UIControlState.normal)
                }
        }
        
        button.frame = view.frame
        button.setTitle("\(name)", for: UIControlState.normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(clickButto(sender:)), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
        return view
    }
    
    func clickButto(sender: UIButton) {
        let tittleString = sender.titleLabel!.text
        let informationView = InformationViewController()
        informationView.initSelf(label: tittleString!)
        navigationController?.pushViewController(informationView, animated: true)
    }

    

}


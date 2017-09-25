//
//  DataManagerInit.swift
//  MustAppTest
//
//  Created by Антон Погремушкин on 06.03.17.
//  Copyright © 2017 Антон Погремушкин. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataManagerInit{
    
    class func getToFilms() -> [Films]
    {
        var arrs = [Films]()
        let file = Bundle.main.path(forResource: "model", ofType: "json")
        let url = URL(fileURLWithPath: file!)
        let data = try! Data(contentsOf: url)
        let json = JSON(data:data)
        
        if let arrArray = json["Films"].array
        {
            for appDict in arrArray
            {
                let name: String = appDict["Name"].string!
                let desc: String = appDict["Desc"].string!
                let image: String = appDict["Image"].string!
                let arr = Films()
                arr.name = name
                arr.desc = desc
                arr.image = image
                arrs.append(arr)
            }
        }
        return arrs
    }
    
    class func getToArtists() -> [Artists]
    {
        var arrs = [Artists]()
        let file = Bundle.main.path(forResource: "model", ofType: "json")
        let url = URL(fileURLWithPath: file!)
        let data = try! Data(contentsOf: url)
        let json = JSON(data:data)
        
        if let arrArray = json["Actors"].array
        {
            for appDict in arrArray
            {
                let name: String = appDict["Name"].string!
                let desc: String = appDict["Desc"].string!
                let image: String = appDict["Image"].string!
                let arr = Artists()
                arr.name = name
                arr.desc = desc
                arr.image = image
                arrs.append(arr)
            }
        }
        return arrs
    }
}

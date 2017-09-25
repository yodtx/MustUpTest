//
//  RelationshipModel.swift
//  MustAppTest
//
//  Created by Антон Погремушкин on 03.03.17.
//  Copyright © 2017 Антон Погремушкин. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Relations: Object {
    dynamic var id: Int = 0
    dynamic var relationFilm: Films!
    dynamic var relationArtist: Artists!
}

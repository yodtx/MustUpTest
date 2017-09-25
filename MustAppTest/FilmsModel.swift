//
//  FilmsModel.swift
//  MustAppTest
//
//  Created by Антон Погремушкин on 03.03.17.
//  Copyright © 2017 Антон Погремушкин. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Films: Object {
    dynamic var name: String = ""
    dynamic var desc: String = ""
    dynamic var image: String = ""
}

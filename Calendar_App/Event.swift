//
//  Event.swift
//  Calendar_App
//
//  Created by Yusuke Murayama on 2021/02/09.
//

import Foundation
import RealmSwift

class Event: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var event: String = ""
}

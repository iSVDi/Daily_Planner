//
//  ActivityDataBase.swift
//  Daily_Planner
//
//  Created by Daniil on 20.01.2024.
//

import RealmSwift

class Activity: Object {
    @Persisted var title: String
    @Persisted var details: String
    @Persisted var dateStart: String
    @Persisted var dateFinish: String
}

class ActivityDataBase {

    private let realm: Realm? = {
        do {
            let realm = try Realm()
            return realm
        } catch {
            return nil
        }
    }()

    func addActivity(_ activity: Activity) throws {
        try realm?.write {
            realm?.add(activity)
        }
    }
}

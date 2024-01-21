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
    @Persisted var dateStart: TimeInterval
    @Persisted var dateFinish: TimeInterval
}

class ActivityDataBase {

    private let realm: Realm = {
        do {
            let realm = try Realm()
            return realm
        } catch {
            fatalError("Cannot create realm class")
        }
    }()

    func addActivity(_ activity: Activity) throws {
        try realm.write {
            realm.add(activity)
        }
    }

    func getActivitiesForDate(day: Date) throws -> [Activity] {
        let activities: [Activity] = realm.objects(Activity.self).filter {
            let activityDate = Date(timeIntervalSince1970: $0.dateStart)
            return Calendar.current.isDate(day, inSameDayAs: activityDate)
        }
        return activities
    }

}

//
//  ActivityListPresenter.swift
//  Daily_Planner
//
//  Created by Daniil on 20.01.2024.
//

import Foundation

struct ActivityCellStruct {
    let timeTitle: String
    let activities: [Activity]
}

struct Hour {
    let title: String
    let range: ClosedRange<TimeInterval>
}

class ActivityListPresenter {
    weak private var activityListDelegate: ActivityListDelegate?
    private let dataBase = ActivityDataBase()
    private(set) var activitiesByHours: [ActivityCellStruct] = []

    init(_ activityListDelegate: ActivityListDelegate) {
        self.activityListDelegate = activityListDelegate
    }

    func setActivitiesForDate(day: Date) {
        do {
            let activities = try dataBase.getActivitiesForDate(day: day)
            setActivitiesByHours(activities: activities, date: day)
            // TODO: set activities for view
        } catch {
            // TODO: handle error
            print(error.localizedDescription)

        }
    }

    // TODO: optimize
    private func setActivitiesByHours(activities: [Activity], date: Date) {
        guard let hours = date.byHoursX else {
            // TODO: handle error
            return
        }

        let dataCells = hours
            .map { hour in
                let activitiesByHour = activities.filter { activity in
                    let activityRange = activity.dateStart...activity.dateFinish
                    let hourStartInCond = activityRange.contains(hour.range.lowerBound)
                    let hourEndInCond = activityRange.contains(hour.range.upperBound)
                    return hourStartInCond || hourEndInCond
                }
                return ActivityCellStruct(timeTitle: hour.title, activities: activitiesByHour)
            }
            .filter {
                !$0.activities.isEmpty
            }
        activitiesByHours = dataCells
        activityListDelegate?.needUpdateTableView()

    }

    // TODO: remove after testing
    private func printActivitiesDetails() {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        activitiesByHours.forEach { cell in
            print("     " + cell.timeTitle)
            cell.activities.forEach { activity in
                let dateStart = Date(timeIntervalSince1970: activity.dateStart)
                let dateFinish = Date(timeIntervalSince1970: activity.dateFinish)
                print(formatter.string(from: dateStart) + " - " + formatter.string(from: dateFinish))
                print(activity.title)
                print("---------")
            }
            print()
        }
    }

}

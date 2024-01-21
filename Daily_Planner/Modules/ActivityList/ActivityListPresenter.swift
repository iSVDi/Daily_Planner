//
//  ActivityListPresenter.swift
//  Daily_Planner
//
//  Created by Daniil on 20.01.2024.
//

import Foundation

struct ActivityCellData {
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
    private(set) var activitiesByHours: [ActivityCellData] = []

    init(_ activityListDelegate: ActivityListDelegate) {
        self.activityListDelegate = activityListDelegate
    }

    func handleDidSelectDate(day: Date) {
        do {
            let activities = try dataBase.getActivitiesForDate(day: day)
            setActivitiesByHours(activities: activities, date: day)
            if activitiesByHours.isEmpty {
                activityListDelegate?.showEmptyLabel()
            } else {
                activityListDelegate?.needUpdateTableView()
            }
        } catch {
            activityListDelegate?.showEmptyLabel()
            activityListDelegate?.showAlert(title: ^String.Alerts.errorTitle, message: error.localizedDescription)
        }
    }

    private func setActivitiesByHours(activities: [Activity], date: Date) {
        guard let hours = date.byHours else {
            return
        }

        let dataCells = hours
            .map { hour in
                let activitiesByHour = activities.filter { activity in
                    let activityRange = activity.dateStart...activity.dateFinish
                    let hourStartInCond = activityRange.contains(hour.range.lowerBound)
                    let hourEndInCond = activityRange.contains(hour.range.upperBound)
                    let oneHourCond = hour.range.contains(activityRange.lowerBound) && hour.range.contains(activityRange.upperBound)
                    let res = hourStartInCond || hourEndInCond || oneHourCond
                    return res
                }
                return ActivityCellData(timeTitle: hour.title, activities: activitiesByHour)
            }
            .filter {
                !$0.activities.isEmpty
            }
        activitiesByHours = dataCells
    }

}

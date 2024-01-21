//
//  ActivityPresenter.swift
//  Daily_Planner
//
//  Created by Daniil on 20.01.2024.
//

import Foundation

class ActivityPresenter {

    weak private var activityDelegate: ActivityDelegate?
    private let dataBase = ActivityDataBase()

    init(_ activityDelegate: ActivityDelegate) {
        self.activityDelegate = activityDelegate
    }

    func isDatesCorrect(dateStart: Date, dateFinish: Date) -> Bool {
        guard Calendar.current.isDate(dateStart, inSameDayAs: dateFinish) else {
            activityDelegate?.showAlert(title: ^String.Alerts.cannotSaveActivityTitle, message: ^String.Alerts.belongOneDayTitle)
            return false
        }

        guard dateFinish.compare(dateStart) == .orderedDescending else {
            activityDelegate?.showAlert(title: ^String.Alerts.cannotSaveActivityTitle, message: ^String.Alerts.startDateBeforeTitle)
            return false
        }
        return true
    }

    func createActivity(activity: Activity) {
        do {
            try dataBase.addActivity(activity)
            activityDelegate?.closeController()
        } catch {
            activityDelegate?.showAlert(title: ^String.Alerts.errorTitle, message: error.localizedDescription)
        }
    }

}

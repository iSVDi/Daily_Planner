//
//  CreateActivityPresenter.swift
//  Daily_Planner
//
//  Created by Daniil on 20.01.2024.
//

import Foundation

class CreateActivityPresenter {

    weak private var createActivityDelegate: CreateActivityDelegate?
    private let dataBase = ActivityDataBase()

    init(_ createActivityDelegate: CreateActivityDelegate) {
        self.createActivityDelegate = createActivityDelegate
    }

    // TODO: localize
    func isDatesCorrect(dateStart: Date, dateFinish: Date) -> Bool {
        guard Calendar.current.isDate(dateStart, inSameDayAs: dateFinish) else {
            createActivityDelegate?.showAlert(title: "Cannot Save Activity", message: "The start and end dates must belong to one day")
            return false
        }

        guard dateFinish.compare(dateStart) == .orderedDescending else {
            createActivityDelegate?.showAlert(title: "Cannot Save Activity", message: "The start date must be before the end date")
            return false
        }
        return true
    }

    func createActivity(activity: Activity) {
        do {
            try dataBase.addActivity(activity)
            createActivityDelegate?.closeController()
        } catch {
            // TODO: localize
            createActivityDelegate?.showAlert(title: "Error", message: error.localizedDescription)
        }
    }

}

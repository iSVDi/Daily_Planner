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

    func isDatesCorrect(dateStart: Date, dateFinish: Date) -> Bool {
        guard dateFinish.compare(dateStart) == .orderedDescending else {
            createActivityDelegate?.showAlert(title: "Cannot Save Activity", message: "The start date must be before the end date")
            return false
        }
        return true
    }

    func getTimeStamp(date: Date) -> String {
        return String(date.timeIntervalSince1970)
    }

    func createActivity(activity: Activity) {
        do {
            try dataBase.addActivity(activity)
        } catch {
            // TODO: localize
            createActivityDelegate?.showAlert(title: "Error", message: error.localizedDescription)
        }
    }

}

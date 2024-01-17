//
//  ActivityListViewController.swift
//  Daily_Planner
//
//  Created by Daniil on 17.01.2024.
//

import UIKit
import FSCalendar
import TinyConstraints

class ActivityListViewController: UIViewController {

    private let calendarView = FSCalendar()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultSettings()
        setupLayout()
        setupViews()
    }

    private func setupViews() {
        // TODO: localize
        navigationItem.title = "Activity List"
        calendarView.delegate = self
        // TODO: localize
        let rightBarButton = UIBarButtonItem(title: "Add",
                                             style: .plain,
                                             target: self,
                                             action: #selector(righBarButtonHandler))
        navigationItem.setRightBarButton(rightBarButton, animated: false)
    }

    private func setupLayout() {
        [calendarView, tableView].forEach {
            view.addSubview($0)
        }
        calendarView.horizontalToSuperview()
        calendarView.topToSuperview(usingSafeArea: true)
        calendarView.heightToWidth(of: calendarView)

        tableView.topToBottom(of: calendarView)
        tableView.bottomToSuperview(usingSafeArea: true)
        tableView.horizontalToSuperview()
    }

    @objc
    private func righBarButtonHandler() {
        let controller = CreateActivityViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

}

extension ActivityListViewController: FSCalendarDelegate {

    // TODO: add handler
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MM-yyyy"
        print(formatter.string(from: date))
    }

}

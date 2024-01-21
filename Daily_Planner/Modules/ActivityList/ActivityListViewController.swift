//
//  ActivityListViewController.swift
//  Daily_Planner
//
//  Created by Daniil on 17.01.2024.
//

import UIKit
import FSCalendar
import TinyConstraints

protocol ActivityListDelegate: NSObjectProtocol {
    func needUpdateTableView()
    func showEmptyLabel()
}

class ActivityListViewController: UIViewController {

    private let calendarView = FSCalendar()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let emptyLabel = UILabel()
    private lazy var presenter = ActivityListPresenter(self)

    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultSettings()
        setupLayout()
        setupViews()
    }

    // TODO: localize
    private func setupViews() {
        navigationItem.title = "Activity List"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: ActivityTableViewCell.description())
        calendarView.delegate = self

        let rightBarButton = UIBarButtonItem(title: "Add",
                                             style: .plain,
                                             target: self,
                                             action: #selector(righBarButtonHandler))
        navigationItem.setRightBarButton(rightBarButton, animated: false)
        emptyLabel.text = "No activities"
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true
    }

    private func setupLayout() {
        [calendarView, tableView, emptyLabel].forEach {
            view.addSubview($0)
        }
        calendarView.horizontalToSuperview()
        calendarView.topToSuperview(usingSafeArea: true)
        calendarView.heightToWidth(of: calendarView)

        [tableView, emptyLabel].forEach {
            $0.topToBottom(of: calendarView)
            $0.bottomToSuperview(usingSafeArea: true)
            $0.horizontalToSuperview()
        }
    }

    private func updateViews() {
        let needHideTable = presenter.activitiesByHours.isEmpty
        emptyLabel.isHidden = !needHideTable
        tableView.isHidden = needHideTable
    }

    @objc
    private func righBarButtonHandler() {
        let controller = CreateActivityViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK: - FSCalendarDelegate

extension ActivityListViewController: FSCalendarDelegate {

    // TODO: add handler
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        presenter.setActivitiesForDate(day: date)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ActivityListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.activitiesByHours.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.description(), for: indexPath)
        let data = presenter.activitiesByHours[indexPath.row]
        (cell as? ActivityTableViewCell)?.setData(data, completionHandler: { _ in
            print("open activity details")
        })
        return cell
    }

}

// MARK: - ActivityListDelegate

extension ActivityListViewController: ActivityListDelegate {

    func needUpdateTableView() {
        tableView.reloadData()
        updateViews()
    }

    func showEmptyLabel() {
        updateViews()
    }
}

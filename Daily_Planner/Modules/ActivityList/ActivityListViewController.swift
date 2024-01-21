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
    func showAlert(title: String, message: String)
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

    private func setupViews() {
        navigationItem.title = ^String.Activities.listTitle
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: ActivityTableViewCell.description())
        calendarView.delegate = self

        let rightBarButton = UIBarButtonItem(title: ^String.Common.addTitle,
                                             style: .plain,
                                             target: self,
                                             action: #selector(righBarButtonHandler))
        navigationItem.setRightBarButton(rightBarButton, animated: false)
        emptyLabel.text = ^String.Activities.noActivitiesTitle
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
        let controller = ActivityViewController.getController(for: .create) { [weak self] in
            guard let welf = self,
                  let selectedDate = welf.calendarView.selectedDate else {
                return
            }
            welf.presenter.handleDidSelectDate(day: selectedDate)
        }
        navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK: - FSCalendarDelegate

extension ActivityListViewController: FSCalendarDelegate {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        presenter.handleDidSelectDate(day: date)
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
        (cell as? ActivityTableViewCell)?.setData(data, completionHandler: { [weak self] activity in
            guard let welf = self else {
                return
            }
            let controller = ActivityViewController.getController(for: .details, activity)
            welf.navigationController?.pushViewController(controller, animated: true)
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

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: ^String.Common.okTitle, style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

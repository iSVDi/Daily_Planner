//
//  ActivityTableViewCell.swift
//  Daily_Planner
//
//  Created by Daniil on 21.01.2024.
//

import UIKit
import TinyConstraints

class ActivityTableViewCell: UITableViewCell {
    private let timeLabel = UILabel()
    private let activitiesStack = UIStackView()
    private var handler: ((Activity) -> Void)?
    private var data: ActivityCellStruct?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        timeLabel.text = nil
        activitiesStack.subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    private func setupViews() {
        activitiesStack.axis = .vertical
        activitiesStack.alignment = .fill
        activitiesStack.spacing = 1

    }

    private func setupLayout() {
        [timeLabel, activitiesStack].forEach {
            contentView.addSubview($0)
        }
        timeLabel.edgesToSuperview(excluding: [.bottom, .trailing], insets: .top(10) + .left(10), usingSafeArea: true)
        activitiesStack.edgesToSuperview(excluding: .leading, insets: .uniform(10))
        activitiesStack.leftToRight(of: timeLabel, offset: 10)
    }

    func setData(_ data: ActivityCellStruct, completionHandler: @escaping ((Activity) -> Void)) {
        self.handler = completionHandler
        timeLabel.text = data.timeTitle
        self.data = data
        data.activities.forEach {
            let button = UIButton()
            let title = $0.timeRange + " " + $0.title
            button.setTitle(title, for: .normal)
            button.setTitleColor(.appBlack, for: .normal)
            button.addTarget(self, action: #selector(buttonHandler(_:)), for: .touchUpInside)
            activitiesStack.addArrangedSubview(button)
        }
    }

    @objc
    private func buttonHandler(_ sender: UIButton) {
        guard let data = data,
              let id = activitiesStack.arrangedSubviews.firstIndex(of: sender) else {
            // TODO: handle error
            return
        }
        let activity = data.activities[id]
        handler?(activity)
    }

}

fileprivate extension Activity {
    var timeRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let start = Date(timeIntervalSince1970: dateStart)
        let end = Date(timeIntervalSince1970: dateFinish)
        let res = formatter.string(from: start) + " - " + formatter.string(from: end)
        return res
    }
}

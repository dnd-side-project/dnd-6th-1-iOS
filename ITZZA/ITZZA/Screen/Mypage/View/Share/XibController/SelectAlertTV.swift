//
//  SelectTV.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/03/15.
//

import UIKit

class SelectAlertTV: UIView {
    @IBOutlet weak var selectTV: UITableView!
    
    var reportPeriodList: [ReportPeriodModel]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        configureSelectTV()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        configureSelectTV()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.selectAlertTV) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureSelectTV() {
        selectTV.dataSource = self
        selectTV.delegate = self
        selectTV.register(UINib(nibName: Identifiers.selectTVC,
                                bundle: nil),
                          forCellReuseIdentifier: Identifiers.selectTVC)
        selectTV.separatorStyle = .none
    }
}

extension SelectAlertTV: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportPeriodList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifiers.selectTVC,
            for: indexPath) as? SelectTVC
        else { return UITableViewCell() }
        
        cell.configureCell(reportPeriodList?[indexPath.row] ?? ReportPeriodModel())
        return cell
    }
}

extension SelectAlertTV: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectTVC else { return }
        NotificationCenter.default.post(name: .whenReportWeekSelected, object: [cell.year!, cell.week!])
    }
}

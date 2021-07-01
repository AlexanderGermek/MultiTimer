//
//  ViewController.swift
//  MultiTimer
//
//  Created by iMac on 01.07.2021.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    
    //MARK: - Private properties -----------------------------------------------------------------------
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HeadTableViewCell.self, forCellReuseIdentifier: HeadTableViewCell.identifire)
        tableView.register(TimerTableViewCell.self, forCellReuseIdentifier: TimerTableViewCell.identifire)
        return tableView
    }()
    
    private var timers = [TimerModel]()
    private var timersViewModels = [TimerTableViewCellViewModel]()
    private var reallyTimer: Timer?

    //MARK: - Lifecycle -----------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Multi timer"
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        addConstraints()
    }
    
    
    //MARK: - Private func's --------------------------------------------------
    private func addConstraints() {
        tableView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func showTimerLabelsError(withMessage message: String) {
        
        let alert = UIAlertController(title: "Error in labels!",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alert, animated: true)
    }

}


//MARK: - Timer functions ---------------------------------------------------------

extension MainViewController {
    
    @objc private func updateTimer() {

        guard let visibleRowsIndexPaths = tableView.indexPathsForVisibleRows else {
            return
        }
        
        visibleRowsIndexPaths.forEach { indexPath in
   
            if let cell = tableView.cellForRow(at: indexPath) as? TimerTableViewCell {
                let timer = timers[indexPath.row]
                
                if timer.timeLeft <= 0 {
                    timers.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.tableView.beginUpdates()
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                        self.tableView.endUpdates()
                    }
                    
                    if timers.count == 0 {
                        cancelTimer()
                    }
                    
                } else {
                    cell.updateTime(withModel:
                                    TimerTableViewCellViewModel(name: timer.name,
                                                                time: timer.timeLeftString))
                }
                
            }
        }
    }
    
    private func createTimer() {

      if reallyTimer == nil {
        let timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        
        RunLoop.current.add(timer, forMode: .common)
        timer.tolerance = 0.1
        
        reallyTimer = timer
      }
    }
    
    private func cancelTimer() {
        reallyTimer?.invalidate()
        reallyTimer = nil
    }
}




//MARK: - HeadTableViewCellDelegate ------------------------------------------------------------------------
extension MainViewController: HeadTableViewCellDelegate {
    
    func headTableViewCellDidTapAddTimerButton(_ timerName: String?, _ timerTime: String?) {
        
        guard let timerNameString = timerName, !timerNameString.isEmpty else {
            showTimerLabelsError(withMessage: "The Timer name must not be empty!")
            return
        }
        
        guard let timerTimeString = timerTime, !timerTimeString.isEmpty, let time = Int(timerTimeString) else {
            showTimerLabelsError(withMessage: "Error in timer seconds!")
            return
        }
        
        //print("timer added with name =  \(timerNameString) and time = \(time)")
        
        
        let newTimer = TimerModel(name: timerNameString,
                                  timeInSeconds: time,
                                  creationDate: Date())
        
        
        timers.append(newTimer)
        
        timers.sort{$0.timeLeft > $1.timeLeft}
        
        createTimer()
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource -------------------------------------------------------
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return timers.count
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 163
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeadTableViewCell.identifire)
                            as? HeadTableViewCell else {
                return  UITableViewCell()
            }
            
            cell.delegate = self
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TimerTableViewCell.identifire)
                            as? TimerTableViewCell else {
                return  UITableViewCell()
            }
            
            let timer = timers[indexPath.row]
            cell.updateTime(withModel:
                            TimerTableViewCellViewModel(name: timer.name,
                                                        time: timer.timeLeftString))
            
            return cell
            
        default:
            return  UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Adding timers"
        case 1:
            return "Timers"
        default:
            return "Timers"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
}

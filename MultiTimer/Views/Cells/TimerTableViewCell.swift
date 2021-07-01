//
//  TimerTableViewCell.swift
//  MultiTimer
//
//  Created by iMac on 01.07.2021.
//

import UIKit
import SnapKit

class TimerTableViewCell: UITableViewCell {
    
    
    //MARK: - Constants --------------------------------------------------------------
    static let identifire = "TimerTableViewCell"
    
    
    //MARK: - Private properties -----------------------------------------------------
    private let timerNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "timer"
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "10"
        return label
    }()
    
    
    //MARK: - Lifecycle --------------------------------------------------------------
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(timerNameLabel)
        contentView.addSubview(timeLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let offset = CGFloat(10)
        let widthFor = (contentView.bounds.width  - offset * 2) / 2
        
        timerNameLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(offset)
            maker.top.equalToSuperview().offset(5)
            maker.height.equalTo(contentView.bounds.height * 0.8)
            maker.width.equalTo(widthFor)
        }
        
        timeLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().inset(offset)
            maker.top.equalToSuperview().offset(5)
            maker.height.equalTo(contentView.bounds.height * 0.8)
            maker.width.equalTo(widthFor)
        }
    }
    
    //MARK: - Configure ---------------------------------------------------------------------
    public func updateTime(withModel model: TimerTableViewCellViewModel) {
        timerNameLabel.text = model.name
        timeLabel.text      = model.time
    }
    
}

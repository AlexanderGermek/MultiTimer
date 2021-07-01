//
//  HeadTableViewCell.swift
//  MultiTimer
//
//  Created by iMac on 01.07.2021.
//

import UIKit

protocol HeadTableViewCellDelegate: AnyObject {
    func headTableViewCellDidTapAddTimerButton(_ timerName: String?, _ timerTime: String?)
}

final class HeadTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK: - Constants --------------------------------------------------------------
    static let identifire = "HeadTableViewCell"
    
    //MARK: - Public properties ------------------------------------------------------
    public weak var delegate: HeadTableViewCellDelegate?
    
    //MARK: - Private properties -----------------------------------------------------
    private let timerNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder            = "Timer name..."
        tf.textAlignment          = .left
        tf.returnKeyType          = .next
        tf.borderStyle            = .roundedRect
        tf.autocapitalizationType = .none
        tf.textContentType        = .none
        tf.autocorrectionType     = .no
        return tf
    }()
    
    private let timerTimeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder            = "Time in seconds..."
        tf.textAlignment          = .left
        tf.returnKeyType          = .done
        tf.borderStyle            = .roundedRect
        tf.autocapitalizationType = .none
        tf.textContentType        = .none
        tf.autocorrectionType     = .no
        return tf
    }()
    
    private let addTimerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Timer", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 30
        return button
    }()
    
    
    //MARK: - Lifecycle --------------------------------------------------------------
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(timerNameTextField)
        contentView.addSubview(timerTimeTextField)
        contentView.addSubview(addTimerButton)
        
        selectionStyle = .none
        
        timerNameTextField.delegate = self
        timerTimeTextField.delegate = self
        
        addTimerButton.addTarget(self, action: #selector(didTapAddTimerButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let widthFor = contentView.bounds.width * 0.75
        
        timerNameTextField.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(10)
            maker.height.equalTo(34)
            maker.width.equalTo(widthFor)
        }
        
        timerTimeTextField.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(timerNameTextField.snp.bottom).offset(5)
            maker.height.equalTo(34)
            maker.width.equalTo(widthFor)
        }
        
        addTimerButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(timerTimeTextField.snp.bottom).offset(10)
            maker.height.equalTo(60)
            maker.width.equalTo(contentView.bounds.width - 40)
        }
    }
    
    
    //MARK: - Actions ----------------------------------------------------------------
    @objc private func didTapAddTimerButton() {
        let timerName = timerNameTextField.text
        let timerTime = timerTimeTextField.text
        delegate?.headTableViewCellDidTapAddTimerButton(timerName, timerTime)
    }
    
    //MARK: - UITextFieldDelegate ----------------------------------------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if timerNameTextField.isFirstResponder {
            timerNameTextField.resignFirstResponder()
            timerTimeTextField.becomeFirstResponder()
            
        } else if timerTimeTextField.isFirstResponder {
            timerTimeTextField.resignFirstResponder()
        }
        
        return true
    }
}

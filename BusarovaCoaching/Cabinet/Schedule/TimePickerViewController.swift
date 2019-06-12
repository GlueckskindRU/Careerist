//
//  TimePickerViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 16/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit

class TimePickerViewController: UIViewController {
    private var delegate: TimeSaveDelegateProtocol?
    private var type: ArticleType?
    
    lazy private var backgroundView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(backgroungTap(recognizer:)))
        view.addGestureRecognizer(closeTap)
        
        return view
    }()
    
    lazy private var pickingView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        
        return view
    }()
    
    lazy private var timePicker: UIDatePicker = {
        let control = UIDatePicker()
        
        control.translatesAutoresizingMaskIntoConstraints = false
        control.locale = Locale(identifier: "ru_RU")
        control.timeZone = TimeZone.current
        control.datePickerMode = UIDatePicker.Mode.time
        control.minuteInterval = 30
        control.backgroundColor = .white
        
        return control
    }()
    
    lazy private var setupTimeButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Установить", for: UIControl.State.normal)
        button.setTitleColor(UIColor(named: "systemTint"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(setupTimeButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
// MARK: - UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func configure(hour: Int, minute: Int, delegate: TimeSaveDelegateProtocol, as type: ArticleType) {
        self.delegate = delegate
        self.type = type
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: Date())
        components.hour = hour
        components.minute = minute
        
        if let date = calendar.date(from: components) {
            timePicker.date = date
        }
    }
    
// MARK: - objc private functions
    @objc
    private func backgroungTap(recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func setupTimeButtonTapped(_ sender: UIButton) {
        guard let type = type else {
            return
        }
        
        let date = timePicker.date
        let calendar = Calendar.current
        let hour = calendar.component(Calendar.Component.hour, from: date)
        let minute = calendar.component(Calendar.Component.minute, from: date)
        
        delegate?.setTime(hour: hour, minute: minute, as: type)
        dismiss(animated: true, completion: nil)
    }
    
// MARK: - User Interface
    private func setupUI() {
        view.addSubview(backgroundView)
        
        view.addSubview(pickingView)
        pickingView.addSubview(timePicker)
        pickingView.addSubview(setupTimeButton)
        
        let width = UIScreen.main.bounds.size.width / 2
        let height = width * 1.25
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pickingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pickingView.widthAnchor.constraint(equalToConstant: width),
            pickingView.heightAnchor.constraint(equalToConstant: height),
            
            timePicker.topAnchor.constraint(equalTo: pickingView.topAnchor, constant: 12),
            timePicker.leadingAnchor.constraint(equalTo: pickingView.leadingAnchor, constant: 12),
            pickingView.trailingAnchor.constraint(equalTo: timePicker.trailingAnchor, constant: 12),
            
            setupTimeButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 12),
            pickingView.bottomAnchor.constraint(equalTo: setupTimeButton.bottomAnchor, constant: 12),
            setupTimeButton.centerXAnchor.constraint(equalTo: pickingView.centerXAnchor),
            ])
    }
}

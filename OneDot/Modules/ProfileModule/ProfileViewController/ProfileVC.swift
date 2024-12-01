//
//  ProfileViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit
import HealthKit

class ProfileVC: UIViewController {
    
    
    // MARK: - Properties
        let healthStore = HKHealthStore() // Для работы с HealthKit
        var workouts: [HKWorkout] = []   // Массив тренировок для отображения
        
        // Таблица для отображения тренировок
        let tableView: UITableView = {
            let table = UITableView()
            table.backgroundColor = .none
            table.translatesAutoresizingMaskIntoConstraints = false
            return table
        }()
    

    private let blurEffectView: UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effect.disableAutoresizingMask()
        effect.layer.masksToBounds = true
        effect.layer.cornerRadius = .barCorner
        return effect
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "additionalHideIcon"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setConstraints()
        
        setupTableView()
        requestHealthKitAccess()
    }
    
    // MARK: - Настройка таблицы
       func setupTableView() {
           blurEffectView.contentView.addSubview(tableView)
           tableView.dataSource = self
           tableView.delegate = self
           
           // Констрейнты для таблицы
           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.topAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
           ])
       }
       
       // MARK: - Запрос доступа к HealthKit
       func requestHealthKitAccess() {
           let workoutType = HKObjectType.workoutType() // Тип данных - тренировки
           
           healthStore.requestAuthorization(toShare: nil, read: [workoutType]) { [weak self] success, error in
               if success {
                   self?.fetchWorkouts()
                   print("fetchWorkouts")
               } else {
                   print("Ошибка при запросе доступа: \(error?.localizedDescription ?? "неизвестная ошибка")")
               }
           }
       }
       
       // MARK: - Загрузка данных о тренировках
       func fetchWorkouts() {
           let workoutType = HKObjectType.workoutType()
           let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
           
           let query = HKSampleQuery(sampleType: workoutType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] _, samples, error in
               if let error = error {
                   print("Ошибка загрузки тренировок: \(error.localizedDescription)")
                   return
               }
               
               guard let workouts = samples as? [HKWorkout] else { return }
               self?.workouts = workouts
               
               DispatchQueue.main.async {
                   self?.tableView.reloadData()
               }
           }
           
           healthStore.execute(query)
       }
    
    @objc private func dismissProfile() {
        dismiss(animated: true)
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        view.addSubview(blurEffectView)
        
        view.addSubview(dismissButton)
        
        dismissButton.addTarget(self, action: #selector(dismissProfile), for: .touchUpInside)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            blurEffectView.widthAnchor.constraint(equalToConstant: .barWidth),
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dismissButton.widthAnchor.constraint(equalToConstant: .iconSide),
            dismissButton.heightAnchor.constraint(equalToConstant: .iconSide),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}


extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return workouts.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "WorkoutCell")
           
           let workout = workouts[indexPath.row]
           cell.textLabel?.text = workout.workoutActivityType.name // Тип тренировки (название)
           
           let duration = workout.duration / 60 // Длительность в минутах
           let energy = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0 // Сожженные калории
           
           cell.detailTextLabel?.text = String(format: "Длительность: %.1f мин, Калории: %.0f ккал", duration, energy)
           return cell
       }
       
       // MARK: - UITableViewDelegate
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           let workout = workouts[indexPath.row]
           print("Вы выбрали тренировку: \(workout.workoutActivityType.name)")
       }
   }


// MARK: - Расширение для отображения названий типов тренировок
extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .running: return "Бег"
        case .walking: return "Ходьба"
        case .cycling: return "Велосипед"
        case .swimming: return "Плавание"
        case .yoga: return "Йога"
        case .other: return "Другое"
        default: return "Неизвестная тренировка"
        }
    }
}

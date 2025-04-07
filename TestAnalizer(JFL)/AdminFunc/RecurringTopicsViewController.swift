//
//  RecurringTopicsViewController.swift
//  TestAnalizer(JFL)
//
//  Created by Marlot Leonardo Hernandez Felix on 06/04/25.
//

import UIKit

class RecurringTopicsViewController: UIViewController {

    @IBOutlet weak var topicsLabel: UILabel!  // Usamos un UILabel para mostrar los temas recurrentes

      override func viewDidLoad() {
          super.viewDidLoad()
          
          // Cargar y mostrar los temas recurrentes
          let recurringTopics = loadRecurringTopicsFromJSON()
          topicsLabel.text = recurringTopics
      }

      // Función para cargar los temas recurrentes desde el archivo JSON
      func loadRecurringTopicsFromJSON() -> String {
          guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return "" }

          let fileURL = documentsURL.appendingPathComponent("user_data.json")
          do {
              let data = try Data(contentsOf: fileURL)
              let jsonObjects = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
              
              // Diccionario para contar la frecuencia de cada tema
              var topicCount: [String: Int] = [:]

              for obj in jsonObjects {
                  if let topics = obj["topics"] as? [String] {
                      for topic in topics {
                          topicCount[topic, default: 0] += 1
                      }
                  }
              }

              // Ordenar los temas por frecuencia
              let sortedTopics = topicCount.sorted { $0.value > $1.value }
              
              // Generar un string con los temas recurrentes
              var result = "Most common topics:\n"
              for (topic, count) in sortedTopics {
                  result += "\(topic): \(count)\n"
              }
              
              return result
              
          } catch {
              print("Error loading JSON: \(error)")
              return "Error loading data"
          }
      }

}

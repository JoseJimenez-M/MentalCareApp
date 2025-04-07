//
//  StreakManager.swift
//  TestAnalizer(JFL)
//
//  Created by english on 2025-04-01.
//

import Foundation

class StreakManager {
    var currentStreak: Int = 1  // Por defecto, la racha empieza en 1
    var lastInteractionDate: String?

    // Método para cargar los datos de la racha desde el archivo JSON
    func loadStreakData() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("user_data.json")
        
        do {
            if let dataFromFile = try? Data(contentsOf: fileURL) {
                let existingData = try JSONSerialization.jsonObject(with: dataFromFile, options: []) as! [[String: Any]]
                
                if let lastEntry = existingData.last,
                   let streak = lastEntry["streak"] as? Int,
                   let lastDate = lastEntry["lastInteractionDate"] as? String {
                    self.currentStreak = streak
                    self.lastInteractionDate = lastDate
                }
            }
        } catch {
            print("Error al cargar los datos de la racha: \(error.localizedDescription)")
        }
    }

    // Método para verificar y actualizar la racha
    func checkAndUpdateStreak() {
        let currentDate = getCurrentDate()

        // Si no hay datos previos, comenzamos la racha en 1 por defecto
        if let lastDate = lastInteractionDate {
            if currentDate == lastDate {
                // El usuario ya interactuó hoy, no actualizamos la racha
                return
            } else if isNextDay(from: lastDate, to: currentDate) {
                // El usuario interactuó ayer, la racha se incrementa
                currentStreak += 1
            } else {
                // La racha se rompió, reiniciar a 1
                currentStreak = 0
            }
        } else {
            // Si nunca se ha interactuado antes, comenzar la racha en 1
            currentStreak = 0
        }
        
        // Actualizar la última fecha de interacción
        lastInteractionDate = currentDate
    }

    // Método para obtener la fecha actual
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    // Método para comprobar si dos fechas son consecutivas
    private func isNextDay(from lastDate: String, to currentDate: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let last = formatter.date(from: lastDate),
           let current = formatter.date(from: currentDate) {
            let calendar = Calendar.current
            return calendar.isDate(current, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: last)!)
        }
        return false
    }
    
    // Método para guardar la racha en el archivo JSON
    func saveStreakData() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("user_data.json")
        
        do {
            var existingData: [[String: Any]] = []
            if let dataFromFile = try? Data(contentsOf: fileURL) {
                existingData = try JSONSerialization.jsonObject(with: dataFromFile, options: []) as! [[String: Any]]
            }
            
            // Guardar los nuevos datos de la racha
            let currentDate = getCurrentDate()
            let newData: [String: Any] = [
                "userName": "Juan",
                "date": currentDate,
                "streak": currentStreak,
                "lastInteractionDate": currentDate
            ]
            
            existingData.append(newData)  // Añadir el nuevo conjunto de datos
            let jsonData = try JSONSerialization.data(withJSONObject: existingData, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
            print("Datos de la racha guardados exitosamente.")
        } catch {
            print("Error al guardar los datos de la racha: \(error.localizedDescription)")
        }
    }
}


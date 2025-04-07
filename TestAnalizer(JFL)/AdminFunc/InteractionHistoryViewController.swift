//
//  InteractionHistoryViewController.swift
//  TestAnalizer(JFL)
//
//  Created by Marlot Leonardo Hernandez Felix on 06/04/25.
//

import UIKit
import Foundation

class InteractionHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Reference to the UITableView
    @IBOutlet weak var tableView: UITableView!
    // Array para almacenar las interacciones decodificadas
        var interactions: [Interaction] = []

        override func viewDidLoad() {
           

            super.viewDidLoad()

            // Cargar los datos desde el archivo JSON en Documents
            loadInteractionsFromDocuments()
            
            // Registra la clase para la celda personalizada
               tableView.register(InteractionCell.self, forCellReuseIdentifier: "InteractionCell")

               // Configurar delegate y datasource
               tableView.delegate = self
               tableView.dataSource = self
        }

    func filterAndGroupInteractions(from interactions: [Interaction]) -> [Interaction] {
        var uniqueDict: [String: Interaction] = [:]
        
        for interaction in interactions {
            guard let sentiment = interaction.sentiment, !sentiment.isEmpty else {
                continue
            }

            if uniqueDict[interaction.date] == nil {
                uniqueDict[interaction.date] = interaction
            }
        }

        return Array(uniqueDict.values)
    }

       
    func loadInteractionsFromDocuments() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent("user_data.json")

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()

            // Decodificar los datos
            let decodedData = try decoder.decode([Interaction].self, from: data)

            // Filtrar y agrupar por fecha, además de omitir los registros sin sentiment
            self.interactions = filterAndGroupInteractions(from: decodedData)

            // Recargar la tabla
            self.tableView.reloadData()
        } catch {
            print("Error loading data: \(error)")
        }
    }


        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return interactions.count // El número de filas es igual al número de interacciones
        }

        // Configuración de las celdas
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Obtener la celda reutilizable
            let cell = tableView.dequeueReusableCell(withIdentifier: "InteractionCell", for: indexPath)
            
            // Obtener la interacción para la fila actual
            let interaction = interactions[indexPath.row]
            
            // Mostrar los datos de la interacción en la celda
            let sentiment = interaction.sentiment ?? "No sentiment" // Si no hay sentimiento, mostramos "No sentiment"
            let date = interaction.date
            
            // Configurar el texto de la celda
            cell.textLabel?.text = "Date: \(date) | Sentiment: \(sentiment)"
            
            return cell
        }


}

struct Interaction: Codable {
    var streak: Int?
    var lastInteractionDate: String?
    var date: String
    var topics: [String]?
    var sentiment: String?
    var userName: String
}

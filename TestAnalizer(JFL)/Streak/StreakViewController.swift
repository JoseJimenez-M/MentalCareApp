//
//  StreakViewController.swift
//  TestAnalizer(JFL)
//
//  Created by english on 2025-04-01.
//
import UIKit

class StreakViewController: UIViewController {
    //userName
    @IBOutlet weak var usernameLabel: UILabel!
    //Quotes
    @IBOutlet weak var labelQuotes: UILabel!
    //UserRole
    var userRole: Int?
    @IBOutlet weak var adminFunc: UIButton!
    
    // Streak
    @IBOutlet weak var streakLabel: UILabel!
    let streakManager = StreakManager()
    
    @IBOutlet weak var btt_Logout: UIButton!
    
    @IBAction func buttonLogout(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            

            if let newViewController = storyboard.instantiateViewController(withIdentifier: "LoginStoryboard") as? ViewController {
                
                newViewController.modalPresentationStyle = .fullScreen
                
                self.present(newViewController, animated: true, completion: nil)
            }
    }
    
    //username
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let label = streakLabel {
                label.text = "Hola, Mundo"
            } else {
                print("streakLabel es nil")
            }
        
        // Streak
        streakManager.loadStreakData()
        streakManager.checkAndUpdateStreak()
        streakManager.saveStreakData()
        updateStreakLabel()
        
        //Role
        if userRole == 0 {
            adminFunc.isHidden = true
        } else {
            adminFunc.isHidden = false
        }

        //Quote
        fetchQuote()
      
        //UserName
        if let username = username {
                    usernameLabel.text = "Welcome, \(username)!"
                }

    }

    private func updateStreakLabel() {
        streakLabel.text = "\(streakManager.currentStreak)"
    }
    
    func fetchQuote() {
        let apiUrl = "https://zenquotes.io/api/random"
        
        guard let url = URL(string: apiUrl) else {
            print("URL no válida")
            return
        }

        // Realizar la solicitud GET usando URLSession
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Verificar si hubo un error
            if let error = error {
                print("Error de red: \(error)")
                return
            }

            // Asegurarse de que los datos existan
            guard let data = data else {
                print("No hay datos")
                return
            }

            // Imprimir los datos de la respuesta para ver el formato JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Respuesta JSON: \(jsonString)")
            }

            // Intentar decodificar los datos JSON
            do {
                let decoder = JSONDecoder()
                let quoteResponse = try decoder.decode([Quote].self, from: data)
                
                // Obtener la cita de la respuesta
                if let quote = quoteResponse.first?.quote {
                    // Actualizar la UI en el hilo principal
                    DispatchQueue.main.async {
                        self.labelQuotes.text = "\"\(quote)\""
                    }
                }

            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }.resume() // Iniciar la tarea
    }


    
    struct Quote: Codable {
        let quote: String
        let author: String
        
        enum CodingKeys: String, CodingKey {
            case quote = "q"
            case author = "a"
        }
    }

    
}








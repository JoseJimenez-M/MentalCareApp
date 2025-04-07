//
//  ViewController_Add.swift
//  TestAnalizer(JFL)
//
//  Created by english on 2025-04-01.
//
import UIKit

class ViewController_Add: UIViewController {
    
    //UITextView
    @IBOutlet weak var textViewText: UITextView!
    

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sentimentPickerView: UIPickerView!
    
    @IBOutlet weak var labelMessage: UILabel!
    
    // Configuración del PickerView
    let sentiments = ["Positive", "Neutral", "Negative"] // Ejemplo de sentimientos

    // Variables para almacenar datos
    var selectedSentiment: String = "Neutral"
    let userName: String = "Juan"  // Nombre fijo por defecto
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentimentPickerView.delegate = self
        sentimentPickerView.dataSource = self
        labelMessage.text = ""
        
        // Configuración del UITextView
        textViewText.frame = CGRect(x: 70, y: 300, width: 250, height: 200)
        textViewText.layer.borderColor = UIColor.lightGray.cgColor
        textViewText.layer.borderWidth = 1.0
        textViewText.layer.cornerRadius = 8.0
    }

    // Acción del botón que procesa los datos
    @IBAction func analyzeText(_ sender: UIButton) {
        print("analyzeText llamado") // Depuración: Asegúrate de que la acción se llama

        guard let textToAnalyze = textView.text, !textToAnalyze.isEmpty else {
            
            labelMessage.text = "Por favor ingresa un texto."
            return
        }
        
        // Realizar solicitud a TextRazor
        fetchTextRazorData(text: textToAnalyze) { topics in
            print("Respuesta de la API recibida: \(topics)") // Depuración: Verificar si llega la respuesta

            // Limitar a los primeros 10 temas
            let limitedTopics = Array(topics.prefix(10))
            
            // Obtener la fecha de hoy
            let currentDate = self.getCurrentDate()
            
            // Crear un diccionario con los datos para guardar en JSON
            let dataToSave: [String: Any] = [
                "userName": self.userName,
                "date": currentDate,
                "sentiment": self.selectedSentiment,
                "topics": limitedTopics
            ]
            
            // Convertir a JSON y guardar
            self.saveToJSON(data: dataToSave)
        }
        
        labelMessage.text = ""
        textView.text = "" // Limpiar el texto del textView
        sentimentPickerView.selectRow(1, inComponent: 0, animated: true) // Seleccionar el valor neutral
    }
    
    // Función para hacer la solicitud a TextRazor
    func fetchTextRazorData(text: String, completion: @escaping ([String]) -> Void) {
        let url = URL(string: "https://api.textrazor.com/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("YOUR API HERE", forHTTPHeaderField: "x-textrazor-key") // Reemplaza con tu API Key
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Datos del cuerpo de la solicitud
        let bodyString = "text=\(text)&extractors=topics"
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la solicitud: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    // Imprimir toda la respuesta de la API para depuración
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Respuesta completa de la API: \(jsonResponse)") // Imprimir toda la respuesta de la API
                        
                        // Intentar obtener los temas de la respuesta
                        if let response = jsonResponse["response"] as? [String: Any],
                           let topics = response["topics"] as? [[String: Any]] {
                            // Extraer los temas
                            let topicNames = topics.compactMap { $0["label"] as? String }
                            print("Temas extraídos: \(topicNames)") // Depuración: Verificar que los temas se están extrayendo
                            
                            // Usar el hilo principal para llamar al completion
                            DispatchQueue.main.async {
                                completion(topicNames)
                            }
                        } else {
                            print("No se encontraron temas en la respuesta.")
                            DispatchQueue.main.async {
                                completion([]) // Retorna un array vacío si no hay temas
                            }
                        }
                    }
                } catch {
                    print("Error al analizar la respuesta JSON: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    // Función para obtener la fecha actual
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    // Función para guardar los datos en un archivo JSON
    func saveToJSON(data: [String: Any]) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("user_data.json")
        
        print("Saving in: \(fileURL.path)") // Depuración: Verificar la ruta del archivo
        
        // Asegurarse de que las operaciones de escritura en el archivo también se realicen en el hilo principal
        DispatchQueue.main.async {
            do {
                var existingData: [[String: Any]] = []
                
                // Verificar si ya existe un archivo
                if let dataFromFile = try? Data(contentsOf: fileURL) {
                    existingData = try JSONSerialization.jsonObject(with: dataFromFile, options: []) as! [[String: Any]]
                }
                
                // Añadir los nuevos datos al archivo
                existingData.append(data)  // Añadir el nuevo conjunto de datos
                let jsonData = try JSONSerialization.data(withJSONObject: existingData, options: .prettyPrinted)
                
                // Guardar los datos en el archivo
                try jsonData.write(to: fileURL)
                print("Data saved: \(fileURL.path)") // Confirmación en consola
                self.showAlert(message: "Done!")
            } catch {
                print("JSON Error: \(error.localizedDescription)")
                self.showAlert(message: "Something wrong here.")
            }
        }
    }
    
    // Función para mostrar alertas
    func showAlert(message: String, title: String = "Notificación") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// Extensiones para el UIPickerView
extension ViewController_Add: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sentiments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSentiment = sentiments[row]
    }
    
    // Método para configurar los títulos de las filas
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sentiments[row]
    }

    // Método para configurar los atributos de cada fila
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white, // Color del texto (puedes cambiarlo)
            .font: UIFont.systemFont(ofSize: 18) // Tamaño de la fuente (puedes cambiarlo)
        ]
        
        let title = sentiments[row]
        return NSAttributedString(string: title, attributes: attributes)
    }
}


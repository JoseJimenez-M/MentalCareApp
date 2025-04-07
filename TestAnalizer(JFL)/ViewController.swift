//
//  ViewController.swift
//  TestAnalizer(JFL)
//
//  Created by english on 2025-04-01.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let users = [
        ("Jose", "123", 1),
        ("Test", "123", 0)
    ]
    
    
    @IBAction func buttonLogin(_ sender: UIButton) {
        // Not Empty...
           guard let username = usernameTextField.text, !username.isEmpty,
                 let password = passwordTextField.text, !password.isEmpty else {
               showAlert(message: "Please fill in both fields.")
               return
           }
           
           if let user = authenticate(username: username, password: password) {
               navigateToNextScreen(role: user.2, username: user.0) // Username
           } else {
               showAlert(message: "Invalid username or password.")
           }
    }
    
    // Función para autenticar al usuario con su nombre y contraseña
    func authenticate(username: String, password: String) -> (String, String, Int)? {
        // Buscar al usuario en la lista de usuarios predefinidos
        for user in users {
            if user.0 == username && user.1 == password {
                return user // Devuelve el usuario encontrado (username, password, role)
            }
        }
        return nil // Si no se encuentra el usuario, retorna nil
    }
    
    // Change Screen
    func navigateToNextScreen(role: Int, username: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Screen different per user
        if let newViewController = storyboard.instantiateViewController(withIdentifier: "StreakViewControllerID") as? StreakViewController {
            newViewController.userRole = role
            newViewController.username = username
            
            // Pss Username
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
        }
    }

    
    // Alerts only
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
    }
}

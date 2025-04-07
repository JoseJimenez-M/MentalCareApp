//
//  BreathingViewController.swift
//  TestAnalizer(JFL)
//
//  Created by english on 2025-04-03.
//

import UIKit
import ImageIO

class BreathingViewController: UIViewController {
   
    var imageView: UIImageView!

        override func viewDidLoad() {
            super.viewDidLoad()

            // Crear un UIImageView
            imageView = UIImageView(frame: CGRect(x: -150, y: 0, width: 700, height: 785))
            view.addSubview(imageView)

            // Cargar el GIF desde una URL
            let gifUrl = URL(string: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExcm50dWoyZzNmNTZqejYwb3Uza2xmZW45NXl6eTN0ZXB6eDluNGFueiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/7PK51oAq6EcUnrQYmW/giphy.gif")!

            // Descargar el GIF como Data
            if let gifData = try? Data(contentsOf: gifUrl) {
                // Llamar a la función que extrae las imágenes del GIF
                let images = gifImages(from: gifData)
                
                // Configurar el UIImageView con la animación del GIF
                imageView.animationImages = images
                imageView.animationDuration = 7.0
                imageView.animationRepeatCount = 0
                imageView.startAnimating()
            }
        }

        // Función para extraer las imágenes de un GIF
        func gifImages(from data: Data) -> [UIImage] {
            var images = [UIImage]()

            // Crear un objeto CGImageSource a partir de los datos
            if let source = CGImageSourceCreateWithData(data as CFData, nil) {
                let count = CGImageSourceGetCount(source)

                // Iterar sobre cada imagen del GIF y agregarlas al array
                for i in 0..<count {
                    if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                        images.append(UIImage(cgImage: cgImage))
                    }
                }
            }
            
            return images
        }
    }




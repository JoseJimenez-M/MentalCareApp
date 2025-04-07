//
//  SentimentChartViewController.swift
//  TestAnalizer(JFL)
//
//  Created by Marlot Leonardo Hernandez Felix on 06/04/25.
//

import UIKit

struct SentimentEntry {
    let date: String
    let value: Double
}

class SentimentChartViewController: UIViewController {

    @IBOutlet weak var chartView: MoodBarChartView!

        override func viewDidLoad() {
            super.viewDidLoad()

            let chartData = loadChartDataFromJSON()
                print("Loaded \(chartData.count) entries")
                chartView.setData(chartData)
        }

        func loadChartDataFromJSON() -> [SentimentEntry] {
            guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }

            let fileURL = documentsURL.appendingPathComponent("user_data.json")
            do {
                let data = try Data(contentsOf: fileURL)
                let jsonObjects = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []

                var results: [SentimentEntry] = []

                for obj in jsonObjects {
                    if let sentiment = obj["sentiment"] as? String,
                       let date = obj["date"] as? String {
                        let value: Double
                        switch sentiment.lowercased() {
                        case "positive": value = 1
                        case "neutral": value = 0
                        case "negative": value = -1
                        default: continue
                        }
                        results.append(SentimentEntry(date: date, value: value))
                    }
                }

                return results

            } catch {
                print("Error loading JSON: \(error)")
                return []
            }
        }

}

class MoodBarChartView: UIView {
    var data: [SentimentEntry] = []

    // Método de dibujo
    override func draw(_ rect: CGRect) {
        guard !data.isEmpty else { return }

        let context = UIGraphicsGetCurrentContext()
        let barWidth: CGFloat = rect.width / CGFloat(data.count)
        let centerY = rect.height / 2

        // Limpia las etiquetas de fecha anteriores
        self.subviews.forEach { if $0 is UILabel { $0.removeFromSuperview() } }

        // Dibuja las barras
        for (index, entry) in data.enumerated() {
            let x = CGFloat(index) * barWidth
            let barHeight = CGFloat(entry.value) * (rect.height / 2)

            let barRect: CGRect
            // Cambiar el color según el sentimiento
            if entry.value > 0 {
                barRect = CGRect(x: x, y: centerY - barHeight, width: barWidth * 0.8, height: barHeight)
                context?.setFillColor(UIColor.systemGreen.cgColor) // Verde para positivo
            } else if entry.value < 0 {
                barRect = CGRect(x: x, y: centerY, width: barWidth * 0.8, height: abs(barHeight))
                context?.setFillColor(UIColor.systemRed.cgColor) // Rojo para negativo
            } else {
                barRect = CGRect(x: x, y: centerY, width: barWidth * 0.8, height: barHeight)
                context?.setFillColor(UIColor.systemGray.cgColor) // Gris para neutral
            }

            context?.fill(barRect)

            let dateLabel = UILabel(frame: CGRect(x: x, y: rect.height - 20, width: barWidth, height: 20))
            dateLabel.text = entry.date
            dateLabel.font = .systemFont(ofSize: 10)
            dateLabel.textAlignment = .center
            dateLabel.textColor = .label
            self.addSubview(dateLabel)
        }
    }

    func setData(_ newData: [SentimentEntry]) {
        self.data = newData
        setNeedsDisplay()
    }
}

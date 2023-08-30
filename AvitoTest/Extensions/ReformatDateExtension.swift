
import Foundation

extension String {
    /**
     Function to convert Date into preselected format d-MMMM
     
    - Parameter: takes self
    - Returns: Date converted to d-MMMM
    - Note: if Date comes with nil returns empty string
     */
    func reformatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: self) else {
            return ""
        }

        let day = DateFormatter()
        day.dateFormat = "d"
        let formattedDay = day.string(from: date)
        
        let mounth = DateFormatter()
        mounth.locale = Locale(identifier: "ru_RU")
        mounth.dateFormat = "MMMM"
        var formattedMounth = mounth.string(from: date)
        formattedMounth = formattedMounth.prefix(1).capitalized + formattedMounth.dropFirst()
        
        let formattedDate = "\(formattedDay) \(formattedMounth)"
        return formattedDate
    }
}

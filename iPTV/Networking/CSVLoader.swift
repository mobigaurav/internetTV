import Foundation

class CSVLoader {
//    private var allChannels: [Channel] = []
//    private let pageSize = 50  // Number of items to load per page
//    
//    init() {
//        loadCSV()
//    }
//
//    private func loadCSV() {
//        guard let filepath = Bundle.main.path(forResource: "channels", ofType: "csv") else { return }
//        do {
//            let contents = try String(contentsOfFile: filepath)
//            let rows = contents.components(separatedBy: .newlines)
//            for row in rows.dropFirst() {  // Skip the header row
//                let columns = row.components(separatedBy: ",")
//                if columns.count > 16 {  // Adjusted based on number of fields
//                    let id = columns[0]
//                    let name = columns[1]
//                    let altNames = columns[2].isEmpty ? nil : columns[2].components(separatedBy: ";")
//                    let network = columns[3].isEmpty ? nil : columns[3]
//                    let owners = columns[4].isEmpty ? nil : columns[4].components(separatedBy: ";")
//                    let country = columns[5].isEmpty ? nil : columns[5]
//                    let subdivision = columns[6].isEmpty ? nil : columns[6]
//                    let city = columns[7].isEmpty ? nil : columns[7]
//                    let broadcastArea = columns[8].isEmpty ? nil : columns[8].components(separatedBy: ";")
//                    let languages = columns[9].isEmpty ? nil : columns[9].components(separatedBy: ";")
//                    let categories = columns[10].components(separatedBy: ";")
//                    let isNsfw = columns[11].lowercased() == "true"
//                    let launched = columns[12].isEmpty ? nil : columns[12]
//                    let closed = columns[13].isEmpty ? nil : columns[13]
//                    let replacedBy = columns[14].isEmpty ? nil : columns[14]
//                    let website = URL(string: columns[15])
//                    let logoURL = URL(string: columns[16])
//                    
//                    let channel = Channel(
//                        id: id,
//                        name: name,
//                        altNames: altNames,
//                        network: network,
//                        owners: owners,
//                        country: country,
//                        subdivision: subdivision,
//                        city: city,
//                        broadcastArea: broadcastArea,
//                        languages: languages,
//                        categories: categories,
//                        isNsfw: isNsfw,
//                        launched: launched,
//                        closed: closed,
//                        replacedBy: replacedBy,
//                        website: website,
//                        logoURL: logoURL
//                    )
//                    allChannels.append(channel)
//                }
//            }
//        } catch {
//            print("Error loading CSV: \(error)")
//        }
//    }
//
//    func loadPage(_ page: Int) -> [Channel] {
//        let start = page * pageSize
//        let end = min(start + pageSize, allChannels.count)
//        return Array(allChannels[start..<end])
//    }
}


//
//  FilterOptionsView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/30/24.
//

import SwiftUI

struct FilterOptionsView: View {
    @ObservedObject var viewModel: ChannelViewModel

    var body: some View {
        VStack {
            HStack {
                FilterPicker(title:"Language", selection: $viewModel.selectedLanguage, options: getLanguages())
                FilterPicker(title:"Country", selection: $viewModel.selectedCountry, options: getCountries())
            }
//            HStack {
//                FilterPicker(title:"Region", selection: $viewModel.selectedRegion, options: getRegions())
//                FilterPicker(title:"Subdivision", selection: $viewModel.selectedSubdivision, options: getSubdivisions())
//            }
        }
    }

    // Mock data functions (replace with API calls or cached data)
    private func getLanguages() -> [String] {
        return viewModel.language.map { $0.name }
       }
    private func getCountries() -> [String] {
        return viewModel.country.map { $0.name }
    }
    private func getRegions() -> [String] { ["North America", "Europe"] }
    private func getSubdivisions() -> [String] { ["California", "Ontario", "Île-de-France"] }
}

// Generic FilterPicker view
struct FilterPicker: View {
    let title: String
    @Binding var selection: String?
    let options: [String]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Picker(title, selection: $selection) {
                Text("All").tag(String?.none)
                ForEach(options, id: \.self) { option in
                    Text(option).tag(String?.some(option))
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray5))
            .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
}


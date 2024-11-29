//
//  LogExerciseView.swift
//  Nutrify
//
//  Created by Michelle Chan on 27/11/2024.
//

import SwiftUI

struct ExerciseLogView: View {
    @State private var searchText = ""
    @State private var duration: String = ""
    @State private var exerciseResults: [ExerciseItem] = []
    @State private var selectedExercises: [ExerciseItem] = []
    @EnvironmentObject var todayRecordViewModel: TodayRecordViewModel
    @Environment(\.managedObjectContext) private var context

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    TextField("Enter exercise type (e.g., running)", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 10)
                    
                    TextField("Duration (mins)", text: $duration)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 120)
                    
                    Button(action: fetchExerciseData) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                // Exercise List
                List(exerciseResults) { item in
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text("Calories Burned (per hour): \(String(format: "%.1f", item.calories)) kcal")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            addExerciseToSelection(item)
                        }) {
                            HStack {
                                Spacer()
                                Text("Add")
                                    .foregroundColor(.blue)
                                    .padding(.vertical, 5)
                                    .frame(maxWidth: .infinity)
                                Spacer()
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding(.vertical, 5)
                }
                
                // Add to Log Button
                if !selectedExercises.isEmpty {
                    Button(action: {
                        addSelectedExercisesToTodayRecord()
                    }) {
                        HStack {
                            Spacer()
                            Text("Add to Log (\(selectedExercises.count))")
                                .foregroundColor(.white)
                                .padding()
                            Spacer()
                        }
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Exercise Log")
        }
    }
    
    // Fetch exercise data from API Ninja's Calories Burned API
    func fetchExerciseData() {
        guard let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let durationValue = Double(duration),
              let url = URL(string: "https://calories-burned-by-api-ninjas.p.rapidapi.com/v1/caloriesburned?activity=\(encodedSearchText)&duration=\(durationValue)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("c6c06fc045msh6c2a670ca1a774ap1ded29jsn717a24e71a6e", forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("calories-burned-by-api-ninjas.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(String(describing: error))")
                return
            }
            
            do {
                let results = try JSONDecoder().decode([ExerciseItem].self, from: data)
                DispatchQueue.main.async {
                    self.exerciseResults = results
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
    
    // Add exercise item to the selected list
    func addExerciseToSelection(_ item: ExerciseItem) {
        if !selectedExercises.contains(where: { $0.id == item.id }) {
            selectedExercises.append(item)
        }
    }
    
    // Add selected exercises' data to today's Core Data record
    func addSelectedExercisesToTodayRecord() {
        guard let todayRecord = todayRecordViewModel.todayRecord else { return }
        
        let totalCaloriesBurned = selectedExercises.reduce(0.0) { result, item in
            result + (item.calories / 60 * (Double(duration) ?? 0)) // Calculate per-minute burn
        }
        
        todayRecord.exerciseCalories += totalCaloriesBurned
        
        do {
            try context.save() // Save Core Data changes
            selectedExercises.removeAll() // Clear selected items
        } catch {
            print("Failed to save today's record: \(error)")
        }
    }
}

//Exercise Item Model
struct ExerciseItem: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let calories: Double

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case calories = "calories_per_hour"
    }
}

// MARK: - Preview
//struct ExerciseLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        let todayRecordViewModel = TodayRecordViewModel(context: PersistenceController.shared.container.viewContext)
//        return ExerciseLogView()
//            .environmentObject(todayRecordViewModel)
//    }
//}

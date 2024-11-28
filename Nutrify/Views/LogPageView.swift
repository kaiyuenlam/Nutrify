// API Constants
let edamamAppID = "802ee5c3"
let edamamAppKey = "f02c953327da7b5f8554ad17b65b92ba"
import SwiftUI

struct LogPageView: View {
    @ObservedObject var nutritionData: NutritionDataModel
    @State private var searchText = ""
    @State private var foodItems: [FoodItem] = []
    @State private var selectedItems: [FoodItem] = []

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    TextField("What did you eat?", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 10)
                    
                    Button(action: fetchFoodData) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                // Food List
                List(foodItems) { item in
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Calories:")
                                Spacer()
                                Text("\(String(format: "%.1f", Double(item.calories))) kcal")
                            }
                            HStack {
                                Text("Fat:")
                                Spacer()
                                Text("\(String(format: "%.1f", item.fat)) g")
                            }
                            HStack {
                                Text("Protein:")
                                Spacer()
                                Text("\(String(format: "%.1f", item.protein)) g")
                            }
                            HStack {
                                Text("Carbs:")
                                Spacer()
                                Text("\(String(format: "%.1f", item.carbs)) g")
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                        
                        Button(action: {
                            addItemToSelection(item)
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
                
                // Add to meal Button
                if !selectedItems.isEmpty {
                    Button(action: {
                        addSelectedItemsToNutritionData()
                    }) {
                        HStack {
                            Spacer()
                            Text("Add to Breakfast (\(selectedItems.count))")
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
            .navigationTitle("Add Meal")
        }
    }
    
    // Fetch food data from Edamam API
    func fetchFoodData() {
        guard let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.edamam.com/api/nutrition-data?app_id=\(edamamAppID)&app_key=\(edamamAppKey)&ingr=\(encodedSearchText)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(NutritionDataResponse.self, from: data)
                DispatchQueue.main.async {
                    // Create a food item based on the response
                    let foodItem = FoodItem(
                        name: searchText,
                        calories: Int(result.calories),
                        fat: result.totalNutrients.FAT?.quantity ?? 0.0,
                        protein: result.totalNutrients.PROCNT?.quantity ?? 0.0,
                        carbs: result.totalNutrients.CHOCDF?.quantity ?? 0.0
                    )
                    self.foodItems = [foodItem] // Single item as API returns one at a time
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
    
    // Add food item to the selected list
    func addItemToSelection(_ item: FoodItem) {
        if !selectedItems.contains(where: { $0.id == item.id }) {
            selectedItems.append(item)
        }
    }
    
    // Add selected items' data to the NutritionDataModel
    func addSelectedItemsToNutritionData() {
        for item in selectedItems {
            nutritionData.calorieIntake += item.calories
            nutritionData.fatPercentage += item.fat
            nutritionData.proteinPercentage += item.protein
            nutritionData.carbPercentage += item.carbs
        }
        selectedItems.removeAll()
    }
}

// MARK: - Food Item Model
struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let fat: Double
    let protein: Double
    let carbs: Double
}

// MARK: - API Response Models
struct NutritionDataResponse: Decodable {
    let calories: Double
    let totalNutrients: TotalNutrients
}

struct TotalNutrients: Decodable {
    let FAT: Nutrient?
    let PROCNT: Nutrient?
    let CHOCDF: Nutrient?
}

struct Nutrient: Decodable {
    let label: String
    let quantity: Double
    let unit: String
}

//// MARK: - Preview
//struct LogPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogPageView(nutritionData: NutritionDataModel())
//    }
//}

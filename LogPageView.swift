// API Constants
let edamamAppID = "802ee5c3"
let edamamAppKey = "f02c953327da7b5f8554ad17b65b92ba"
/*
import SwiftUI

struct LogPageView: View {
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
                
                // Tab Selector (Foods, Favorites, Dishes)
                HStack {
                    Text("Foods")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 20)
                    Spacer()
                }
                .padding(.bottom, 10)
                
                // Food List
                List(foodItems) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("\(item.calories) kcal")
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            addItemToSelection(item)
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                // Add to Breakfast Button
                if !selectedItems.isEmpty {
                    Button(action: {
                        // Action to add selected items
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
            .navigationTitle("Breakfast")
        }
    }
    
    // Fetch food data from Edamam API
    func fetchFoodData() {
        guard let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.edamam.com/api/nutrition-data?app_id=\(edamamAppID)&app_key=\(edamamAppKey)&ingr=\(encodedSearchText)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(NutritionData.self, from: data)
                DispatchQueue.main.async {
                    // Create a food item based on the response
                    let foodItem = FoodItem(name: searchText, calories: Int(result.calories))
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
}

// Food Item Model
struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
}

// API Response Models
struct NutritionData: Decodable {
    let calories: Double
}

// Preview
struct LogPageView_Previews: PreviewProvider {
    static var previews: some View {
        LogPageView()
    }
}
*/
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
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("\(item.calories) kcal")
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            addItemToSelection(item)
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                // Add to Breakfast Button
                if !selectedItems.isEmpty {
                    Button(action: {
                        addCaloriesToIntake()
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
            .navigationTitle("Breakfast")
        }
    }
    
    // Fetch food data from Edamam API
    func fetchFoodData() {
        guard let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.edamam.com/api/nutrition-data?app_id=\(edamamAppID)&app_key=\(edamamAppKey)&ingr=\(encodedSearchText)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(NutritionData.self, from: data)
                DispatchQueue.main.async {
                    // Create a food item based on the response
                    let foodItem = FoodItem(name: searchText, calories: Int(result.calories))
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
    
    // Add calorie intake from selected items
    func addCaloriesToIntake() {
        let totalCalories = selectedItems.reduce(0) { $0 + $1.calories }
        nutritionData.calorieIntake += totalCalories
        selectedItems.removeAll()
    }
}

// Food Item Model
struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
}

// API Response Models
struct NutritionData: Decodable {
    let calories: Double
}


// Preview
struct LogPageView_Previews: PreviewProvider {
    static var previews: some View {
        LogPageView(nutritionData: NutritionDataModel())
    }
}

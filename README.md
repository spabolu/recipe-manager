# Recipe Manager

A SwiftUI-based iOS app for managing and organizing your favorite recipes.

## Features

- **Recipe Storage**: Save recipes with ingredients, directions, and serving information
- **Recipe Browsing**: View all your recipes in an organized list
- **Detailed View**: See complete recipe information including ingredients and step-by-step directions
- **Shopping List**: Generate shopping lists from your recipes
- **Core Data Integration**: Persistent local storage for all your recipes

## Screenshots

The app includes:
- Welcome screen with app branding
- Recipe list view showing all saved recipes
- Add recipe form with fields for name, servings, ingredients, and directions
- Detailed recipe view for viewing complete recipe information
- Shopping list functionality

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.0+

## Installation

1. Clone this repository
2. Open `recipe-manager.xcodeproj` in Xcode
3. Build and run the project on your iOS device or simulator

## Project Structure

- `recipe_managerApp.swift` - Main app entry point
- `ContentView.swift` - Welcome screen and navigation
- `RecipeListView.swift` - Main recipe list interface
- `AddRecipe.swift` - Form for adding new recipes
- `RecipeDetailedView.swift` - Detailed recipe view
- `ShoppingList.swift` - Shopping list functionality
- `MapView.swift` - Map integration features
- `Persistence.swift` - Core Data stack and sample data
- `recipe_manager.xcdatamodeld/` - Core Data model

## Core Data Model

The app uses Core Data for persistent storage with a `Recipe` entity containing:
- Name
- Ingredients
- Directions
- Servings
- Timestamp
- Unique ID

## Sample Data

The app includes sample recipes for testing:
- Grilled Cheese
- Oatmeal
- Green Smoothie
- Greek Salad
- Spaghetti Carbonara
- Chocolate Pancakes

## Author

Created by Saketh Pabolu
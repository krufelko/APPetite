# APPetite

APPetite is an iOS application that provides users with a curated selection of cooking recipes. By integrating the MealDB API and the Gemini API, APPetite offers a seamless experience for discovering and simplifying culinary instructions.

Features

	•	Recipe Discovery: Browse a diverse collection of recipes sourced from the MealDB API.
	•	Instruction Simplification: Utilize the Gemini API to convert complex cooking instructions into clear, concise steps.
	•	User-Friendly Interface: Navigate through recipes with an intuitive and responsive design.

Installation

	1.	git clone https://github.com/krufelko/APPetite.git
 

	2.	cd APPetite
 
 
 	3.	open APPetite.xcodeproj
  
 
 	4.	Install Package Dependencies: generative-ai-swift 
  

	5.	Build and Run: Select the appropriate simulator or device, then build and run the project in Xcode.

Usage

	1.	Launch the App: Open APPetite on your iOS device or simulator.
	2.	Explore Recipes: Browse through the list of available recipes.
	3.	View Details: Tap on a recipe to see detailed information, including ingredients and instructions.
	4.	Simplify Instructions: Use the “Let’s Cook” button to simplify complex instructions via the Gemini API. The problem we are solving is that recipes are often overwhelming for beginners and 	if its your first time cooking a recipe so we've enabled you to complete the recipe while keeping the instructions simple.

API Integration

	•	MealDB API: Provides a vast collection of meal recipes.
	•	Gemini API: Simplifies detailed instructions into easy-to-follow steps.

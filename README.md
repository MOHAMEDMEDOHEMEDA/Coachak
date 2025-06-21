# Coashak 🏋️‍♂️🥗

**Coashak** is an all-in-one Fitness & Nutrition mobile application designed for personal trainers and their clients. This app bridges the gap between tailored fitness coaching and smart nutrition planning, empowered by AI-based recommendations and real-time progress tracking.

## 📱 Features

### 🔹 For Trainers
- Create customized training and nutrition plans
- Assign daily workouts and meals for each client
- Manage client profiles, track progress, and update plans dynamically
- Receive AI-powered suggestions for workouts and meals

### 🔹 For Trainees
- Access daily training and nutrition plans
- View meal recommendations with detailed macros
- Track workout completion and meal intake
- Chat with an AI Assistant for instant fitness & nutrition guidance

### 🔹 General Features
- Authentication & Onboarding flow
- Modern, intuitive UI built with SwiftUI
- MVVM architecture for clean and scalable code
- Real-time updates after adding/editing/deleting meals or workouts
- Smooth navigation with sheets and detail views

## 🛠️ Tech Stack

| Layer              | Technology                     |
|-------------------|-------------------------------|
| **Frontend**       | SwiftUI (iOS)                |
| **Architecture**   | MVVM                         |
| **Networking**     | URLSession / Combine         |
| **Backend (API)**  | Node.js / Express            |
| **AI Assistant**   | OpenAI Chat API              |
| **Database**       | MongoDB / Firebase           |

## 📂 Project Structure

```
Coashak/
│
├── Models/             # Data models (Workout, Exercise, Meal, etc.)
├── ViewModels/         # Business logic and API handling
├── Views/              # SwiftUI screens and components
├── Resources/          # Assets, Fonts, Colors
├── Networking/         # API services
└── Utilities/          # Helpers and Extensions
```

## 💡 Key Architectural Decisions

- **MVVM Pattern** for separation of concerns
- **SwiftUI Sheets & State Management** for dynamic data updates
- **Asynchronous Data Fetching** using @Published, @StateObject, and Combine

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0 or later
- Swift 5.7 or later

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/coashak.git
   cd coashak
   ```

2. **Open the project in Xcode:**
   ```bash
   open Coashak.xcodeproj
   ```

3. **Run the app on a simulator or a real iOS device**

## 🎨 Screenshots

*(Coming Soon)*

## 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 👥 Contributors

- **Mohamed Magdy** - *IOS Developer*
- yousef ayman
- hady hassan
- mohamed khaled
- rawan shawky
- rwana khaled
- mohamed mostafa
- assem morsy


## 🙌 Acknowledgements

- Google Gemini for AI Assistant Integration
- SwiftUI Community for design inspiration
- All mentors, instructors, and reviewers for their valuable guidance!

## 📧 Contact

Mohamed Magdy - [mohamed20034494@gmail.com]

Project Link: [https://github.com/MOHAMEDMEDOHEMEDA/Coachak](https://github.com/MOHAMEDMEDOHEMEDA/Coachak)

---

⭐ If you found this project helpful, please give it a star!

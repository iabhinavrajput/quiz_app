# Quiz App

Welcome to the **Quiz App**! This app allows users to take quizzes, sign in with Google, track their progress, and more.

## Features

- Google Sign-In for authentication
- Dynamic quizzes using the **GROQ API**
- Timer for each quiz question
- Firebase integration for user data and score tracking
- Stylish UI with gradients and animations

## Installation

### Prerequisites

1. Ensure you have Flutter installed on your system. If not, follow the [installation guide](https://flutter.dev/docs/get-started/install).
2. Set up Firebase for your project by following the [Firebase Flutter setup guide](https://firebase.flutter.dev/docs/overview).

### Clone the repository

```bash
git clone https://github.com/iabhinavrajput/quiz_app
cd quiz_app
```

## Install dependencies

```bash
flutter pub get
```

### Set up the `.env` file

1. Create a `.env` file in the root directory of your project.
2. Add your API base URL and API key:

```env
BASE_URL=https://api.groq.com/openai/v1/chat/completions
API_KEY=your_api_key_here


This will render as:

### Set up the `.env` file

1. Create a `.env` file in the root directory of your project.
2. Add your API base URL and API key:

```env
BASE_URL=https://api.groq.com/openai/v1/chat/completions
API_KEY=your_api_key_here
```

### Run the app

For Android:

```bash
flutter run --target-platform android

```
For Ios:
```bash
flutter run --target-platform ios
```


# Quiz App

## How to Use

1.  Launch the app on your device.
    
2.  Sign in using Google.
    
3.  Once logged in, you can start taking quizzes.
    
4.  Your quiz score and answers will be saved to Firebase for future reference.

## Technologies Used

*   **Flutter**: A UI toolkit to build natively compiled applications for mobile.
    
*   **Firebase**: For user authentication and data storage.
    
*   **GROQ API**: For dynamically generating quiz questions.

## Contributing

If you'd like to contribute to the development of this app, please follow these steps:

1.  Fork the repository.
    
2.  Create a new branch.
    
3.  Make your changes and submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

*   **Developer**: Abhinav Rajput
    
*   **GitHub**: [iabhinavrajput](https://github.com/iabhinavrajput)
    
*   **LinkedIn**: [iabhinavrajput](https://linkedin.com/in/iabhinavrajput)
    
*   **Portfolio**: [abhinavrajput.xyz](https://abhinavrajput.xyz/)


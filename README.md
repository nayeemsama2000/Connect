# Connect 📱💬

A real-time chat and calling application built with **Flutter** and
**Node.js**, designed for smooth messaging, instant search, and
high-quality audio/video calls using **Agora**.\
This project demonstrates scalable backend integration, real-time
communication, and modern mobile app UI/UX --- perfect for showcasing as
a portfolio project.

------------------------------------------------------------------------

## 🚀 Features

-   **Splash Screen** → Clean animated entry point.\
-   **Login** → Simple one-field login (enter your name, start
    chatting).\
-   **User List with Search** → See all users, search instantly by
    name.\
-   **Real-time Chat** →
    -   One-to-one messaging with **Socket.IO**.\
    -   Messages stored in **MongoDB**.\
    -   Chat auto-scrolls to bottom on open & new message.\
-   **Voice/Video Calling** →
    -   Built with **Agora SDK**.\
    -   Real-time connection, auto role handling.\
-   **Backend APIs** →
    -   RESTful endpoints with **Express.js**.\
    -   Secure real-time communication with **Socket.IO**.\
-   **Ngrok Support** → Test the app from any physical device with
    automatic tunnel URLs.

------------------------------------------------------------------------

## 🛠️ Tech Stack

### Frontend (Mobile)

-   **Flutter (Dart)** → UI and app logic.\
-   **Provider/State Management** → For handling real-time data
    updates.\
-   **Agora Flutter SDK** → High-quality real-time calling.

### Backend

-   **Node.js + Express.js** → REST APIs & Socket server.\
-   **MongoDB (Mongoose)** → Database for users & messages.\
-   **Socket.IO** → Real-time chat communication.\
-   **Ngrok** → For external API/call testing.

------------------------------------------------------------------------

## ⚙️ Setup Instructions

### 1. Backend (Node.js)

``` bash
# Clone repo & install dependencies
npm install

# Start server
node index.js
```

### 2. Ngrok (for external devices)

``` bash
ngrok http 5000
```

-   Copy the generated **public URL**.\
-   Replace `BASE_URL` in Flutter with Ngrok URL.

### 3. Flutter App

``` bash
# Install dependencies
flutter pub get

# Run app
flutter run
```

------------------------------------------------------------------------

## 📂 Project Structure

    connect/
     ├── backend/          # Node.js + Express + Socket.IO
     ├── lib/              # Flutter app source code
     │    ├── screens/     # Splash, Login, ChatList, ChatPage, CallPage
     │    ├── services/    # API, Socket, Agora helpers
     │    └── widgets/     # Reusable UI components
     └── README.md

------------------------------------------------------------------------

## 🎯 Learning Outcomes

-   Building **full-stack apps** with Flutter + Node.js.\
-   Integrating **real-time sockets** for messaging.\
-   Implementing **Agora** for calls.\
-   Using **Ngrok** for global device testing.\
-   Clean **project structuring** for portfolio readiness.

------------------------------------------------------------------------

## 🌟 Portfolio Highlight

This project can be proudly shown as:\
✔️ **Full-stack mobile app** with backend & database.\
✔️ **Real-time chat + call functionality**.\
✔️ **Production-ready scalable architecture**.

------------------------------------------------------------------------

## 📸 Screenshots

-   Splash Screen\
-   Login Screen\
-   User List with Search\
-   Chat Screen (real-time messaging)\
-   Call Screen (Agora integration)

------------------------------------------------------------------------

## 👨‍💻 Author

Built with ❤️ by \[Your Name\]

------------------------------------------------------------------------

## 📜 License

This project is open-source under the MIT License.

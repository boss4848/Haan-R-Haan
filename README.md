# Haan-R-Haan
Haan R Haan is a mobile application that allows users to create parties and split bills together. The app helps users efficiently manage their expenses during group outings, parties, or any shared activities.

## Dependencies
The following dependencies are required to build and run the Haan R Haan app:
- animated_text_kit
- cloud_firestore
- cool_alert
- cupertino_icons
- firebase_auth
- firebase_core
- flutter
- flutter_local_notifications
- flutter_svg
- intl
- promptpay_qrcode_generate
- provider
- qr_code_scanner
- timeago

## Folder Structure
The Haan R Haan app follows the *MVVM (Model-View-ViewModel) architecture* for its folder structure. Here's an overview of the important directories and files:
- */lib*
    - */lib/constant*: Contains constant values for used in the app.
    - */lib/src*: Containers the Dart code for the app.
        - */lib/src/models*: Contains the data models used in the app.
        - */lib/src/pages*: Contains screens for the app.
        - */lib/src/services*: Contains services for interacting with Firebase.
        - */lib/src/utils*: Contains utility functions.
        - */lib/src/viewmodels*: Contains the view models that handle the business logic for the app.
        - */lib/src/widgets*: Contains the common widgets.
        - */lib/src/app.dart*: App.
    - */lib/main.dart*: The entry point of the app. 

## Getting Started
To get started with the Haan R Haan app, follow these steps:
- Download and unzip the zip file source code or clone the Haan R Haan repository: git clone `https://github.com/boss4848/haan-r-haan.git`

### Prerequisites
Before running the app, make sure you have the following installed:
- Flutter SDK version 3.7.0-0 or higher.
- Dart SDK version 2.19.3 or higher.

### Running the App
Once you have the prerequisites set up, you can run the app:
1. Open a terminal or command prompt and navigate to the project directory.
2. Run the following command to install the app's dependencies:
```
flutter pub get
```
3. Run the app on a simulator or connected device using the following 
```
flutter run
```
This command will build and launch the app on the selected device.

### Screens Example
![StarterPage](https://raw.githubusercontent.com/boss4848/Haan-R-Haan/main/Starter%20Page.png)
![AuthPage](https://raw.githubusercontent.com/boss4848/Haan-R-Haan/main/Create%20Account%20Page.png)
![MainPage](https://raw.githubusercontent.com/boss4848/Haan-R-Haan/main/Main%20BG.png)
![DetailPage](https://raw.githubusercontent.com/boss4848/Haan-R-Haan/main/Detail%20Page%20(member).png)






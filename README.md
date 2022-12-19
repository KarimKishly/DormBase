# DormBase

DormBase is a mobile application made for LAU Byblos students to conveniently find a dorm that will fit their needs.

## Getting Started

This project is made using the Flutter framework, hence you will need to install Flutter and add it to your path before being able to debug this code. You can find more info about installing Flutter as well as the download links from the [Flutter website](https://flutter.dev/).

It is also required to [download Android Studio](https://developer.android.com/studio) to run this code since it was the IDE used for this project. Android Studio is also conveient in this case since it includes an android emulator. The version used for testing the app was Nexus 6 with the Android Pi version (28). After this process, download the zip of this repository and extract it in any directory, then open the project from Android Studio.

The final step to the installation process is getting XAMPP since it the application used to run the MySQL server needed to run this app. You can do so by going to the [XAMPP website](https://www.apachefriends.org/download.html), downloading and intalling it from there. After the installation is done, you have to start the Apache server and the MySQL server from the XAMPP application by clicking on the "Start" button next to each of these modules.

 ## Importing the Database and PHP scripts

After running the PHPMyAdmin server you have to import the current database we have since its file is separate from the project files. You can do so by clicking on the "Admin" button next to the MySQL module from the XAMPP Control Panel, creating an empty database called "dormbase" with default settings. Finally, click on "dormbase" on the left sidebar, going into the import tab, and selecting the `dormbase.sql` file in the project folder after extracting the `xampp.zip` file. You then have to click "Go" to run the import.

After this step you need to import the used PHP scripts since they are vital for running the app. You can do so by copying the `dormbase_api` folder found in the previously extracted `xampp.zip` into the `htdocs` folder inside the `xampp` folder located where you chose to install the XAMPP Control Panel.

 ## Running the App

 The final step you have to do before the app is running is changing the IP in the Flutter files to the one used while hosting PHPMyAdmin on your machine. This can be done by going into CMD, typing `ipconfig`, getting the result of the `IPv4 Address` and updating the `host` value of the ROOT Uri in the `lib/sqlconn/Services.dart` file. After doing this, you can finally run your Android emulator by clicking on the `<no device selected>` tab on the top of Android Studio and clicking `Open Android Emulator`. This should launch Android on your device in a small tab on the side. After the launch is complete you can click the run button on the top right which should run the application. The first launch might take a while since Android Studio is downloading and installing the Gradle dependencies.

 You should now be able to freely use DormBase and explore its features.

 ## Troubleshooting

 In case there are problems with running the app, it could be due to Android Studio running the wrong `main.dart` file. To fix this go the main `lib` directory, and right-click on the `main.dart` file and click on `run 'main.dart'`.

 Another problem might be exprienced due to not having the proper dependencies on the user's machine. This can be easily fixed by going into the `pubspec.yaml` file in the main directory. From there go into the `dependencies` subsection, and adding `mysql1: ^0.20.0` under `photo_view: ^0.14.0`. Then save the file with `CTRL+S` and switch to a different tab. A warning should appear telling you that dependencies were changed. From there, click on `get dependencies` and it should update the files, installing any packages that are needed. The mysql1 package is simply a dummy one used here since it would alert Flutter to update the depencies which might not exist on the user's machine, but Flutter overlooked since the complete project is imported directly.
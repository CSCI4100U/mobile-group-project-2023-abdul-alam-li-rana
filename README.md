# CSCI4100 Group Project

[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/Ejc5gqh5)

## Group Members (3-5) (No Student IDs, Only Names and GitHub Usernames):

1. Justin Li ([Ju5t1nLi](https://github.com/Ju5t1nLi))
2. Ahad Abdul - MIA
3. Taha Rana
4. Rhythm Alam

## Mid Course Check-in User Guide

### Step 1: Initialization

- Ensure you have run `flutter pub get` to get all dependencies for the prototype.
- Ensure you accept all permission requests once in the app or else some features may be disabled.

#### Using an Emulator:

- Launch device emulator.
- Run the application.

#### Using a Physical Device (Android Only):

- Deploy the app to a physical device.
- Open the app.

### Step 2: Login Page

- Once you open the app, you will be greeted with a login page.
  - Type your full name, a valid email address, and password to sign up for an account.
    
  <img src="readme_images/signup.png" alt="Signup" width="250">
  
  - Once entered, press the 'Sign Up' button.
  - Alternatively, you can press the 'Login' button if you already have an existing account created.
    
  <img src="readme_images/login.png" alt="Login" width="250">

- You will be sent to an email verification screen. Please check your given email address for a verification email to verify your account.
  
  <img src="readme_images/verify.png" alt="Verification" width="250">

  - A group member encountered a bug in their emulator where the app would crash when heading to the email verification page (others did not have any issues). The email will still send, however. If this occurs, please close the app and re-run the app. It should bring you back to the verification screen with no issues. If the screen still freezes, verify your email, then run the app again. You will be sent to the homepage.
- Once verified, press the 'Check Verification' button to authenticate into the app.
  - If needed, you can press the 'Resend' button to send another email. **Note:** Whenever you enter the verification screen, you will be sent another verification email to authenticate.

### Step 3: The Homepage

- Once authenticated, you will be greeted with the app homepage.
  
  <img src="readme_images/homepage.png" alt="Home" width="250">

  - Once authenticated, your email is added to a local SQLite database to confirm registration.
  - The homepage consists of four different buttons (Vehicles, Trip, Service, Help).
    - See below for the functionality of each page.
  - There is a sign-out button in the top-right corner of the appbar should you want to log out of the app.
  - There is a menu icon at the top-left corner of the appbar. Pressing this reveals a sidebar with your profile details.
    
  <img src="readme_images/homepage_sidebar.png" alt="Home Sidebar" width="250">

  - There is an avatar you can press to change your profile picture (using your camera roll or the camera itself).
  - This profile picture will be saved locally with your account.

### Homepage buttons: Vehicles

- The Vehicles tab allows the user to add any of their vehicles into a list.
  
  <img src="readme_images/vehicle_homepage.png" alt="vehicle" width="250">

  - There is a menu icon in the top-left corner of the appbar; this will open a sidebar that allows navigation to other pages in the app.
    
  <img src="readme_images/sidebar.png" alt="menu" width="250">
  
  - There are edit and delete icons in the top-right corner of the appbar for any existing vehicles.
  - Initially, the list will be empty. Press the floating action button in the bottom-right corner to add a new vehicle.

#### Vehicle Edit/Add Page:

- This page will allow you to add any relevant details about the car you are adding (name, color, etc.)
  
  <img src="readme_images/add_vehicle.png" alt="register" width="250">
  <img src="readme_images/vehicle_edit.png" alt="details" width="250">
  
  - Some fields are required, while others are optional.
  - Once finished, your vehicle will be added to the Vehicles list.
 
#### Vehicle Details:

- This page lets you see an overview of a vehicle's details
 <img src="readme_images/vehicle_details.png" alt="details" width="250">
  

### Homepage buttons: Trip

- This page will have a map and geolocation/geocoding functionality to plot a route for one of your vehicles. Statistics such as mileage and distance will be displayed before the trip starts.
  
  <img src="readme_images/trip_page.png" alt="trip" width="250"> 

  - There is a menu icon in the top-left corner of the appbar; this will open a sidebar that allows navigation to other pages in the app.
  - This Trips Pages makes requests to both the Google Maps API to query addresses, and to a GAS API that will return the current average price of gas in the users location.

### Homepage buttons: Service

- This page will display different types of service that you have logged for your vehicles
  
  <img src="readme_images/service_homepage.png" alt="service" width="250">

#### Service Edit/Add Page:

- This page will allow you to add any relevant details about the service you have done on your car
  
  <img src="readme_images/add_service.png" alt="register" width="250">
  <img src="readme_images/service_edit.png" alt="details" width="250">
  
  - Some fields are required, while others are optional.
  - Once finished, your service will be added to the Services list, and will be linked/shown in the vehicle details page.
 
#### Service Details:

- This page lets you see an overview of a service's details
 <img src="readme_images/service_details.png" alt="details" width="250">

### Homepage buttons: Help

- This page lets the user view any FAQs regarding our app
  
  <img src="readme_images/faq.png" alt="help" width="250">

  - You can use the searchbar to search for keywords within a specific FAQ

#### AI Help Page:

- This page lets the user ask an AI chatbot for any vehicle related assistance

  <img src="readme_images/ai.png" alt="help" width="250">
  
- Powered by ChatGPT

## Overview
This group project is designed for you to demonstrate the skills that you have learned in this course.  The final project that you submit in the last week of classes will be a completed mobile application.  Non-functional requirements, especially those associated with production-readiness, will be considered extremely important when marking this project.  You are expected to work in a group of three to five students when completing this project.  Students are not permitted to work alone on the project, as this eliminates one of the learning objectives of this assessment. Peer feedback forms will be required for all three phases of the project to ensure group equity of work.

_**Note:**  Any projects from individual students will not be accepted, except if special permission has been given by the instructor in advance._

## Detailed Instructions

### Choosing a Topic

The project topic is, for the most part, up to you.  Therefore, ensure that you choose a project topic that lets you demonstrate the skills learned in this course.  Consideration will be given to projects whose functionality is rather different from sample applications and those developed in assignments in this course.  When evaluating your project, I will consider this as requiring extra work.  More work done often equates to a higher grade.

It is acceptable if you want to do a project related to industry.  If someone you know wants a web application developed, and it lets you demonstrate the skills you’ve learned in this course, then you can use it for your project (even if you plan to sell that web application when you are finished).  Please keep in mind that nothing your prospective buyer says or does will affect the due date or expectations that I have for this project.  No matter what happens, this project is due when it is due, my expectations will be based on the content of this course, and I will expect a certain degree of professionalism and production-readiness.  Anything outside of the scope of this course will likely not earn you much, in terms of marks.  Proceed with caution.

### Basic Functional Requirements

It is your job to incorporate as many course concepts into your project as possible.  At a minimum, your project must include the following:
- Dialogs and pickers
- Multiple screens and navigation
- Snack bars
- Notifications
- Local storage (SQLite)
- Cloud storage (Firestore or other)
- HTTP requests

The actual size of the project (in terms of the number of screens, number of use cases, or amount of code) will differ from group to group.  Ultimately, the factor being considered is how much work appears to have gone into the project.  Larger groups will be expected to do proportionally more work.

If you incorporate concepts outside of this course (e.g. game engines, 3D graphics, sound) you will get credit, but in the subjective part of the evaluation only.  Thus, ensure that you meet the minimum requirements, outlined above, first. 

Also, ensure you do not design your project such that it needs specialized hardware (e.g. robotics) or special access privileges of any kind (e.g. It has a sign in page and I can't create my own account). If your project fails to run correctly when I attempt to run it directly from my Android phone in my office  you will lose marks. It should be immediately obvious to a user of your app how it works without needing to read any instructions.

### Optional Functional Requirements

Projects will receive more marks for implementing some number of the following:
- Data tables
- Charts
- Maps
- Geolocation
- Geocoding
- Internationalization
- Camera

No individual one of these is specifically required for the project, and these should only be included if they serve a significant purpose for your application's typical use cases.

### Game Development Alternative

Students who want to create a mobile game have the option to do so, but this topic won’t be covered until near the end of the course.  Therefore, it is expected that this option will require significant self-learning to get a head start before the main lectures/examples covering game development.  The functional requirements, listed above, will be relaxed quite a bit for groups developing a game, but the expectations are just as high.  If you wish to pursue this option, please contact the instructor so that we can work out a set of expectations for the major project.

### Evaluation
When evaluating this project, the instructor and the TAs will attempt to give a metric to the amount of work involved, considering several important factors (design, cleanliness of code, code comments, variable/function naming, security checks, error checking, usability/user-friendliness/aesthetic, accessibility, and performance).  This metric will be affected by the size of your group (i.e. what will be evaluated is the average work done per group member).

The marking will occur in three phases.  The idea behind these phases is that your project should improve over time, so that the final product is comprehensive, professional, and production-ready.  It is hoped that your project will make a great portfolio item for when you apply for jobs.  The phased marking should also prevent groups from waiting until just a few days before the due date before starting their project.

### Proposal
The first phase of marking will take place sometime during week 6. This phase will evaluate a written proposal about what you plan to do for your project, including but not limited to the functional requirements and overall project design with UML diagrams (or equivalent). This first marking phase has the purpose of ensuring that your project is reasonable in scope and will incorporate all the necessary components from the course. This evaluation will be worth 10% of your final grade. Unless there is a significant issue of group equity, which should be noted in your README.md and peer feedback forms, all group members will receive the same grade for this evaluation.

#### Written Report (10 marks total)

Max Score | Requirement
--------- | ----------- 
1.00 | overview of project
1.00 | list of group members and their responsibilites
2.00 | list of features (including functional requirements) and how/where they will be used
2.00 | code design (e.g. UML)
2.00 | mockup of user interface
1.00 | writing quality
1.00 | scope of project is reasonable for the number of group members

### Formative Assessment
The second phase of marking will take place sometime during week 10, meaning that you will need to commit the code for your project by the end of week 9.  This will evaluate whether or not you have included the topics from the first weeks of the course, which will be mostly objective, but will also include a small subjective mark describing the work done, the user interface design, and the code/design quality.  A rubric is listed below, so you can verify in advance which topics will be included.  The purpose of the pre-evaluation is to give you an idea of the quality of your project before the end of the term, so that you can make any adjustments necessary to get the grade you want.  This evaluation will be worth 15% of your final grade. Unless there is a significant issue of group equity, which should be noted in your README.md and peer feedback forms, all group members will receive the same grade for this evaluation.

#### Functional requirements (12 marks total)

Max Score | Requirement
--------- | ----------- 
2.00 | Multiple screens/navigation
2.00 | Dialogs and pickers
1.00 | Notifications
1.00 | Snackbars
2.00 | Local storage
2.00 | Cloud storage
2.00 | HTTP Requests

#### Non-functional requirements (3 marks total)

Max Score | Requirement
--------- | ----------- 
1.00 | Amount of work done
1.00 | User interface design/usability
1.00 | Code and design quality

### Summative Assessment

The final phase of marking will be carried out at the end of the course.  This evaluation will be carried out more strictly, with higher expectations. In addition to your fully developed application, each member will need to submit a ~5 minute demonstration video presentation of the app individually, which includes a listing of the project components you personally worked on. This evaluation will be worth 30% of your final grade, divided into 25% (mobile application, shared by the group) and 5% (individual demo). Students who do not submit any individual demo will receive a 0 for all parts of the summative assessment.

#### Functional requirements (5 marks total)

Max Score | Requirement
--------- | ----------- 
0.50 | Multiple screens/navigation
0.50 | Dialogs and pickers
0.50 | Notifications
0.50 | Snackbars
1.00 | Local storage
1.00 | Cloud storage
1.00 | HTTP Requests

#### Non-functional requirements (20 marks total)

Max Score | Requirement
--------- | ----------- 
3.00 | code and design quality
5.00 | user interface design and usability
12.00 | amount of work done

#### Individual Demo (5 marks total)

Max Score | Requirement
--------- | ----------- 
2.50 | demonstration of application
2.50 | explanation and presentation of individual contribution to the project

## How to Submit
The project starter is available on GitHub Classroom, which really just has this README.md, since I want you to have freedom over this project.  There won’t be any starter code, you will start from scratch.  Accept the invite link for this project on GitHub Classroom, and use the new repository generated to store your project files.  This is setup as a group project, so one person can sign up, and others group members can also contribute to the project in that new repository.  

The markers will use this repository to download the latest version of your project, along with other information (e.g. commit logs) available through Git, when they want to mark the project.

_**Note:**  Only one of the group members will accept the GitHub Classroom invitation.  It is recommended that every member of the team verify the final repository on GitHub on submission day, so that everybody can be sure that the correct files were submitted and on time.  You should also clone the latest version into a fresh directory, and run it locally on your machine to ensure that it works without any unusual configuration._

_**Note:**  Work equity will be evaluated using the Git commit logs for your project.  If you decide to work together which results in a misrepresentation of work equity in the commit logs, be sure to mention this in your `README.md`. The instructor will handle all issues of uneven distribution of work on a case by case basis, which may involve adjustments to project grades as needed._

To submit this project, please push all your work to your repository, and add the names of all group members names (but not their SIDs) and their corresponding GitHub usernames (so we can tell who made which commits) to the `README.md` file (at the top).

_**Note:**  Any instances of plagiarism will result in the student(s) receiving a mark of zero for the project, and further disciplinary action will be taken.  Plagiarism includes, but is not limited to:_
- Copying of (any amount of) work from the Internet, without proper citation
- Submitting a body of work, cited or not, that is primarily not your own work
- Copying of (any amount of) work from another student, past or present, without proper citation
- Allowing your own work to be copied by a fellow student

## Getting Help
If you run into difficulty, you may wish to check out some of the following resources:

- https://api.flutter.dev/  - The standard documentation for Flutter, all classes and methods.
- https://dart.dev/tutorials - A series of tutorials for the Dart programming language, focusing entirely on the features of Dart.
- https://flutter.dev/docs/reference/tutorials - A series of tutorials for the Flutter platform, focusing mainly on the widgets and API.
- https://flutter.dev/docs/codelabs - A series of deep-dive, more comprehensive, tutorials to learn more about the Flutter platform.
- https://flutter.dev/docs/cookbook - A set of recipes for commonly used features of Flutter.
- https://github.com/flutter/samples/ - A repository containing some completed Flutter applications.
- http://stackoverflow.com/ - A forum for asking questions about programming.  I bet you know this one already!

Of course, you can always ask us for help!  However, learning how to find the answers out for yourself is not only more satisfying, but results in greater learning as well.

## How to Submit
Create your flutter project, and copy it into this folder, commit, and then push your code to this repository to submit your major group project.

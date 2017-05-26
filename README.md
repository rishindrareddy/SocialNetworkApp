# SocialNetworkApp

## Project Name: The social network

#### Presentation URL: https://docs.google.com/presentation/d/1pwH5g4FE4LNrjjX9j4GA_0QZWNGY5s_osQ_yS-t_7Vc/edit?usp=sharing

#### Authors :
- Rakesh Datta (id: , email: rakesh.datta@sjsu.edu)
- Siddhi Suthar (id: 010718422, email: siddhi.suthar@sjsu.edu)
- Rishindra Reddy D. (id: 011480625, email: rishindrareddy@hotmail.com)
- Aarti Chella (id: 010822565, email: aarti.chella@sjsu.edu)

#
## Table of Contents
-----------------
- [About The APP](#about-The-App)
- [Motivation](#motivation)
- [Solution](#solution)
- [User Stories](#user-stories)
- [Development Stack](#development-stack) 
- [Getting started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installing](#installing)

#


### About The App
--------

Social media networking applications have the capability to help a user to take their social web presence and activity to a 
complete new level. They save a lot of time and energy that we would otherwise spend trying to do everything manually.

The best social networking applications offer a variety of solutions that can help to easily organize accounts and share 
information across several networks without ever needing to post anything separately to our accounts directly from the web. 
Although these applications differ in features such as layouts and intuitiveness, they all get the job done when we opt for 
the right application that matches our current social presence and marketing strategy. Through this project, we are trying to 
implement our ideas in a social networking application with multiple features, exploring  iOS application development with Swift.

#

### User Stories
------------
Alice registers for a new account, and verifies her email.
Alice browses profiles with public visibility, and finds Bob.
Alice adds Bob as a friend, and Bob accepts.
Alice views Bob's timeline, where Bob has posted lots of stuff.
Alice doing back-and-forth private messaging with Bob.

#

### Development Stack
---------------------
Technology Stack implemented:
· Firebase
· Xcode
. Cocoapods

Database:
We have used Firebase services to build our data model for the app. Application renders the content to the user through 
MVC architecture. Firebase Auth library is used to manage authetication and user profiles. Firebase storage to add images 
into the app. Firebase database library to store the data model as a whole.

IDE:
We have built our applciation in Xcode version 8.3.2 using swift 3.


#

### Getting Started

To get started with this application you would need to have a Xcode installed in your machine where you would launch this 
application.

#
### Prerequisites
You would need Xcode software installed in your system (for mac). if you use windows os, you would need to using virtual machine 
software to run Xcode in Windows.

For setting up Firebase database, simply create an account in Firebase and create an app. Download the google-PList file and include 
it in your project files. Also refer to documentation of setting up Firebase in ios application from https://firebase.google.com/docs/.


#
### Installing

- git pull https://github.com/siddhisuthar/SocialNetworkApp.git
- sudo gem install cocoapods
- nano Podfile
  Inside podfile include the libraries you want to download, so add below lines:
  pod 'Firebase'
  pod 'FirebaseAuth'
  pod 'FirebaseStorage'
  pod 'FirebaseDatabase'
 - pod install
 
  

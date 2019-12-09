# Crystal rovers

This is my implementation of the final crystal project from Groxio/Programmer Passport (https://grox.io/)

## Installation

* Make sure that you have crystal lang installed on your machine
* Clone the repo
* From the root folder, run `crystal run src/rovers.cr`

## Usage

The service has four endpoints:
* post "rover/:name" - create a new rover
* get "rover/:name" - view a rover's status
* post "rover/move/:name/:instructions" - give a rover a set of instructions to execute (in strings made up of l/L, r/R, and f/F)
* delete "rover/:name" - delete a rover

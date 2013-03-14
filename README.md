# Tenderloin
### Tenderloin is a Remote Control Server for Google Hangouts  


Built as a simple push based service, Tenderloin is a server that interfaces with the [Golden Gate Chrome Extension](https://github.com/mattinsler/golden-gate "Golden Gate Chrome Extension") to extend Google Hangouts for collaboration, productivity and hacking fun.

____

## How does it work?

Tenderloin connects with instances of Golden Gate to and allows users to send javascript commands to any hangout they connected to that is also connected to Golden Gate. Commands are sent from the Golden Gate client to the Tenderloin server, and then passed to the intended Google Hangout.

____

## What can I use it for?

We ([@mattinsler](https://github.com/mattinsler) & [@patrickod](https://github.com/patrickod)) are big fans of inter-room communication. At [Unified](https://github.com/unified), we use Tenderloin to setup a persistent Google+ hangout between our New York City and San Francisco offices. With the hangout running on a Mac Mini connected to a TV, this helps us collaborate and work as a team faster and meet face-to-face as a group, even when we're 3000 miles away.

#### Tenderloin and Golden Gate allow us to: 

- Toggle the camera and microphones on and off in each office
- Play alert noises to attract people's attention in the other office
- Interact with the DOM on on the hangout in another office to 
_____

## Install and deploy to Heroku in 1-step

To install and deploy Tenderloin to Heroku in one fell swoop, copy the following command and execute it in your command line:

	bash <(curl -s http://www.gettenderloin.com/install.sh)

*You'll need to have Heroku and Git Installed for this install script to run properly, but you already know that ;)*

This script will download Tenderloin and after a few prompts, automatically deploy an instance of Tenderloin to Heroku.

____

## Using Tenderloin

We maintain a public instance of Tenderloin, which allows people to use [Golden Gate](https://github.com/mattinsler/golden-gate) without having to run their own server.

Tenderloin uses Google Oauth for authentication. We designed Tenderloin to be used with you'll need to create an organization:

____

## Security Warning

When paired with Golden Gate, Tenderloin gives users connected to the same hangout the ability to inject arbitrary javascript into your browser window. This is obviously a gigantic security hole. Please, please, please only use Tenderloin with people you trust.

____

## Why is it called Tenderloin?

See the security warning above. You've got to be careful in the Tenderloin, whether you're in San Francisco or using this application.

Plus, no one else in their right mind was going to name their project Tenderloin ;)

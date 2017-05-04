## Introduction

Conquest System is a lightweight addon to add conquest features in **any** gamemode.

Capture points are set up by admins and any team can capture them by being in the area for at least 5 seconds (see config). If a different team player enters the zone while contesting it, then the point is reset until only one team remains.

The goal of this system is to allow easy customization of the entire interface **(for non developers)** and to provide a decent API for developers to integrate with.

## Features
- Simple to use admin interface to manage capture points.
- DarkRP integration (darkrp version 2.7.0+).
- Developer hooks.
- Lightweight non-conflicting addon.
- Highly configurable.
- Capture points saved per map.
- Spawning at captured points.
- DarkRP money rewards for capturing and maintaining.

## Configuration Options


- Fonts
- Colours
- Capture Time
- Icon position when capturing
- Icon shapes
- Icon size
- Text padding
- Toggle icon seen through walls.
- Icon fading with distance.
- Disallow jobs/teams from capturing specific points.
- Random or manual point selection to spawn at.

All of the configuration is inside the `ConquestSystem/lua/ConquestSystem/sh_config.lua`.

## Setting up
Setting points up:


1. As an admin, open the Conquest System GUI using `ConquestSystem_Open` in the console.
1. Move to the location you want to create the capture point at.
1. Navigate to the `Create` interface through the button on the Conquest System GUI.
1. Type in the credentials and hit accept, your capture point is now in the system.

To enable a point to be captured by categories of jobs (ie. government) instead of individual jobs then check the "Categories" checkbox when creating the point and have DarkRP enabled in the config.


## Developer API

Hooks are available for use in development, listed as:


1. `ConquestSystem_PointCaptured`, Args = TeamName, PointName
1. `ConquestSystem_CapturedPointTick`, Args = TeamName, PointName - this hook is called once per second.
1. `ConquestSystem_PointLost`, Args = TeamName, PointName


## Commands
"ConquestSystem_Open": Opens the Conquest System GUI.

## Important details
- Tags can only be 1 characters long eg. A, B, C, 1, 2, 3
- Verified to work with darkrp version 2.7.0+
- If the textures aren't working please use this addon for the content, http://steamcommunity.com/sharedfiles/filedetails/?id=813374095.
- If spawning is enabled and they have no captured points in the team, them they will spawn at the default map positions.

If you have any problems with this please comment here and I will look into it ASAP. Any other questions about building a system around this are also welcome!
Thank you, enjoy!
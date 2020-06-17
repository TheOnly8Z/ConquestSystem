## Introduction

This fork is a patched version of the original Conquest System. Can you believe I bought that broken thing on gmodstore?

## Setting up
All of the configuration is inside the `ConquestSystem/lua/ConquestSystem/sh_config.lua`.

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

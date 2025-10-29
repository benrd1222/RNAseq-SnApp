# RNAseq-SnApp
A snake make workflow for RNASeq analysis with DESeq2 and customizable visualization bundled with a front-end app for easy implementation

The main issue I am trying to overcome is the software literacy hurdle for some of these automation techniques. I want my lab to be able to use this after I am gone.so I need to make this accessible in two ways.

1. Make the snake make workflow process initial RNAseq analysis and visualization easy. Just have access to the repository in some way, update the config.yaml to point at your data and you have an analysis.
2. Make the assignment of the data to analyze easy and make deeper changes to configuration easy through an advanced settings tab- Plan is to have a GUI (maybe Tkinter based app)
  * This hopefully makes it so that people who don't have time to learn all the back end can still benefit from configuration of the automation and those that are trying to learn can peak under the hood with the advanced settings as a gateway to learning.
3. Make installation easy, obviously this should work with just git clone repo, change some configs and run, but it would be nice to package the functionality so that I can give lab members a 3 step installation guide
  * Click link
  * Download (containerized) app
  * Make a shortcut to the app on your desktop
  - Done now you have a regular windows-like desktop app

Figuring out containerization with docker, should be easy enough because the installation can be streamlined for lab use.

I am now figuring out if I want the workflow to be run within the container or to just use the container for the rule environments. Next steps are testing containerization setup with a simple docker test locally, then running the first basic utility tests of the workflow, and then creating some unit tests before moving on to visualization and automation of reports.

After all of the above will come the design of the application, essentially a GUI to help edit the config.yaml.
  * The key things to consider with docker is if containerization of the application seems useful for the end user
  * If I do end up containerizing the application I thought that it would be useful to design the app around interacting with projects. The idea being that the application interacts with the local host through projects on their machine, so it will either be able to create a new project essentially just defining a workspace on the host machine and then setting up docker volumes and the config.yaml or working with previously run projects where it should work like a regular snakemake workflow that remembers what has been updated and runs the relevant rules to update the outputs.

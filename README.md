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

Note that the envs is where the reproducible environments are set up which may not be necessary if I use a Docker container 

I would also note that the config section is where the config.yaml that controls the overall workflow will be located as well as any sort of samplesheet.

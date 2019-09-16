# Docker SOLR with ssl

Simple and effective docker-compose setup of a single Linux container running solr with SSL preconfigured and the solr_home (the root for core and indexes) and certificates on a shared volume.

Some different SOLR version setups are available as branches. If you need a different version simply modify the docker-compose file and update the files in solr_home with the files from the corresponding solr version found in {solr dist package}/server/solr

# Prerequisites
- [Docker for Windows](https://docs.docker.com/docker-for-windows/)
- Drive shared with Docker (Docker tray icon > Settings > Shared Drives > _volume_)

## Quick usage

1. Open a PowerShell console as admin in this folder
2. Run Start-Solr.cmd
3. Verify that solr is running by opening https://localhost:8983 in browser

## "Advanced" usage

1. Open a PowerShell console as admin in this folder
2. Run `.\Generate-Certificate.ps1 [name of certificate solr_811_ssl] [certificate domain localhost] [certificate password 123SecureSolr!] [expires months 36]`
3. Open docker-compose.yml and change environment parameters SOLR_SSL_KEY_STORE_PASSWORD and SOLR_SSL_TRUST_STORE_PASSWORD to the supplied password used as argument in step 2.
4. Run `docker-compose up -d` from the console
5. Verify that solr is running by opening `https://localhost:8983` in browser

Enjoy.

## Use with Sitecore Installation Framework

To use the SOLR container with the Sitecore Installation Frameworksome minor changes has to be made in the default configuration files.

- sitecore-solr.json
- xconnect-solr.json

In both config files you will need to change

```javascript
    // Resolves the full solr folder path on disk.
    "Solr.Server":      "[joinpath(variable('Solr.FullRoot'), 'server', 'solr')]",
```

to

```javascript
    // Resolves the full solr folder path on disk.
    "Solr.Server":      "[resolvepath(parameter('SolrRoot'))]",
```

Then pass in the full path to `.\solr_home` as SolrRoot.

I do sometime wonder why Sitecore ship these standard config files with hardcoded sub paths when the passed in parameter is not needed by itself at all. The parameter needed by SIF is really just the path to the solr_home directory so the ootb Sitecore core configsets can be copied to the folder.

You also have to remove the SIF tasks related to starting and stopping the SOLR Windows Service thus removing the requirement for having SOLR running as a Windows Service which is a weird requirement to have by default anyway since there is absolutely no apparent good reason to wrap SOLR in a Windows Service on a developer machine.

Remove the following 2 tasks from both config files or pass in `-Skip "StopSolr", "StartSolr"` to Install-SitecoreConfiguration

```javascript
   "Tasks": {
        // Tasks are separate units of work in a configuration.
        // Each task is an action that will be completed when Install-SitecoreConfiguration is called.
        // By default, tasks are applied in the order they are declared.
        // Tasks may reference Parameters, Variables, and config functions. 

        "StopSolr": {
            // Stops the Solr service if it is running.
            "Type": "ManageService",
            "Params": {
                "Name": "[parameter('SolrService')]",
                "Status": "Stopped",
                "PostDelay": 1000
            }
        }
        ...
                "StartSolr": {
            // Starts the Solr service.
            "Type": "ManageService",
            "Params": {
                "Name": "[parameter('SolrService')]",
                "Status": "Running",
                "PostDelay": 8000
            }
        }
```

Optionally also remove the now unused `SolrService` parameter. This might require you to change parameters passed from your install script and settings file.

For Habitat `install-xpo.ps1` you will have to remove the check for JRE on your machine , the check if the SOLR service is running and the check of the solr root folder - I really do not get why SIF doesnt just take the solr_home path as argument, anyone who used SOLR will know this folder and what it contains. Anyway, It alwyas feels good to get rid of some unnecessary complexity ;)

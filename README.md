# Docker SOLR with ssl

Simple setup that builds a Linux container on a Windows host running solr with SSL using a generated certificate.

## Quick usage

1. Open a PowerShell console as admin in this folder
2. Run Start-Solr.cmd
3. Verify that solr is running by opening https://localhost:8983 in browser

## "Advanced" usage

1. Open a PowerShell console as admin in this folder
2. Run `.\Generate-Certificate.ps1 [name of certificate solr_662_ssl] [certificate domain localhost] [certificate password 123SecureSolr!] [expires months 36]`
3. Open docker-compose.yml and change environment parameters SOLR_SSL_KEY_STORE_PASSWORD and SOLR_SSL_TRUST_STORE_PASSWORD to the supplied password used as argument in step 2.
4. Run `docker-compose up -d` from the console
5. Verify that solr is running by opening `https://localhost:8983` in browser

Enjoy.

## Use with Sitecore Installation Framework

To use the SOLR container with the Sitecore Installation Framework 1.2.0 some minor changes has to be made in the sitecore-solr.json and xconnect-solr.json configuration files.

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

I do sometime wonder why Sitecore ship these standard config files with hardcoded sub paths when the passed in parameter is not needed by itself at all. The parameter needed by SIF is really just the environment variable SOLR Home so the core configs can be copied in.

Also note that you can remove the SIF tasks related to starting and stopping SOLR Windows Service thus removing the requirement for having SOLR running as a Windows Service.

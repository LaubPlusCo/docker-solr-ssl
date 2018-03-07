# Docker SOLR with ssl
Simple setup that builds a Linux container on a Windows host running solr with SSL using a generated certificate.

## Quick usage
1. Run Build.cmd as admin in a console
2. Type in parameters for certificate (friendly name, dns name and password)
3. Wait..
4. Open https://localhost:8983 in a browser
5. Enjoy


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

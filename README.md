# Ecological Metadata Language metadatablock for Dataverse

## Introduction

The definition of the metadablock is maintaned in a Google Sheet for simplicity.
The current development sheet is available at: [https://docs.google.com/spreadsheets/d/1pi0j3xTtFaWHlUO-IjcB0kSQxA45Ew0tnk5v7-_ygH0](https://docs.google.com/spreadsheets/d/1pi0j3xTtFaWHlUO-IjcB0kSQxA45Ew0tnk5v7-_ygH0).

## Create a distribution

Run: `./update.sh`
The command will download data from the Google Sheet into the file `dist/eml.tsv`.

## Loading TSV files into a Dataverse Installation

The `dist/eml.tsv` can be loaded into a Dataverse Installation by executing the following command:
```bash
curl http://localhost:8080/api/admin/datasetfield/load -H "Content-type: text/tab-separated-values" -X POST --upload-file dist/eml.tsv
```
More information at: [Loading TSV files into a Dataverse Installation](https://guides.dataverse.org/en/latest/admin/metadatacustomization.html#loading-tsv-files-into-a-dataverse-installation)

## Updating the Solr Schema

Execute
```bash
curl "http://localhost:8080/api/admin/index/solr/schema" | update-fields.sh /usr/local/solr/server/solr/collection1/conf/schema.xml
```
Replace `/usr/local/solr/server/solr/collection1/conf/schema.xml` for the location of solr schema in your machine.

Reload your Solr schema via an HTTP-API call, targeting your Solr instance:

```bash
curl "http://localhost:8983/solr/admin/cores?action=RELOAD&core=collection1"
```

Response:
```json
{
  "responseHeader":{
    "status":0,
    "QTime":1788
   }
}
```

More information at: [Updating the Solr Schema](https://guides.dataverse.org/en/latest/admin/metadatacustomization.html#updating-the-solr-schema)

## Translations

### Adding Multiple Languages to the Dropdown in the Header

The presence of the :Languages database setting adds a dropdown in the header for multiple languages. For example to add English and French to the dropdown:

`curl http://localhost:8080/api/admin/settings/:Languages -X PUT -d '[{"locale":"en","title":"English"},{"locale":"br","title":"Português"}]'`

When a user selects one of the available choices, the Dataverse user interfaces will be translated into that language (assuming you also configure the `lang` directory and populate it with translations as described below).

### Configuring the `lang` directory

Translations for the Dataverse Software are stored in “properties” files in a directory on disk (e.g. /home/dataverse/langBundles) that you specify with the dataverse.lang.directory dataverse.lang.directory JVM option, like this:

`asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} create-jvm-options '-Ddataverse.lang.directory=/opt/payara/langproperties'`

Go ahead and create the directory you specified.

`mkdir /opt/payara/langproperties`

Replace `/opt/payara/langproperties` by the directory of language files in your installation.

### Creating a languages.zip File

The Dataverse Software provides and API endpoint for adding languages using a zip file.

First, clone the `dataverse-language-packs` git repo.

`git clone https://github.com/GlobalDataverseCommunityConsortium/dataverse-language-packs.git`

Take a look at [https://github.com/GlobalDataverseCommunityConsortium/dataverse-language-packs/branches](https://github.com/GlobalDataverseCommunityConsortium/dataverse-language-packs/branches) to see if the version of the Dataverse Software you’re running has translations.

Change to the directory for the git repo you just cloned.

`cd dataverse-language-packs`

Switch (`git checkout`) to the branch based on the Dataverse Software version you are running. The branch *dataverse-v4.13* is used in the example below.

`export BRANCH_NAME=dataverse-v5.13`

`git checkout $BRANCH_NAME`

Create a `languages` directory in `/tmp`.

`mkdir /tmp/languages`

Copy the properties files into the `languages` directory

`cp -R en_US/*.properties /tmp/languages`

`cp -R pt_BR/*.properties /tmp/languages`

Copy the Ecological Metadata Block translation to `languages` directory

`cp ../lang/emldn.properties ../lang/emldn_br.properties /tmp/languages`

Create the zip file

`cd /tmp/languages`

`zip languages.zip *.properties`

### Load the languages.zip file into your Dataverse Installation

Now that you have a `languages.zip` file, you can load it into your Dataverse installation with the command below.

`curl http://localhost:8080/api/admin/datasetfield/loadpropertyfiles -X POST --upload-file /tmp/languages/languages.zip -H "Content-Type: application/zip"`

Click on the languages using the drop down in the header to try them out.

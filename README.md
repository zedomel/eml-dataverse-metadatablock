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

Rreload your Solr schema via an HTTP-API call, targeting your Solr instance:

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

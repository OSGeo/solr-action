# solr-action
# Solr GitHub Action

This [GitHub Action](https://github.com/features/actions) sets up Solr

# Usage

See [action.yml](action.yml)

Basic:
```yaml
steps:
- uses: OSGeo/solr-action@main
  with:
    solr_version: latest
    host_port: 8983
    container_port: 8983
```

# License

The scripts and documentation in this project are released under the [Apache License](LICENSE)

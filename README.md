# Akademieprotokolle



* data is fetched from https://github.com/fun-with-editions/akademie-data
* build with [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter)

# Documentation

## `build.yml`

### `actions/checkout@v4`

 - Can be found under the following address [actions/checkout](https://github.com/actions/checkout) with documentation.
 - Checks out the repository into ```$GITHUB_WORKSPACE``` for further processing.
 - Important options are: ```repository: '...'```: the repository to check out; ```path: '...'```: the relative path under ```GITHUB_WORKSPACE``` to place the repository.

### `peaceiris/actions-gh-pages@v3`

 - Can be found under the following address [peaceiris/actions-gh-pages](https://github.com/peaceiris/actions-gh-pages) with further documentation.
 
### Errors and Problems

#### Github Action can not access shellscripts

Solution: Tbd.
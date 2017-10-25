Travis_simplecases


Scripts used to deploy and build on Travis

- [deploy_ghpages.sh](./scripts/deploy_ghpages.sh): will build and deploy only on commits made  directly to the gh-pages branch
- [gh_config.sh](./scripts/gh_config.sh): configure the GH repository
- [merge_master.sh](./scripts/merge_master.sh): will clone master into the g-pages branch
- [auto_merge.sh](./scripts/auto_merge.sh): will merge a given branch into another



## Authentication
You will first need to get a Personal access token from GitHub.

Make sure to copy the token as this will not be displayed later!!! Or ever again!

You will need to add your token and GH username to the `.travis.yml` file using the travis ruby gem:
```bash
$ travis encrypt GH_USER=<your username> --add env.global
$ travis encrypt GH_TOKEN=<token> --add env.global
```

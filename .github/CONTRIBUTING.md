
# Contributing

When contributing to this repository, please first discuss the change you wish to make via issue,
email, or any other method with the owners of this repository before making a change. 

Please note we have a code of conduct, please follow it in all your interactions with the project.

## Pull Request Process

1. Ensure you run `make test` locally to build and test the container before publishing any changes to the `Dockerfile`, `Makefile` & `run.sh` files. 
2. Update the `README.md` with details of changes / new functionality.
3. Please be aware we have 2 versions, the `master` which is published on docker hub as `:latest` & a `hardened` branch available with the `:hardened` tag on docker which includes a few improvements to the security. We have 2 versions as some of the hardened security changes break changes with existing uses.
4. When forking the project for changes, please use the `master` branch as then we can merge this into `hardened` later.

## Code of Conduct

When submitting issues or pull requests you must follow the terms of our [code of conduct](CODE_OF_CONDUCT.md).

## License

All code in this repo is MIT licensed.

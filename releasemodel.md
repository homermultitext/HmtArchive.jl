# Release model

1. work goes on in `dev` branch
2. validation fast enough to run on whole archive in (reasonably small number of) seconds
3. if validation passes, compose a complete CEX serialization
4. merge `dev` with `main`

On commits to `main`, github action automatically:


1. tags commit as a release with a github version tag
2. pushes the tagged release to a new tagged branch
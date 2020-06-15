# Releasing

_NB: Currently this gem is not published to RubyGems._

To make managing the version of this gem easier we are using the
[bump](https://github.com/gregorym/bump) gem. Please review the following
information to understand how to update the version of this gem as changes
are made.

## How to update the version

To update the version and create a tag use the following command:

```
bump <major/minor/patch/pre> --tag --tag-prefix v --commit-message "<your commit message>"
git push origin --tags
```

If you want to provide a multi line commit message you can use:

_NB: You will have to add the tag manually._
```
bump <major/minor/patch/pre> --no-commit
git tag v<version>
git push origin --tags
```

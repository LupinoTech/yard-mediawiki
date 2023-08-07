# yard-mediawiki

![Static Badge](https://img.shields.io/badge/Status-Highly%20Experimental-f88)

**This is a work-in-progress!**

**NO NOT USE YET!**

Template for Yardoc to output files in (Semantic) Mediawiki syntax

## Sumary

yard-mediawiki is a template for [YARD](https://yardoc.org/) derived
from the default HTML output template. It writes the documentation
into `.mw` files which can be exported into any MediaWiki instance.

As of now, the template still prints mostly HTML.

## Usage

Download and store the template files somewhere on your system.

Run `yardoc` with the repo's "yard-mediawiki.rb" as plugin (`-e`),
"mediawiki" as template name (`-t`) and "mwtext" (`-f`) as output format:

```
yardoc <more_yard_options> -e <path_to>/yard-mediawiki/yard-mediawiki.rb -t mediawiki -f mwtext -o <path_to_output> <additional_options> <path_to_input>
```

### Additional Options

* `--mw-namespace=<namespace>` Namespace that is added to cross references and internal links (*default:* empty)
* `--[no-]mw_semantic` Whether or not Semantic Mediawiki's properties are used (*default:* `--no-ms-semantic`)

## License

see LICENSE file in the repo's base directory.

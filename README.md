# Base16 Kitty

My version of [Base16][] for [kitty][].

It departs from the official [kdrag0n/base16-kitty][] repository in a few ways:

- Different color mapping choices. For example, I use a blue cursor.
- No support for 256-color variants. These [defeat the purpose of Base16][issue].
- A build setup geared around only building themes for kitty, not all the templates.
- Ability to override theme repositories. I use this for my version of [Solarized][].

## Usage

1. `make deps` to install [pybase16-builder][]
2. `make update` to clone all scheme repositories
3. `make` to build kitty colors in `./colors`

To use a local scheme repository, run `./register.sh path/to/repo`. Next time you run `make update`, it will include this (overriding the official repository if there is one of the same name).

## License

© 2020 Mitchell Kember

Base16 Kitty is available under the MIT License; see [LICENSE](LICENSE.md) for details.

[Base16]: https://github.com/chriskempson/base16
[kitty]: https://sw.kovidgoyal.net/kitty/
[kdrag0n/base16-kitty]: https://github.com/kdrag0n/base16-kitty
[Solarized]: https://github.com/mk12/base16-solarized-scheme
[issue]: https://github.com/chriskempson/base16/issues/174
[pybase16-builder]: https://github.com/InspectorMustache/base16-builder-python

# zxz - a CLI to interact with <https://0x0.st>

The <https://0x0.st> is a simple "Temporary file hoster", useful when you want to quickly share a file over the internet.

This projects provides a CLI to _almost_ all 0x0 features and some more

I've created this mainly to try out [Bashly](https://bashly.dannyb.co/) - a Bash command line framework and CLI generator.

Turns out that the resulting program is actually useful. :)

## Usage

### Uploading a file

The most basic usage is to simply upload a file:

```bash
zxz MY_FILE
```

It uploads `MY_FILE` to https://0x0.st/ and prints the URL where the file is available.

If you want to copy the URL to the clipboard right after uploading a file:

```bash
zxz --copy-url MY_FILE
```

If you want your uploaded file to be available only for 2 hours, you can set the retention time:

```bash
zxz --retention-hours=2 MY_FILE 
```

### Other features

The `zxz` also

- keeps a list with the name of your uploaded files and their respective URLs: `zxz list`
- allows you to delete a file you uploaded: `zxz delete`
- and other conveniences, e.g. copy the URL right after uploading a file: `zxz upload <filename> --copy-url`

#### Missing features

The 0x0.st service allows you to  the **expiration time**, but I'm not interested in working on this feature.

They say in the official page that 0x0.st can copy a file from another URL, but I wasn't able to make it work (and also not interested).

## Installation

Just get the [bashly generated `zxz` script](./zxz) and put it in your PATH. Example:

```bash
# assuming ~/.local/bin is present in your PATH
curl \
  -o ~/.local/bin/zxz \
  "https://raw.githubusercontent.com/meleu/zxz/refs/heads/main/zxz"

# if you want it system wide (requires `sudo`)
sudo curl \
  -o /usr/local/bin/zxz \
  "https://raw.githubusercontent.com/meleu/zxz/refs/heads/main/zxz"
```

You can also clone this repo and then `make install`:

```bash
git clone https://github.com/meleu/zxz
cd zxz
make install
```

## Credits

### https://0x0.st/

The <https://0x0.st/> service is maintained by Mia Herkt. If you like it, consider supporting them financially (information in [the bottom of the 0x0.st webpage](https://0x0.st/)).

### Bashly

I only started this project because I wanted to try [Bashly](https://bashly.dannyb.co/). Turns out that I became amazed by the tool.

It seems to be the kind of tool that will change forever the way I write my bash programs, just like [shellcheck](https://github.com/koalaman/shellcheck) and [shfmt](https://github.com/mvdan/sh).

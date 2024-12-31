# zxz - a CLI for quick file sharing via <https://0x0.st>

The <https://0x0.st> is a simple "Temporary file hoster", useful when you want to quickly share a file over the internet.

The `zxz` is a handy CLI designed to make your interactions with 0x0.st easier.

I've created this mainly to try out [Bashly - a Bash command line framework and CLI generator](https://bashly.dannyb.co/), and turns out that the result became genuinely useful.

## Table of Contents

- [Usage](#usage)
  - [Uploading a File](#uploading-a-file)
    - [Simple Way](#simple-way)
    - [Upload and Copy URL to Clipboard](#upload-and-copy-url-to-clipboard)
    - [Upload with Retention Time](#upload-with-retention-time)
  - [Other Features](#other-features)
  - [Missing Features](#missing-features)
- [Installation](#installation)
- [Credits](#credits)

## Usage

You should check the `zxz --help` output to see all the available options.

Here's the most common usage scenarios.

### Uploading a file

#### simple way

The most basic usage is to simply upload a file:

```bash
zxz MY_FILE
```

It uploads `MY_FILE` to <https://0x0.st/> and prints the URL where the file is available.

#### upload and copy URL to clipboard

Automatically copy the URL right after uploading the file:

```bash
zxz --copy-url MY_FILE
```

#### upload and set a retention time

If you want your uploaded file to be available only for 2 hours, you can set the retention time:

```bash
zxz --retention-hours=2 MY_FILE 
```

### Other features

The `zxz` also

- keeps a list with the name of your uploaded files and their respective URLs: `zxz list`
- allows you to delete a file you uploaded: `zxz delete`
- and other conveniences, e.g. copy the URL right after uploading a file: `zxz upload <filename> --copy-url`

### Missing features

The 0x0.st service allows you to change the **expiration time**, but I'm not interested in working on this feature.

They say in the official page that 0x0.st can copy a file from another URL, but I wasn't able to make it work (and also not interested).

## Installation

Just get the [bashly generated `zxz` script](./zxz), put it in your PATH and make it executable.

Example: assuming `~/.local/bin` is present in your PATH

```bash
# download it
curl \
  -o ~/.local/bin/zxz \
  "https://raw.githubusercontent.com/meleu/zxz/refs/heads/main/zxz"

# make it executable
chmod +x ~/.local/bin/zxz

# use it
zxz --help
```

You can also clone this repo and then `make install`:

```bash
git clone https://github.com/meleu/zxz
cd zxz
make install
```

## Credits

### <https://0x0.st/>

The <https://0x0.st/> service is maintained by Mia Herkt ([in this repository](https://git.0x0.st/mia/0x0)). If you like it, consider supporting them financially (information in [the bottom of the 0x0.st webpage](https://0x0.st/)).

### Bashly

I only started this project because I wanted to try [Bashly](https://bashly.dannyb.co/). Turns out that I became amazed by the tool.

It seems to be the kind of tool that will change forever the way I write my bash programs, just like [shellcheck](https://github.com/koalaman/shellcheck) and [shfmt](https://github.com/mvdan/sh).

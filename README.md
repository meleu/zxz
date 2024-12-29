# zxz - a CLI to interact with <https://0x0.st>

## Roadmap

Information to put in the help/description message:

> File URLs are valid for at least 30 days and up to a year
> (see <https://0x0.st/> for more details).
>
> Maximum file size: 512.0 MiB

- [x] upload a file
  - `zxz <filename>`
  - `curl -F'file=@yourfile.png' https://0x0.st`
- [x] validate the given filename
- [x] `--secret` option

- [x] proper User Agent
  - `zxz/<version - https://github.com/meleu/zxz`

- [x] upload to a different 0x0 instance
  `--server`

- [x] managing files
  - save the `X-Token` - `curl -i`
  - `~/.local/share/zxz/uploads.csv`
- [x] list uploaded files
  - [x] `zxz list`
  - [x] `zxz list --update`

- [x] delete the file
  - `zxz delete <URL>`
  - `curl -Ftoken=token_here -Fdelete= https://0x0.st/abc.txt`

- [ ] ~~`--expires` option~~ I'm not interested on this (too much work for low value)
- [ ] Update expiration
  - `zxz ???` - not sure how to call this command
  - `curl -Ftoken=token_here -Fexpires=3 https://0x0.st/abc.txt`

- [ ] ~~copy a file from a URL~~ This feature doesn't work well on the server side
  - need to check if the given file is an URL
  - `zxz <url>`
  - `curl -F'url=http://example.com/image.jpg' https://0x0.st`

```bash
url_regex="^(https?|ftp)://[^\s/$.?#].[^\s]*$"

validate_url() {
  if [[ $1 =~ $url_regex ]]; then
    echo "Valid URL"
  else
    echo "Invalid URL"
  fi
}

url_to_check="http://example.com"
validate_url "$url_to_check"
```

---

> in curl, how can I check if a file exists in a URL without actually downloading it?

You can use the curl command with the --head or -I option to check if a file exists at a URL without downloading
it. This option sends an HTTP HEAD request, which retrieves the headers only, allowing you to check the HTTP status
code.

Here's an example:

```
 curl -I http://example.com/file.txt
```

Look for the HTTP status code in the response headers:

 • 200 OK indicates the file exists.
 • 404 Not Found indicates the file does not exist.

This method is efficient for checking file existence without downloading the content.

---

## Uploading files

Send HTTP POST requests to <https://0x0.st> with data encoded as multipart/form-data

Valid fields are:
  ┌─────────┬────────────┬────────────────────────────────────────────────┐
  │ field   │ content    │ remarks                                        │
  ╞═════════╪════════════╪════════════════════════════════════════════════╡
  │ file    │ data       │                                                │
  ├─────────┼────────────┼────────────────────────────────────────────────┤
  │ url     │ remote URL │ Mutually exclusive with “file”.                │
  │         │            │ Remote site must return Content-Length header. │
  ├─────────┼────────────┼────────────────────────────────────────────────┤
  │ secret  │ (ignored)  │ If present, a longer, hard-to-guess URL        │
  │         │            │ will be generated.                             │
  ├─────────┼────────────┼────────────────────────────────────────────────┤
  │ expires │ hours OR   │ Sets maximum file lifetime in hours OR         │
  │         │ ms since   │ the time of expiration in milliseconds since   │
  │         │ epoch      │ UNIX epoch.                                    │
  └─────────┴────────────┴────────────────────────────────────────────────┘

cURL examples:

```bash
# Uploading a file:
curl -F'file=@yourfile.png' https://0x0.st

# Copy a file from a remote URL:
curl -F'url=http://example.com/image.jpg' https://0x0.st

# Same, but with hard-to-guess URLs:
curl -F'file=@yourfile.png' -Fsecret= https://0x0.st
curl -F'url=http://example.com/image.jpg' -Fsecret= https://0x0.st

# Setting retention time in hours:
curl -F'file=@yourfile.png' -Fexpires=24 https://0x0.st

# expiration date formatted as milliseconds since UNIX epoch:
curl -F'file=@yourfile.png' -Fexpires=1681996320000 https://0x0.st
```

It is possible to append a custom file name to any URL:
    <https://0x0.st/aaa.jpg/image.jpeg>

File URLs are valid for at least 30 days and up to a year (see above).

Expired files won’t be removed immediately but within the next minute.

Maximum file size: 512.0 MiB

## Managing your files

Whenever a file that does not already exist or has expired is uploaded,
the HTTP response header includes an X-Token field. You can use this
to perform management operations on the file by sending POST requests
to the file URL.

When using cURL, you can add the -i option to view the response header.

Valid fields are:
  ┌─────────┬────────────┬────────────────────────────────────────────────┐
  │ field   │ content    │ remarks                                        │
  ╞═════════╪════════════╪════════════════════════════════════════════════╡
  │ token   │ management │ Returned after upload in X-Token HTTP header   │
  │         │ token      │ field. Required.                               │
  ├─────────┼────────────┼────────────────────────────────────────────────┤
  │ delete  │ (ignored)  │ Removes the file.                              │
  ├─────────┼────────────┼────────────────────────────────────────────────┤
  │ expires │ hours OR   │ Sets maximum file lifetime in hours OR         │
  │         │ ms since   │ the time of expiration in milliseconds since   │
  │         │ epoch      │ UNIX epoch.                                    │
  └─────────┴────────────┴────────────────────────────────────────────────┘

cURL examples:

```bash
# Delete a file immediately:
curl -Ftoken=token_here -Fdelete= https://0x0.st/abc.txt

# Change the expiration date (see above):
curl -Ftoken=token_here -Fexpires=3 https://0x0.st/abc.txt
```

## Notes for client software and script authors

### Use a user agent string that uniquely identifies your program

There are no rules for the format, just conventions. I don’t try to
parse these in any way, so something like “NameOfProgram/1.0” is
perfectly fine.
Some software actually includes contact info in the string in case
someone needs to talk to the author, and I think that’s a great
idea!

### Consider an option to change to a different 0x0 instance

I haven’t seen many of them in the wild, but this should take very
little effort.

### If you need to do a lot of testing, consider running a local 0x0 instance

That way, you avoid accidental uploads are not restricted by
network bandwidth. You’ll only need the built-in development
server, so setting it up should only take a minute or two.

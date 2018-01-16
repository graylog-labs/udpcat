# udpcat

A small command-line utility to send text files to a remote host via UDP, one UDP packet per line without the line break.

## Usage

    udpcat [options] [file1 file2 ...]
        -address="127.0.0.1:5555": The address of the target host

If no files are specified, input is read from stdin.

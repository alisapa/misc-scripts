# Misc Scripts

A collection of scripts and small programs that served some purpose, but do not warrant their own repository.

No promise of correctness. Some of these scripts were only needed once, and therefore not tested extensively. Only thing I can say is that it worked for me. Read comments inside scripts before proceeding.

## Descriptions

### recursive-iconv.sh

Used to convert a directory to a different encoding using `iconv`. Since `iconv` does not support in-place conversion (and perhaps you don't *want* to modify the files either), the script works by creating a second, differently-named directory whose subdirectories copy the structure of the first one. Text files are converted, non-text files are copied without change.

Usage example:
```bash
recursive-iconv.sh flop-original flop-converted cp866
```

### flop-original.tar.gz

Not a script. A set of files from a floppy disk containing a C++ tutorial (in Russian). Encoding is CP866. Kept only for historic reference, is not much use without the corresponding book, which I do not have.

### flop-converted.tar.gz

Not a script. Same files as `flop-original.tar.gz`, but converted from CP866 to UTF-8 using `recursive-iconv.sh`. 

### vimclip

Creates a temporary file (optionally copying the contents of an existing file into it), opens it in Vim for editing, then copies the result to the clipboard and deletes the temporary file.

Usage examples:
```sh
vimclip
vimclip example.txt
```

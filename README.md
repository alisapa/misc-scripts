# Misc Proglets

A collection of scripts and small programs that served some purpose, but do not warrant their own repository.

No promise of correctness. Some of these scripts were only needed once, and therefore not tested extensively. Only thing I can say is that it worked for me. Read comments inside scripts before proceeding.

## Descriptions

### recursive-iconv.sh

Used to convert a directory to a different encoding using `iconv`. Since `iconv` does not support in-place conversion (and perhaps you don't *want* to modify the files either), the script works by creating a second, differently-named directory whose subdirectories copy the structure of the first one. Text files are converted, non-text files are copied without change.

Usage example:
```bash
recursive-iconv.sh flop flop-converted cp866
```

### flop-converted.tar.gz

Not a script. A set of files from a floppy disk containing a C++ tutorial (in Russian), converted from CP866 to UTF-8 using `recursive-iconv.sh`. Kept only for historic reference, is not much use without the corresponding book, which I do not have.

Boonleng's Shell Script Library
===============================

Over the years, I have written some functions to help making coding easier. I have used to in many servers so I thought it might be a good idea to collect these functions into a big script so I can just source this and have all the functions available without a bunch of copy and paste.


boonlib.sh
----------
This is a collection of BASH functions, mostly for handling some form of automation for `cron` jobs.

Some global variables for general purposes:
- `LOGFILE` for logging.

A collection of convenient functions:
- `log()` logs an entry.
- `slog()` logs an entry with short timestamp.
- `num2str3()` converts a string to a 3-digit groups with comma.
- `file_manager()` frees up space or limits the usage until the targeted number is achieved.
- `remove_files_but_keep()` removes all files in a folder but keep the last `N` files.
- `remove_folders_but_keep()` removes all folders in a folder but keep the last N files.
- `remove_empty_dir()` removes empty directories
- `warn_if_low()` generates a warning message if it is running low in space
- `check_process()` checks for processes using ps and grep
- `fecho()` fills the 78th character in that line with |
- `textout()` prints out the text with color
- `headtail()` shows the head and tail portions of a file list of a folder
- `remove_minutes_old_files()` removes files older than `N` minutes.


makeramdisk.sh
--------------
A script that uses a Mac OS X built-in functions create a RAM disk.


mount_anastasia.sh
------------------
This script uses `sshfs` to mount a LAN machine that can be reached with .local addressing. Example usage is `mount_anastasia.sh deepsky` to mount the root drive with partition name `deepsky` of the machine `deepsky.local`. This naming scheme is what I usually practice. Why Anastasia? Anastasia is the main host of PX-10,000 which I use SSHFS the most.


ncdc.sh
-------
A script to use `wget` to download all the `.gz` files in a URL. This was specifically developed for downloading multiple Level-II files from an NCDC download link. It is set up to traverse two levels down so files with URL `http://.../HASXXXX/0001/XXX_V06.gz`, `http://.../HASXXXX/0002/XXX_V06.gz`, etc. will be all be downloaded simply by providing the top level link received in the email. All files will be downloaded in `~/Downloads/HAS000000000/` where the the last path component represents the order number.


rmtags.sh
---------
A command line to remove extra attributes, which can be seen using `ls -l@`. Some annoying tags like com.apple.quarantine will be removed using this utility.


tconfig.sh
----------
A collection of SSH tunnel set up parameters for pulling reverse tunnel connections that have been established through starbuck.nwc.ou.edu or any servers.


wake.sh
-------
Wake up a machine in LAN.


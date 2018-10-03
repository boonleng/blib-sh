blib-sh Boonleng's Shell Script Library
===

Over the years, I have written some functions to help making coding easier. I have used them in many servers so I thought it might be a good idea to collect these functions into a collection so I can just source this and have all the functions available without a bunch of copy and paste. Maybe it can help someone too.


# blib.sh

This is a collection of BASH functions, mostly for handling some form of automation for time-scheduled jobs. Here is a summary of the functions within the collection:

- `log()`
- `slog()`
- `num2str3()`
- `file_manager()`
- `remove_files_but_keep()`
- `remove_folders_but_keep()`
- `remove_minutes_old_files()`
- `remove_empty_dir()`
- `warn_if_low()`
- `check_process()`
- `fecho()`
- `textout()`
- `headtail()`
- `remove_minutes_old_files()`
- `mount_host()`
- `check_path()`
- `remove_old_logs()`

[More on blib.sh](#more-on-blibsh) ...

### Requirements

SSHFS requires that FUSE framework and SSHFS tool are installed. On a Mac, they can be installed through Homebrew as

```shell
brew cask install osxfuse
brew install sshfs
```

## Other Fun Shell Tools

These packages could make your shell experience more fun
- `fortune`
- `cowsay`
- `lolcat`


Detailed Description of blib-sh
===

256-color.sh
------------
A script that shows all the color codes for terminal.

makeramdisk.sh
--------------
A script that uses a Mac OS X built-in functions create a RAM disk.

#### Syntax:

	makeramdisk.sh SIZE [NAME]


mount_ntfs.sh
-------------
A simplified way to mount an remote NTFS path

#### Syntax:

    mount_ntfs.sh REMOTE_ADDRESS_AND_PATH
    
#### Example:

    mount_ntfs.sh 10.203.1.100:/D

mounts the shared folder D on the machine 10.203.1.100 to /Volumes/ntfs


mount_host.sh
-------------
This script uses `sshfs` to mount a LAN machine that can be reached with .local addressing. Example usage is `mount_anastasia.sh deepsky` to mount the root drive with partition name `deepsky` of the machine `deepsky.local`. This naming scheme is what I usually practice. Why Anastasia? Anastasia is the main host of PX-10,000 which I use SSHFS the most.

#### Syntax:

	mount_host.sh [COMPUTER_NAME]


ncdc.sh
-------
A script to use `wget` to download all the Level II `.gz` files in a URL, which came with the email that is sent out when the ordere from the NCDC archive is ready. This was specifically developed for downloading multiple Level-II files but it may work for other products. It is set up to traverse two levels down so files with URL `http://.../HASXXXX/0001/XXX_V06.gz`, `http://.../HASXXXX/0002/XXX_V06.gz`, etc. will be all be downloaded simply by providing the top level link received in the email. All files will be downloaded in `~/Downloads/HAS000000000/` where the the last path component represents the order number. If the destination folder exists, the script will not overwrite it but quit.

#### Syntax:

	ncdc.sh URL


rmtags.sh
---------
A command line to remove extra attributes, which can be seen using `ls -l@`. Some annoying tags like com.apple.quarantine will be removed using this utility.

#### Syntax:

	rmtags.sh FILES


rtun.sh
-------
Reverse tunnel creation through NWC's Bastian host. I almost don't want to document this. Don't use this directly. Read it, understand it and modify it for your own usage.


tconfig.sh
----------
A collection of SSH tunnel set up parameters for pulling reverse tunnel connections that have been established through starbuck.nwc.ou.edu or any servers.


wake.sh
-------
Wake up a machine in LAN. This is a convenient function to wake up several computers by name. It may not work for you.

#### Syntax:

	wake.sh COMPUTER_NAME


More on blib.sh
===============

Some global variables for general purposes:
- `LOGFILE` for logging.
- `VERBOSE` for printing out more information on screen
- `LOG_DATE_FORMAT` for short (1) or long (2) format time stamp

A collection of convenient functions:
- [`log()`](#log)
- [`slog()`](#slog)
- [`num2str3()`](#num2str)
- [`file_manager()`](#file_manager)
- [`remove_files_but_keep()`](#remove_files_but_keep)
- [`remove_folders_but_keep()`](#remove_folders_but_keep)
- [`remove_minutes_old_files()`](#remove_minutes_old_files)
- [`remove_empty_dir()`](#remove_empty_dir)
- [`warn_if_low()`](#warn_if_low)
- [`check_process()`](#check_process)
- [`fecho()`](#fecho)
- [`textout()`](#textout)
- [`headtail()`](#headtail)
- [`remove_minutes_old_files()`](#remove_minutes_old_files)
- [`mount_host()`](#mount_host)
- [`check_path()`](#check_path)
- [`remove_old_logs()`](#remove_old_logs)


### Examples
Some functions are better explained with examples so here they are:

#### `log()`
logs an entry with timestamp.

##### Syntax:

	log MESSAGE

##### Example:

	log "Hello World."

logs an entry

	1/28 02:49:29 PM : Hello World.
	
in the logfile, which is described by the global variable `LOGFILE`.
	
#### `slog()`
logs an entry with short timestamp. This is aimed for log files that are named by day so there is no need to put a date in each log entry.

##### Syntax:

	slog MESSAGE

##### Example:

	slog "All done."
	
logs an entry

	02:49 : All done.

in the logfile.
	
#### `file_manager()`
frees up space or limits the usage until the targeted number is achieved.

##### Syntax:

	file_manager MODE FOLDER SIZE

##### Examples:

	file_manager LIMIT ${HOME}/figs 1024*1024*1024
	file_manager FREE ${HOME}/data 1024*1024*1024
	
where the first line limits usage of the folder to 1 GB; while the second line ensures the free space of the partition where the folder belongs to is at least 1 GB.
	
#### `remove_files_but_keep()`
removes all files in a folder but keep the last specified number of files.

##### Syntax:

	remove_files_but_keep FOLDER COUNT PATTERN

##### Example:

	remove_files_but_keep "${HOME}/logs/drive_clean" 30 '*.log'
	
removes all files under the subfolder logs/drive_clean under home folder, which that match the file pattern that ends with "log" but keep the last 30.

	
#### `remove_folders_but_keep()`
removes all sub-folders in a folder but keep the specified number of sub-folders, which is determined by pre-sorting the list alphabetically.

##### Syntax:

	remove_folders_but_keep FOLDER COUNT [PATTERN]
	
where the file pattern is assumed to be * if not supplied.
	
##### Example:

	remove_folders_but_keep "${HOME}/data" 5 '20[0-9][0-9]*'

removes all sub-folders that match the naming pattern begins with 2000 - 2099 but keep the last 5.

#### `remove_minutes_old_files()`
removes files older than the specified age in minutes.


##### Syntax:

	remove_minutes_old_files FOLDER COUNT [PATTERN]
	
where the file pattern is assumed to be anything if not supplied.

##### Example:

	remove_minutes_old_files "${HOME}/px1000" 720 'PX*.tgz'
	
removes all files (up to level-2 deep) that are older than 720 minutes and satisfy the name pattern which begins with "PX" and ends with "tgz".


#### `remove_empty_folders()`
removes empty folders

##### Syntax:

	remove_empty_folders FOLDER

##### Example:

	remove_empty_folders "${HOME}/data"
	
removes all sub-folders that are empty. Note that hidden files that begin with ".", e.g., ".DS_Store", can prevent this function from removing the folders.


#### `warn_if_low()`
produces a message if the partition (of where the folder belongs to) is less than the test size.

##### Syntax:

	warn_if_low FOLDER SIZE

##### Example:

	warn_if_low "${HOME}/data" 5*1024*1024*1024
	
produces a message

	Available: 4.9 GB < 5 GB
	
when the remaining space is 4.9 GB, which is less than the specified test size. Otherwise, nothing happens. This can be used in a script and scheduled as a cron job to notify the admin when the free space is too little.


#### `check_process()`
checks for processes using ps and grep

##### Syntax:

	check_process PROCESS_1 PROCESS_2 PROCESS_3 ...

##### Example:

	check_process rpcd rcc lcc trxd trigd

produces output

```shell
Processes                                                                     |
=========                                                                     |
RUSER      PID STAT %CPU %MEM NLWP COMMAND                                    |
boonleng 32327 Sl    0.1  0.0    2 iqc                                        |
boonleng 32330 Sl    0.1  0.0    4 iqd                                        |
boonleng 32333 Sl    0.0  0.0    3 rcc                                        |
```

#### `textout()`
prints out the piped-in text with color and title

##### Syntax:

	textout TITLE [COLOR]

##### Example:

	tail -n 5 ${LOG} | textout RCC green

produces output

```shell
RCC                                                                           |
===                                                                           |
12:24:39 : [RCC]       00 <Kate>: 108-'l' (1)                                 |
12:24:39 : [RCC]    From RCC/LCC: ACK. LCC connected.                         |
12:24:39 : [RCC] LCC connected.                                               |
12:24:58 : [RCC]       00 <Kate>: Hangging up...  ST:Inactive                 |
```

#### `headtail()`
shows the head and tail portions of a file list of a folder

##### Syntax:

	headtail FOLDER [COLOR]

##### Example:

	headtail ~/Downloads
	
produces

```shell
/Users/boonleng/Downloads (      16 --> 59G)                                  |
============================================                                  |
drwx------    3 boonleng  staff   102B Apr 16  2014 About Downloads.lpdf      |
-rw-r--r--    1 boonleng  staff   1.1M Nov 25  2013 Scans.pdf                 |
-rw-r--r--    1 boonleng  staff   885M Nov 30  2014 simradar.mp4              |
:                                                                             |
-rw-r--r--    1 boonleng  staff    33K Nov 17 22:03 nvrambak.bin              |
-rw-r--r--    1 boonleng  staff   621K Nov  8 09:51 opencl-1-2-quick-reference|
drwxr-xr-x    7 boonleng  staff   238B Nov 25 21:22 tables                    |
```
	
#### `remove_minutes_old_files()`
removes files in a folder that are older than a specified age in minutes and match a given pattern.

##### Syntax:

    remove_minutes_old_files DIR MINUTES [PATTERN]
    
where PATTERN is assumed to be `*.tgz` if not supplied.

##### Example:

    remove_minutes_old_files /home/ldm/data 86400 *.nc
    
#### `mount_host()`
mount the host using SSHFS

##### Syntax:

    mount_host HOST_NAME

##### Examples:

    mount_host anastasia
    mount_host cerulean.local
    mount_host 10.203.6.227

#### `check_path()`
checks if the path exist

##### Syntax:

    check_path PATH

##### Example:

    check_path /Volumes/Data

#### `remove_old_logs()`

remove old log files that are in the patterns of:

```shell
cleanup-20171124.log
cleanup-20171125.log
cleanup-20171126.log
...
stitch-figure-20171124.log
stitch-figure-20171125.log
stitch-figure-20171126.log
...
```

##### Syntax:

    remove_old_logs LOG_PATH [FILES_TO_KEEP]
    
where FILES_TO_KEEP is assumed to be 7 if not supplied.

##### Example:

    remove_old_logs ${HOME}/logs 30

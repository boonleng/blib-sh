Boonleng's Shell Script Library
===============================

Over the years, I have written some functions to help making coding easier. I have used to in many servers so I thought it might be a good idea to collect these functions into a big script so I can just source this and have all the functions available without a bunch of copy and paste.


boonlib.sh
----------
This is a collection of BASH functions, mostly for handling some form of automation for time-scheduled jobs. Here is a summary of the functions within the collection:

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

[More on boonlib.sh][#more-on-boonlibsh] ...


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


More on boonlib.sh
==================

Some global variables for general purposes:
- `LOGFILE` for logging.

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

	Processes                                                                     |
	=========                                                                     |
	RUSER      PID STAT %CPU %MEM NLWP COMMAND                                    |
	boonleng 32327 Sl    0.1  0.0    2 iqc                                        |
	boonleng 32330 Sl    0.1  0.0    4 iqd                                        |
	boonleng 32333 Sl    0.0  0.0    3 rcc                                        |

#### `textout()`
prints out the piped-in text with color and title

##### Syntax:

	textout TITLE [COLOR]

##### Example:

	tail -n 5 ${LOG} | textout RCC green

produces output

	RCC                                                                           |
	===                                                                           |
	12:24:39 : [RCC]       00 <Kate>: 108-'l' (1)                                 |
	12:24:39 : [RCC]    From RCC/LCC: ACK. LCC connected.                         |
	12:24:39 : [RCC] LCC connected.                                               |
	12:24:58 : [RCC]       00 <Kate>: Hangging up...  ST:Inactive                 |

#### `headtail()`
shows the head and tail portions of a file list of a folder

##### Syntax:

	headtail FOLDER [COLOR]

##### Example:

	headtail ~/Downloads
	
produces

	/Users/boonleng/Downloads (      16 --> 59G)                                  |
	============================================                                  |
	drwx------    3 boonleng  staff   102B Apr 16  2014 About Downloads.lpdf      |
	-rw-r--r--    1 boonleng  staff   1.1M Nov 25  2013 Scans.pdf                 |
	-rw-r--r--    1 boonleng  staff   885M Nov 30  2014 simradar.mp4              |
	:                                                                             |
	-rw-r--r--    1 boonleng  staff    33K Nov 17 22:03 nvrambak.bin              |
	-rw-r--r--    1 boonleng  staff   621K Nov  8 09:51 opencl-1-2-quick-reference|
	drwxr-xr-x    7 boonleng  staff   238B Nov 25 21:22 tables                    |



[boonlib]: #boonlib

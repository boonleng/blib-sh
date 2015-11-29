Boonleng's Shell Script Library
===============================

Over the years, I have written some functions to help making coding easier. I have used to in many servers so I thought it might be a good idea to collect these functions into a big script so I can just source this and have all the functions available without a bunch of copy and paste.


boonlib.sh
----------
This is a collection of BASH functions, mostly for handling some form of automation for `cron` jobs.

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
logs an entry.

	log MESSAGE

	log "Hello"

logs an entry

	1/28 02:49:29 PM : Hello
	
in the logfile described by the global variable `${LOGFILE}`.
	
#### `slog()`
logs an entry with short timestamp.

	slog MESSAGE

	slog "Hello"`
	
logs an entry

	02:49 : Hello

in the logfile described by the global variable `${LOGFILE}`.
	
#### `file_manager()`
frees up space or limits the usage until the targeted number is achieved.

	file_manager MODE FOLDER TARGET_SIZE

	file_manager LIMIT ${HOME}/data 1024*1024*1024
	file_manager FREE ${HOME}/data 1024*1024*1024
	
where the first line limits usage of `${HOME}/data` to 1 GB; while the second line ensures the free space of the partition where `${HOME}/data` belongs to is 1 GB.
	
#### `remove_files_but_keep()`
removes all files in a folder but keep the last `N` files.

	remove_files_but_keep FOLDER COUNT PATTERN

	remove_files_but_keep "${HOME}/logs/drive_clean" 30 '*.log'
	
removes all files under the folder `${HOME}/logs/drive_clean` but keep the last 30.
	
#### `remove_folders_but_keep()`
removes all folders in a folder but keep the last `N` files.

	`remove_folders_but_keep` FOLDER COUNT PATTERN
	
	remove_folders_but_keep "${HOME}/data" 5 '20[0-9][0-9]*'

removes all folders under the folder `${HOME}/data` but keep the last 5.

#### `remove_minutes_old_files()`
removes files older than `N` minutes.

	remove_minutes_old_files FOLDER COUNT PATTERN
	
	remove_minutes_old_files "${HOME}/px1000" 720 'PX*.tgz'
	
removes all files (up to level-2 deep) that are older than 720 minutes and satisfy the name pattern of `PX*.tgz`.

#### `remove_empty_folders()`
removes empty folders

	remove_empty_folders FOLDER

	remove_empty_folders "${HOME}/data"
	
removes all empty folders under the folder `${HOME}/data`.

#### `warn_if_low()`
produces a message if the partition (of where the folder belongs to) is less than the test size.

	warn_if_low "${HOME}/data" 5*1024*1024*1024
	
produces a message `Available: 4.9 GB < 5 GB` when the remaining space is 4.9 GB, which is less than the test size. Otherwise, nothing happens. This can be scheduled on as a cron job to notify the admin when the free space is too little.

#### `check_process()`
checks for processes using ps and grep

	check_process PROCESS_1 PROCESS_2 PROCESS_3 ...

	check_process rpcd rcc lcc trxd trigd

produces output

	Processes                                                                     |
	=========                                                                     |
	RUSER      PID STAT %CPU %MEM NLWP COMMAND                                    |
	boonleng 32327 Sl    0.1  0.0    2 iqc                                        |
	boonleng 32330 Sl    0.1  0.0    4 iqd                                        |
	boonleng 32333 Sl    0.0  0.0    3 rcc                                        |

#### `textout()`
prints out the text with color and title

	textout TITLE [COLOR]

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

	headtail FOLDER [COLOR]

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


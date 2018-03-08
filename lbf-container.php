<?php
/**
 * LBF Container
 * Created by Alexander Celeste, alex@tenseg.net
 * March 2018
 * 
 * This script takes input of the current working directory and your home directory, and will output
 * associated Docker comntainer ID for the Loocal by Flywheel site that the current working directory is part
 * of.
 * 
 * It loops over Local by Flywheel's sites.json file and returns the container ID for the folder you passed
 * in. Written in PHP because I was more comfortable working with JSON in PHP than Bash.
 * 
 * Intended for use with lbf.sh.
 */

// get the current working directory of where the script was called from
$cwd = $argv[1];

// get all local site settings
$local_sites = json_decode(file_get_contents($argv[2] . "/Library/Application Support/Local by Flywheel/sites.json"), true);

// loop all sites and create map to ids
foreach($local_sites as $site) {
	if (strpos($cwd, $site["path"]) !== false) {
		echo $site["container"];
		return;
	}
}
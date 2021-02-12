<?php
/**
 * LBF Container
 * Created by Alexander Celeste, alex@tenseg.net
 * March 2018
 *
 * This script takes input of the current working directory and your home directory, and will output
 * associated Docker comntainer ID for the Local by Flywheel site that the current working directory is part
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
$local_sites = json_decode( file_get_contents( $argv[2] . '/Library/Application Support/Local/sites.json' ), true );
$return = $argv[3];

// recurse through directories looking for container
function find_container( $path, $site ) {
	global $return;

	$path_parts = pathinfo( $path );
	if ( $path_parts['dirname'] == $site['path'] ) {
		return $site[$return];
	} elseif ( '/' != $path_parts['dirname'] ) {
		return find_container( $path_parts['dirname'], $site );
	} else {
		return null;
	}
}

// loop all sites and create map to ids
foreach ( $local_sites as $id => $site ) {
	$container = find_container( "$cwd/trick", $site );
	if ( $container ) {
		echo $container;
		return;
	}
}

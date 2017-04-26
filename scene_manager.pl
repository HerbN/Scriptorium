#!/usr/bin/env perl
#===========================================================================
#
#         FILE: scene_manager.pl
#
#        USAGE: ./scene_manager.pl  
#
#  DESCRIPTION: Scene manager provides tools to gather scene statistics from
#               my standard writing setup 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Herbert Nowell (hhn), herb@herbertnowell.com
# ORGANIZATION: Tribe of Tiger
#      VERSION: 1.0
#      CREATED: 04/19/17 13:11:27
#     REVISION: ---
#===========================================================================

use strict;
use warnings;
use utf8;

use YAML::Syck;

## Load the outline file

my $outline = YAML::Syck::LoadFile( 'outline.yml' );

## We have three lists of scenes:
#  1. The outline file's master list
#  2. The outline file's ordered list
#  2. The actual list of scene files in the scene subdirectory

## Get the first list
my %outlined_scenes = %{$$outline{'Scene List'}};
my @outlined_scenes = keys %outlined_scenes;

## Get the second list and add ones not present in the master
## list to the master list and add those to the report
my @scheduled_scenes;
my @added_from_schedule;
my %ordered_list = %{$$outline{'Scene Order'}};

for my $scene_num ( keys %ordered_list )
{
    my $scene_name = $ordered_list{$scene_num};
    $scheduled_scenes[$scene_num] = $scene_name;
    ## A scheduled scene not in the master list should be added
    ## with status of needed
    unless ($outlined_scenes{$scene_name})
    {
        $outlined_scenes{$scene_name} = "needed";
        push @added_from_schedule, $scene_name;
    }
}

## Scene files are files in the scene directory with the extention .txt
my @written_scenes;
my @added_from_dir;

for my $scene_name ( <scenes/*.txt> )
{
    $scene_name =~ s/scenes.(.*).txt/$1/;
    push @written_scenes, $scene_name;

    ## Add scene if not in master list
    unless ( $outlined_scenes{$scene_name} )
    {
        $outlined_scenes{$scene_name} = "started";
        print "Added $scene_name\n";
    }

    ## If scene is listed as 'needed' upgrade to 'started'
    if ( $outlined_scenes{$scene_name} eq 'needed' )
    {
        $outlined_scenes{$scene_name} = "started";
    }
}

## Put the revised master list into the outline
$$outline{'Scene List'} = \%outlined_scenes;

## Write the updated outline file
YAML::Syck::DumpFile( 'outline.yml', $outline );

## TODO: Print a report of scenes added (and from where), scenes not scheduled, scene numbers not used, and scenes grouped by status

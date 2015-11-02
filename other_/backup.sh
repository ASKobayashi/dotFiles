#!/usr/bin/env bash

BACKUP_HOST=backup
BACKUP_DIRS=(
	~/production
	~/work
)

EXCLUDE_FILES=(
	*.pyc
	.DSStore
)

EXCLUDE_SWITCHES=""
for exclude in "${EXCLUDE_FILES[@]}"
do
	EXCLUDE_SWITCHES="$EXCLUDE_SWITCHES --exclude=$exclude"
done

for dir in "${BACKUP_DIRS[@]}"
do
	# Enforce dir exists
	BACKUP_DIR="/media/backup/`hostname`/$dir"
	ssh backup mkdir -p "$BACKUP_DIR"
	cmd="`which rsync` -azh --info=stats1,progress2  $EXCLUDE_SWITCHES $dir/ $BACKUP_HOST:$BACKUP_DIR"
	eval $cmd
done

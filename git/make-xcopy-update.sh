#!/bin/sh

# Extracts files from listed commits in Update_DATE dir
# If <commit-id> is omitted then HEAD commit used
# Usage: makeupdate.sh [<commit-id> ...]

function copy_files()
{
	git diff-tree --root --name-only -r --no-commit-id "$1" | \
		while read ln; \
		do cp -f --parents $ln "$outdir/"; \
		done
}

function from_last_commit()
{
	local last_id=`git log -n 1 --format="%H"`
	copy_files $last_id
}

function from_many_commits()
{
	git show -s --format="%ct %H" $@ | sort | \
		cut -d ' ' -f 2 | \
		while read commit ; \
		do copy_files $commit; \
		done
}

outdir="Update_`date +%Y%m%d`"
if [ ! \( -e $outdir -a -d $outdir \) ]; then
	mkdir $outdir
fi

if [ $# -lt 1 ]; then
	from_last_commit
else
	from_many_commits $@
fi

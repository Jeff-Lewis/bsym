#!/bin/zsh

REPORTTIME=-1

if test "$#" -lt 2; then
	cat <<EOF
Usage: ${0##*/} SUBMISSION.txt BBGID-RESULT.txt.gz
EOF
fi

while test "$#" -ge 2; do
	REPORTTIME=-1
	SUB="${1}"
	RES="${2}"

	shift 2
	join -t'	' -j1 \
		<(bsdcat "${SUB}" | awk 'BEGIN{FS="|"; OFS="\t"}{print NR, $1, $2, $3}' | sort -t'	') \
		<(bsdcat "${RES}" | grep -vF '|N.A.' | tr '|' '\t' | sort -t'	') \
		| awk 'BEGIN {
	FS = OFS = "\t";
}
{
	bbgid = $8;
	bbcid = $9;
	ticker = $6;
	prcsrc = $7;
	sector = $12;
	sectyp = $11;
	secdes = $5;

	print $2, $3, $4, bbgid, bbcid, ticker, prcsrc, sector, sectyp, secdes;
}'
done

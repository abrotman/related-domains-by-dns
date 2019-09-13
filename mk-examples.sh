#!/bin/bash

# set -x

# call make-zonefrags.sh for the various names used in the
# Internet-draft examples appendix.

RDIR="$HOME/code/rdbd-deebeedeerrr"
BIN="$RDIR/make-zonefrags.sh"

# places for things
export KEYDIR="sample/keys"
export ZFDIR="sample/zonefrags"

# make dirs if needed
mkdir -p $KEYDIR $ZFDIR

# generate keys for examples
$BIN -g --rsa -i my.example >>$ZFDIR/my.example.zone
$BIN -g -i my-way.example >>$ZFDIR/my-way.example.zone
# assert both are related (bidirectionally), with signatures
$BIN -s --rsa -i my.example -d my-way.example  >>$ZFDIR/my-way.example.zone
$BIN -s -i my-way.example -d my.example  >>$ZFDIR/my.example.zone
# a specific unsigned disavowal 
$BIN -t 0 -i my.example -d my-bad.example >>$ZFDIR/my.example.zone
# positive and negative URLs
$BIN -i my.example -d https://my-way.example/mystuff.json >>$ZFDIR/my.example.zone
$BIN -t 0 -i my.example -d https://my-way.example/notmystuff.json >>$ZFDIR/my.example.zone

# Now produce markdown for those for inclusion in draft...

echo "my.example zone file fragments:"
# start of ascii-art
echo "~~~"
echo ""
cat $ZFDIR/my.example.zone
echo ""
# end of ascii-art
echo "~~~"

echo "my.example private key:"
# cheating - I know the private key names:-)
# start of ascii-art
echo "~~~"
echo ""
cat "$KEYDIR/481b9a92af23bbbc8ae2e9732d246f270f7d8cef7626d5502c76c087d6bc8b36.priv"
echo ""
# end of ascii-art
echo "~~~"

echo "my-way.example zone file fragments:"
# start of ascii-art
echo "~~~"
echo ""
cat $ZFDIR/my-way.example.zone
echo ""
# end of ascii-art
echo "~~~"

echo "my-way.example private key:"
# cheating - I know the private key names:-)
# start of ascii-art
echo "~~~"
echo ""
od -x $KEYDIR/161e257a6c4b683af02d741d8900dd1f35c174074a1850f394c2fa4b3827b368.priv
echo ""
# end of ascii-art
echo "~~~"


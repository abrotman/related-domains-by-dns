#!/bin/bash

#set -x

# 
# Copyright (C) 2019 Stephen Farrell, stephen.farrell@cs.tcd.ie
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Make fresh examples for draft-brotman-rdbd

# We'll do the work in a TMP dir that we throw away

# bits'n'pieces
function whereami()
{
    # return the directory that contains this
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    echo $DIR
}
SRC=$(whereami)
function whenisitagain()
{
    date -u +%Y%m%d-%H%M%S
}
NOW=$(whenisitagain)

ORIG=`/bin/pwd`
TDIR=`mktemp -d /tmp/rdbd-examplesXXXX`
mkdir -p $TDIR
if [ ! -d $TDIR ]
then
    echo "$TDIR doesn't exist - exiting"
    exit 1
fi
cd $TDIR

# parameters
RELATING="my.example"
RELATED="my-way.example"
UNRELATED="my-bad.example"
URL="https://example.com/related-names"
NEGURL="https://example.com/unrelateds"
SECRET="rdbd-example0001rdbd-example0002"
B64WIDTH=48
# heredoc for JSON stuff
read -r -d '' POSJSON <<EOF
[
    "my-other.example",
    "my-buddy.example",
    "other-buddy.example.net"
]
EOF
read -r -d '' NEGJSON <<EOF
[
  "terrible.example",
  "moar-terrible.example",
  "awful.example"
]
EOF

# Unsigned, related and unrelated

# preamble
echo "# Examples"
echo ""
echo "This appendix provides examples of RDBD-related values."
echo "The following names and other values are used in these examples."
echo ""
echo "- Relating domain: $RELATING"
echo "- Related domain: $RELATED"
echo "- Unrelated domain: $UNRELATED"
echo "- URL for other related domains: $URL"
echo "- URL for other unrelaed domains: $NEGURL"
echo ""
echo "The github repo "
echo "https://github.com/abrotman/related-domains-by-dns "   
echo "has a script in sample/mk_samples.sh that generated this appendix."

echo ""
echo "## Unsigned Examples"
echo ""

echo "~~~ ascii-art"
echo ""
echo ";ZONE FILE FRAGMENT STARTS"
echo "; assertion that $RELATED claims to be related "
echo "; to $RELATING"
echo "$RELATED. IN 3600 RDBD 1 $RELATING." 
echo ""
echo "; assertion that $RELATED claims not to be "
echo "; related to $UNRELATED"
echo "$RELATED. IN 3600 RDBD 0 $UNRELATED." 
echo ""
echo "; assertion that $RELATED claims to be related "
echo "; to whatever is at $URL"
echo "$RELATED. IN 3600 RDBD 1 $URL" 
echo ""
echo "; assertion that $RELATED claims not to be "
echo "; related to whatever is at $URL"
echo "$RELATED. IN 3600 RDBD 0 $NEGURL" 
echo ""
echo ";ZONE FILE FRAGMENT ENDS"
echo ""

# end of ascii-art
echo "~~~"
echo ""


# RSA-signed

echo ""
echo "## RSA-signed Example"
echo ""

# generate key pair

echo "~~~ ascii-art"
echo ""
echo "# BASH SNIPPET STARTS"
echo "# HOWTO generate RSA key pair" 
echo "$ openssl genrsa -out rsa.private 2048"
echo "Generating RSA private key, 2048 bit long modulus (2 primes)"
echo ".....................+++++"
echo ".....................+++++"
echo "e is 65537 (0x010001)"
echo "writing RSA key"
echo "$ openssl rsa -in rsa.private -out rsa.public -pubout \\"
echo "     -outform PEM "
echo "$ cat rsa.private"
openssl genrsa -out rsa.private 2048 >/dev/null 2>&1
openssl rsa -in rsa.private -out rsa.public -pubout -outform PEM >/dev/null 2>&1
PUB=`cat rsa.public | awk '!/----/' | tr '\n' ' ' | sed -e 's/ //g'`
KEYID=`$SRC/keytag.py -a 8 -p $PUB`
cat rsa.private 
echo "$ cat rsa.public"
cat rsa.public
cat > to-be-signed-8.txt <<EOF
relating=$RELATING
related=$RELATED
rdbd-tag=1
key-tag=$KEYID
sig-alg=8
EOF
echo "# To-be-signed data for RSA"
echo "$ cat  to-be-signed-8.txt"
cat  to-be-signed-8.txt
echo "# Sign that"
echo "$ openssl dgst -sha256 -sign rsa.private -out rsa.sig \\"
echo "        to-be-signed-8.txt"
openssl dgst -sha256 -sign rsa.private -out rsa.sig to-be-signed-8.txt
echo "# Hexdump of signature"
echo "$ hexdump rsa.sig"
hexdump rsa.sig
echo "# BASH SNIPPET ENDS"
echo ""
echo "; ZONE FILE FRAGMENT STARTS"
echo "; The RDBDKEY RR for $RELATING is..."
echo "$RELATING. IN 3600 RDBDKEY 0 3 8 ("
b64pub=`base64 -w $B64WIDTH rsa.public  | sed -e 's/^/            /'` 
echo "$b64pub )"
echo "; The RDBD RR to be published by $RELATED is..."
echo "$RELATED. IN 3600 RDBD 1 $RELATING $KEYID 8 ("
b64sig=`base64 -w 48 rsa.sig  | sed -e 's/^/            /'` 
echo "$b64sig )"
echo "; ZONE FILE FRAGMENT ENDS"
echo ""
# end of ascii-art
echo "~~~"
echo ""

# Ed25519-signed
echo ""
echo "## Ed25519-signed Example"
echo ""

# generate key pair  - note: this is the same every time! 
# if you want something else edit the python code
$SRC/ed25519-signer.py -s $SECRET -r $RELATING -d $RELATED >signer.out
PUB=`base64 ed25519.pub`
KEYID=`$SRC/keytag.py -a 15 -p $PUB`
echo "~~~ ascii-art"
#echo "# To-be-signed data for Ed25519"
#echo "$ cat to-be-signed-15.txt"
#cat to-be-signed-15.txt
echo "# BASH SNIPPET STARTS"
echo "# HOWTO generate an Ed25519 key pair..."
echo "$ ./ed25519-signer.py -s $SECRET \\"
echo "   -r $RELATING -d $RELATED"
fold -w 60 signer.out
echo "# hex dump of Ed25519 private"
echo "$ hexdump ed25519.priv"
hexdump ed25519.priv
echo "# hex dump of Ed25519 public"
echo "$ hexdump ed25519.pub"
hexdump ed25519.pub
echo "# hex dump of Ed25519 signature"
echo "$ hexdump ed25519.sig"
hexdump ed25519.sig
b64sig=`base64 -w $B64WIDTH ed25519.sig  | sed -e 's/^/            /'` 
b64pub=`base64 -w $B64WIDTH ed25519.pub  | sed -e 's/^/            /'` 
echo "# BASH SNIPPET ENDS"
echo ""
echo "; ZONE FILE FRAGMENT STARTS"
echo "; The RDBDKEY RR for $RELATING is..."
echo "$RELATING. IN 3600 RDBDKEY 0 3 15 ("
echo "$b64pub ) "
echo "; The RDBD RR to be published by $RELATED is..."
echo "$RELATED. 3600 RDBD 0 $RELATING $KEYID 15 ("
echo "$b64sig ) "
echo "; ZONE FILE FRAGMENT ENDS"
echo ""
# end of ascii-art
echo "~~~"

# Sample JSON

# clean up
cd $ORIG
rm -rf $TDIR


%%%

   Title = "Related Domains By DNS"
   abbrev = "RDBD"
   category = "std"
   docName = "draft-brotman-rdbd-01"
   ipr = "trust200902"
   area = "Applications"
   keyword = [""]

   date = 2019-03-06T00:00:00Z
   
   [[author]]
   initials="A."
   surname="Brotman"
   fullname="Alex Brotman"
   organization="Comcast, Inc"
     [author.address]
     email="alex_brotman@comcast.com"

   [[author]]
   initials="S."
   surname="Farrell"
   fullname="Stephen Farrell"
   organization="Trinity College Dublin"
     [author.address]
     email="stephen.farrell@cs.tcd.ie"

%%%


.# Abstract

This document outlines a mechanism by which a registered domain can 
create a relationship to a different registered domain, called 
"Related Domains By DNS", or "RDBD".

{mainmatter}

# Introduction

[[Discussion of this draft is taking place on the dbound@ietf.org mailing list.
There's a github repo for this draft -- 
issues and PRs are welcome there. 
https://github.com/abrotman/related-domains-by-dns]]

Determining relationships between registered domains can be one of the more difficult
investigations on the Internet.  It is typical to see something such as 
`example.com` and `dept-example.com` and be unsure if there is an actual
relationship between those two domains, or if one might be an attacker 
attempting to impersonate the other.  In some cases, anecdotal evidence from places
such as DNS or WHOIS/RDAP may suffice.  However, service providers of various
kinds may err on the side of caution and mark the secondary domain being 
untrustworthy or abusive because it is not clear that they are in 
fact related. Another possible use case could be where a company
has two websites in different languages, and would like to correlate
their ownership more easily, consider `example.at` and `example.de`
registered by regional offices of the same company.  A third example could
be an acquisition where both domains continue to operate.
A final example is when doing Internet surveys, we may be able to provide
more accurate results if we have information as to which domains are related.

It is not a goal of this specification to provide a high-level of
assurance that two domains are definitely related, nor to provide
fine-grained detail of the kind of relationship. 

Using "Related Domains By DNS", or "RDBD", it is possible to
indicate that the secondary domain is related to the primary domain.
This mechanism is modelled on how DKIM [@?RFC6376] handles public
keys and signatures - a public key is hosted at the parent domain
(`example.com`) and a reference from the secondary domain 
(`dept-example.com`) contains a signature (verifiable with
the `example.com` public key) over the text representation ('A-label') of 
the primmary and secondary domain names.

RDBD is intended to demonstrate a relationship between registered
domains, not individual hostnames.  That is to say that the
relationship should exist between `example.com` and `dept-example.com`,
not `foo.example.com` and `bar.dept-example.com`.

There already exists Vouch By Reference (VBR) [@?RFC5518], however
this only applies to email.  RDBD could be a more general purpose solution
that could be applied to other use cases, as well as for SMTP transactions.

This document describes the various options, how to
create records, and the method of validation, if the option to 
use digital signatures is used.

## Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and
"OPTIONAL" in this document are to be interpreted as described in
[RFC2119].

The following terms are used throughout this document:

* Relating domain: this refers to the domain that is 
declarating a relationship exists. (This was called the
"parent/primary" in -00). 
   
* Related domain: This refers to the domain that is
referenced by the relating domain, such as `dept-example.com`.
(This was called the "secondary" in -00.)

# New Resource Record Types

We define two new RRTYPES, an optional one for the relating domain (RDNDKEY)
to store a public key for when signatures are in use and one for use in 
related domains (RDBD).


## RDBDKEY Resource Record Definition

The wire and presentation format of the RDBDKEY 
resource record is identical to the DNSKEY record.  

[[All going well, at some point we'll be able to say...]]
IANA has allocated RR code TBD for the RDBDKEY resource record via Expert
Review.  

The RDBDKEY RR uses the same registries as DNSKEY for its
fields. (This follows the precedent set for CDNSKEY in [@?RFC7344].)

No special processing is performed by authoritative servers or by
resolvers, when serving or resolving.  For all practical purposes,
RDBDKEY is a regular RR type.

## RDBD Resource Record Definition

The RDND resource record is published at the apex of the related 
domain zone.

[[All going well, at some point we'll be able to say...]]
IANA has allocated RR code TBD for the RDBD resource record via Expert
Review.  

The RDBD RR is class independent.

The RDBD RR has no special Time to Live (TTL) requirements.

The wire format for an RDBD RDATA consists of a two octet tag, a two-octet
key-tag, a one-octet signature algorithm,k the relating domain name length and
value and an optional digital signature.

~~~ ascii-art
                        1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |           rdbd-tag            |             key-tag           |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--+-+|
   |    sig-alg    |     name-len  |    relating-domain-name       |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--+-+|
   /                            signature                          /
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~~~

The rbddtag field MUST contain the value zero. Later specifications
can define new rdbd-tag values. [[Add IANA considerations for that.]]

If the optional signature is omitted, the key-tag and sig-alg fields 
MUST be zero.
If an optional signture is included, the sig-alg field MUST contain
the signature algorithm used, with the same values used as would be
used in an RRSIG. The key-tag MUST match the RDBDKEY RR value for
the corresponding public key.

The name-len field contains the length of the relating domain name.

The input to signing is the catenation of the following LF-separated lines:

            relating=<relating domain>
            related=<related domain>
            rdbd-tag=<rdnd-tag value>
            key-tag=<key-tag>
            sig-alg=<sig-alg>

See the example in the Appendix for details.

[[Presentation syntax and to-be-signed details are liable to change
so aren't yet fully documented.]]

# Directionality and Cardinality

RDBD relationships are uni-directional. If bi-directional relationships
exist, then both domains can publish RDBD RRs and optionally sign those.

If one domain has relationships with many others, then the relevant
RDND RRs (and RDBDKEY RRs) can be published to represent those.

# Required Signature Algorithms

Implementations of this specification MUST support use of RSA with
SHA256 (sig-alg==8) with at least 2048 bit RSA keys. [@?RFC5702]

Implementations of this specification SHOULD support use of Ed25519 
(sig-alg==15). [@?RFC8080]

# Validation 

A validated signature is solely meant to be evidence that the two domains 
are related.  The existence of this relationship is not meant to 
state that the data from either domain should be considered as more trustworthy.  

# Security Considerations

## DNSSEC

RDBD does not require DNSSEC. It could be possible for an
attacker to falsify DNS query responses for someone investigating a
relationship. 
Conversely, an attacker could delete the response that would
normally demonstrate the relationship, causing the investigating party to
believe there is no link between the two domains.

Deploying signed records with DNSSEC should allow for detection
of either attack.

If the relating domain has DNSSEC deployed, but the related domain
does not, then the optional signature can (in a sense) extend the
DNSSEC chain to cover the RDND RR in the related domain's zone.

## Lookup Loops

It's conceivable that an attacker could create a loop of lookups, such as
a.com->b.com->c.com->a.com or similar.  This could cause a resource issue
for any automated system.  A system SHOULD only perform three lookups from
the original domain (a.com->b.com->c.com->d.com).  The related and relating
domains SHOULD attempt to keep links direct and so that only a single lookup
is needed, but
it is understood this may not always be possible.

# IANA Considerations

This document uses two new DNS RR types, RDBD and RDNDKEY.  Not yet allocated by IANA.

New rdbd-tag value handling needs to be defined. [[Maybe something
like: 0-255: RFC required; 256-1023: reserved; 1024-2047: Private
use; 2048-65535: FCFS.]]

# Acknowledgements

[[TBD - add folks who've chimed in since the -00 published.]]

{backmatter}

# Creating a Signature for the Related Domain

Appendix C of [@!RFC6376] has some reference material on 
how to create a set of keys for use in this type of use case. The RSA key
length is recommended to be at least 2048 bits instead of the 1024 
recommended in that appendix.

## Sample RSA Signature

Creation of keys:

~~~ ascii-art
$ openssl genrsa -out rsa.private 2048
$ openssl rsa -in rsa.private -out rsa.public -pubout -outform PEM
~~~

Sample Key:

~~~ ascii-art
rsa.private:
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA2LNjBAdNAtZOMdd3hlemZF8a0onOcEo5g1KWnKzryDCfH4LZ
kXOPzAJvz4yKMHW5ykOz9OzGL01GMl8ns8Ly9ztBXc4obY5wnQpl4nbvOdf6vyLy
7Gqgp+dj6RrycSYJdLitiYapHwRyuKmERlQL6MDWLU9ZSWlqskzLVPgwqtT80xch
U65HipKkr2luSAySZyyNEf58pRea3D3pBkLy5hCDhr2+6GF2q9lJ9qMopd2P/ZXx
Hkvzl3TFtX6GjP5LTsb2dy3tED7vbf/EyQfVwrs4495a8OUkOBy7V4YkgKbFYSSk
GPmhWoPbV7hCQjEAURWLM9J7EUou3U1WIqTj1QIDAQABAoIBAH/eAgwrfq6w4/0X
Bgk4iQ9q6vnWpQCvW5Z40jRq+MnsnshKPrVL+krIGU/fvt7vaIzIPFTGrf7VWxl3
+oZg/1sRFPYUItjaluqjaxEhWvHH1saYCb2lAV1x9QtkgjBv4F6GZqfi1MJfro32
QP36s/hIaVjdHHNsB7BkDgr6VEVIR5y2PmW4aLjHCiqsyDIUM4zRcl4exzw+rst1
z2seOhhJrnYdc+VnkEg5GKENldZ3tZoY3je/OsfNJtKjpArPRqkP1qve3h3uD+PK
obZ7BM+xok29Fxf6AgC99eDr9BatTa/a8q7NYMkVRLq/JdOF1XUuDDNd3r93Ae4n
54qqucECgYEA/Xuct8ALG2/6Kd4Lmm9i055LVxdwB+1wG1JNE1IB+OI+6B8W49po
vK/fFVHMEV2BoRr4EB58Xxa+oICBImIzTUQXYQnMbDzL2N+X3FrkDSGCPZQy7GzD
wFdpY3ceNShou1bRt4/hPWLLI35ZXM3yqBJeGhbTUmYVdWrkXTNo2wUCgYEA2tpE
+bg9iIYUJAg/CEpdWn+8ZxhRnBDziN88Grli+arSWaMWE809GyPaeiplbwywnXRb
vliskE43CcgstnhRKY8dWB2AQnRESvsJKO8rw/ONSxlWTpFc78xxmmNSvOBs4Srv
quMc6HTMaetCM5/l0PddCY3/rls9FTESf36RXpECgYEA5AF6mHYwB4AT3/ERMtsa
ZAuw7Sfx58+V1Z2UItrTV1H7D8RXTKE7MO5plb2796rKXWXq2GTzrnzA/5JXldwL
FWc4OFsd/AY7vlpxOQ6wr3cCte1GWRAEjFCURZnyHBK7Ejgn8BuFmTfyTXzrWOUP
bksHRiRd9XJJvxJlU8hYexkCgYBhM9i24THTVVnUtyTn1b+o1lsjnxWAL7c674uO
gxCGu2w6C8leeiXNzBrZb8Mlk4lOJcQpwtDCNzsSySmy0bWas8ngvRmeam16sAzd
dX0Gx0HWPSasNrwEddVvMPYqlbNGPv+78quAQ4AW+zqoGzjDm1pjSAJrunJi2yzQ
G7MNQQKBgCZktECUg2xr8vgVTB586sB7PiHp2j8Wabxh+dMiNUEB7qg4HZdzh8XA
JXnJnZVQWBL0s10yPg9oITWVBcZ3MqgOqsN1QamN9KjzA46ILtpWptz2q3Nw2Tkl
m7RBP9R9gM9mnl9/azK7Y5uj11/O3cNJLEIWcraKqydPfvxNyEtP
-----END RSA PRIVATE KEY-----
~~~


~~~ ascii-art
rsa.public:
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2LNjBAdNAtZOMdd3hlem
ZF8a0onOcEo5g1KWnKzryDCfH4LZkXOPzAJvz4yKMHW5ykOz9OzGL01GMl8ns8Ly
9ztBXc4obY5wnQpl4nbvOdf6vyLy7Gqgp+dj6RrycSYJdLitiYapHwRyuKmERlQL
6MDWLU9ZSWlqskzLVPgwqtT80xchU65HipKkr2luSAySZyyNEf58pRea3D3pBkLy
5hCDhr2+6GF2q9lJ9qMopd2P/ZXxHkvzl3TFtX6GjP5LTsb2dy3tED7vbf/EyQfV
wrs4495a8OUkOBy7V4YkgKbFYSSkGPmhWoPbV7hCQjEAURWLM9J7EUou3U1WIqTj
1QIDAQAB
-----END PUBLIC KEY-----
~~~

File containing to-be-signed data:

~~~ ascii-art
$ cat to-be-signed.txt
relating=example.com
related=foo-example.com
rdbd-tag=0
key-tag=12345
sig-alg=8
$
$ od -x to-be-signed.txt
0000000 6572 616c 6974 676e 653d 6178 706d 656c
0000020 632e 6d6f 720a 6c65 7461 6465 643d 7065
0000040 2d74 7865 6d61 6c70 2e65 6f63 0a6d 6472
0000060 6462 742d 6761 303d 6b0a 7965 742d 6761
0000100 313d 3332 3534 730a 6769 612d 676c 383d
0000120 000a
0000121
$ openssl dgst -sha256 -sign rsa.private -out rsa.sig to-be-signed.txt
$ od -x rsa.sig 
0000000 087c d5c9 375f dcba 9edf ce25 e353 9fb9
0000020 6ef4 ca9f a167 6d91 71bb 7487 5edd fe30
0000040 452e d104 724f f593 009b be3f 6006 ba77
0000060 c1f5 edc6 e207 7ab0 69a1 79bf 18e6 eea3
0000100 3562 6ca4 dc73 22c3 1e35 d15c 44be 5f63
0000120 ac68 f61e ea34 432d 9e12 2325 d48c 2fd9
0000140 330d 1caf 5761 6714 eed2 c7e2 4f71 2c1a
0000160 c35b e45e 833b e343 a8e2 3dbf 1a73 02a8
0000200 c686 7240 aa69 df68 a086 8e3e 2a02 ad57
0000220 32df 0e62 4679 3f4e 8afb 0716 1ad6 4300
0000240 03c6 429f 7b6e bf4d ecae d074 9158 99be
0000260 ab0e 3d49 bb42 a84a 071a b959 2d27 3eea
0000300 c9de 0781 dc5b e205 7708 e50b e485 0cdb
0000320 2fbe adee f521 3b75 9c67 66a8 d217 4f6e
0000340 90da 9423 9d8d e683 7110 4368 f70e 80a2
0000360 3a8c 25f1 3655 44a2 a585 d87d ca99 aac9
0000400
~~~

The presentation for of the signed RDBD record (with a 3600 TTL) would be:

~~~ ascii-art
dept-example.com. 3600 RDBD ( 0 8 12345 example.com 
fAjJ1V83utzfniXOU+O5n/Run8pnoZFtu3GHdN1eMP4uRQTRT3KT9ZsAP74G
YHe69cHG7QfisHqhab955hij7mI1pGxz3MMiNR5c0b5EY19orB72NOotQxKe
JSOM1NkvDTOvHGFXFGfS7uLHcU8aLFvDXuQ7g0Pj4qi/PXMaqAKGxkByaapo
34agPo4CKlet3zJiDnlGTj/7ihYH1hoAQ8YDn0Jue02/rux00FiRvpkOq0k9
QrtKqBoHWbknLeo+3smBB1vcBeIIdwvlheTbDL4v7q0h9XU7Z5yoZhfSbk/a
kCOUjZ2D5hBxaEMO96KAjDrxJVU2okSFpX3YmcrJqg==)
~~~

The base64 encoded value for the signature can be produced using:

~~~ ascii-art
$ base64 -w60 rsa.sig 
fAjJ1V83utzfniXOU+O5n/Run8pnoZFtu3GHdN1eMP4uRQTRT3KT9ZsAP74G
YHe69cHG7QfisHqhab955hij7mI1pGxz3MMiNR5c0b5EY19orB72NOotQxKe
JSOM1NkvDTOvHGFXFGfS7uLHcU8aLFvDXuQ7g0Pj4qi/PXMaqAKGxkByaapo
34agPo4CKlet3zJiDnlGTj/7ihYH1hoAQ8YDn0Jue02/rux00FiRvpkOq0k9
QrtKqBoHWbknLeo+3smBB1vcBeIIdwvlheTbDL4v7q0h9XU7Z5yoZhfSbk/a
kCOUjZ2D5hBxaEMO96KAjDrxJVU2okSFpX3YmcrJqg==
~~~

To verify, with "rsa.sig" containing the above signature:

~~~ ascii-art
$ openssl dgst -sha256 -verify rsa.public \ 
    -signature rsa.sig to-be-signed.txt
Verified OK
~~~

## Sample Ed25519 Signature

[[TBD]]

# Changes and Open Issues

[[RFC editor: please delete this appendix ]]

## Open Issues

Current open issues include: (TBD tidy these)

* #1: use TXT or new RR? (ATB: new RR, but TXT for now) RESOLVED?
* #2: stick with a 1:n thing or design for m:n relationshops (ATB: m:n is possible (I believe) as it stands, using selectors)
* #3: include an indicator for the kind of relationship or not?
* #4: "h=" is wrong for a signature, but "s=" is selector, bikeshed later
* #5: specify input for signing more precisely - e.g. is there a CR or NULL or not

These aren't yet github issues:

* #N: make sure we say explicitly where child's TXT RR is below _rdbd.example.net (if we stick with TXT) 
* #N: keep an eye on https://datatracker.ietf.org/doc/draft-ietf-dnsop-attrleaf and add entry there if using the ``_rdbd`` prefix.
* #N: various design suggestions from JL (involving ditching signatures:-)
* #N: don't overloaad parent/primary and secondary - invent some new terms
* #N: stick with unidirectional or make it bidirectional? (AOS)

## Changes from -00

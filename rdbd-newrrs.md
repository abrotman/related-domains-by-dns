%%%

   Title = "Related Domains By DNS"
   abbrev = "RDBD"
   category = "std"
   docName = "draft-brotman-rdbd-03"
   ipr = "trust200902"
   area = "Applications"
   keyword = [""]

   
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

This document outlines a mechanism by which a DNS domain can 
publicly document the existence or absence of a relationship with a different domain, called 
"Related Domains By DNS", or "RDBD".

{mainmatter}

# Introduction

[[Discussion of this draft is taking place on the dbound@ietf.org mailing list.
There's a github repo for this draft at 
https://github.com/abrotman/related-domains-by-dns -
issues and PRs are welcome there.]]

Determining relationships between registered domains can be one of the more difficult
investigations on the Internet.  It is typical to see something such as 
`example.com` and `dept-example.com` and be unsure if there is an actual
relationship between those two domains, or if one might be an attacker 
attempting to impersonate the other.  In some cases, anecdotal evidence from 
the DNS or WHOIS/RDAP may be sufficient.  However, service providers of various
kinds may err on the side of caution and treat one of the domains as 
untrustworthy or abusive because it is not clear that the two domains are in 
fact related. This specification provides a way for one domain to 
explicitly document a relationship with another, utilizing DNS records.

Possible use cases include: 

- where a company has websites in different languages, and would like to
  correlate their ownership more easily, consider `example.de` and `example.ie`
  registered by regional offices of the same company;
- following an acquisition, a domain holder might want to indicate that
  example.net is now related to example.com in order to make a later migration
  easier;
- when doing Internet surveys, we should be able to provide more accurate results
  if we have information as to which domains are related.

Similarly, a domain may wish to declare that no relationship exists with
some other domain, for example "good.example" may want to declare that
it is not associated with "g00d.example" if the latter is currently being
used in some cousin-domain style attack. In such cases, it is more
likely that there can be a larger list of names (compared to the
"positive" use-cases) for which there is a desire to disavow a 
relationship.

It is not a goal of this specification to provide a high-level of
assurance as to whether or not two domains are definitely related, nor to provide
fine-grained detail about the kind of relationship that may 
exist between domains.

Using "Related Domains By DNS", or "RDBD", it is possible to
declare that two domains are related, or to disavow such a
relationship.

We include an optional digital signature mechanism that can somewhat improve the
level of assurance with which an RDBD declaration can be handled.
This mechanism is partly modelled on how DKIM [@?RFC6376] handles public
keys and signatures - a public key is hosted at the Relating-domain
(e.g., `example.com`) and a reference from the Related-domain
(e.g., `dept-example.com`) contains a signature (verifiable with
the `example.com` public key) over the text representation ('A-label') of 
the two domain names (plus a couple of other inputs).

RDBD is intended to declare or disavow a relationship between registered
domains, not individual hostnames.  That is to say that the
relationship should exist between `example.com` and `dept-example.com`,
not `foo.example.com` and `bar.dept-example.com` (where those latter
two are hosts).

There already exists Vouch By Reference (VBR) [@?RFC5518], however
this only applies to email.  RDBD could be a more general purpose solution
that could be applied to other use cases, as well as for SMTP transactions.

This document describes the various options, how to
create records, and the method of validation, if the option to 
use digital signatures is chosen.

## Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and
"OPTIONAL" in this document are to be interpreted as described in
[@?RFC2119].

The following terms are used throughout this document:

* Relating-domain: this refers to the domain that is 
declarating a relationship exists. (This was called the
"parent/primary" in -00). 
   
* Related-domain: This refers to the domain that is
referenced by the Relating-domain, such as `dept-example.com`.
(This was called the "secondary" in -00.)

# New Resource Record Types

We define two new RRTYPES, an optional one for the Relating-domain (RDBDKEY)
to store a public key for when signatures are in use and one for use in 
Related-domains (RDBD).

## RDBDKEY Resource Record Definition

The RDBDKEY record is published at the apex of the Relating-domain zone.

The wire and presentation format of the RDBDKEY 
resource record is identical to the DNSKEY record. [@?RFC4034]

[[All going well, at some point we'll be able to say...]]
IANA has allocated RR code TBD for the RDBDKEY resource record via Expert
Review.  
[[In the meantime we're experimenting using 0xffa8, which is decimal 65448,
from the experimental RR code range, for the RDBDKEY resource record.]]  

The RDBDKEY RR uses the same registries as DNSKEY for its
fields. (This follows the precedent set for CDNSKEY in [@?RFC7344].)

No special processing is performed by authoritative servers or by
resolvers, when serving or resolving.  For all practical purposes,
RDBDKEY is a regular RR type.

The flags field of RDBDKEY records MUST be zero. [[Is that correct/ok? I've
no idea really:-)]]

There can be multiple occurrences of the RDBDKEY resource record in the
same zone

## RDBD Resource Record Definition

To declare a relationship exists an RDBD resource record is published at the
apex of the Related-domain zone.

To disavow a relationship an RDBD resource record is published at the apex of
the Relating-domain zone.

[[All going well, at some point we'll be able to say...]]
IANA has allocated RR code TBD for the RDBD resource record via Expert
Review.  
[[In the meantime we're experimenting using 0xffa3, which is decimal 65443,
from the experimental RR code range, for the RDBD resource record.]]  

The RDBD RR is class independent.

The RDBD RR has no special Time to Live (TTL) requirements.

There can be multiple occurrences of the RDBD resource record in the
same zone.

The wire format for an RDBD RDATA consists of a two octet rdbd-tag, the
Relating-domain name(s), and the optional signature fields which are: a two-octet
key-tag, a one-octet signature algorithm, and the digital signature bits.

~~~ ascii-art
                        1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |           rdbd-tag            |                               /
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                               /
   /                  Related-domain name or URL                   /
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--+-+|
   |    key-tag                    | sig-alg     |                 /
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                 /
   /                            signature                          /
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~~~

We define two possible values for the rdbd-tag in this specification,
later specifications can define new rdbd-tag values:

- 0: states that no relationship exists between the domains
- 1: states that some relationship exists between the domains 

The Related-domain name field contains either a single domain
name, or an HTTPS URL. In the latter case, successfully de-referencing that
URL results in a JSON object that contains the list of domain
names, such as is shown in the figure below.

~~~ ascii-art

    [ 
        "example.com", 
        "example.net",
        "foo.example"
    ]
    
~~~

If an optional signature is included, the sig-alg field MUST contain
the signature algorithm used, with the same values used as would be
used in an RRSIG. The key-tag MUST match the RDBDKEY RR value for
the corresponding public key.

If the optional signature is omitted, then the presentation form of the
key-tag, sig-alg and signature fields MAY be omitted. If not omitted then the
sig-alg and key-tag fields MUST be zero and the signature field MUST be a an
empty string. [[Is that the right way to have optional fields in RRs? Not
sure.]]

The input to signing ("to-be-signed" data) is the concatenation of the 
following linefeed-separated (where linefeed has the value '0x0a') lines:

~~~ ascii-art
relating=<Relating-domain name>
related=<Related-domain name or URL>
rdbd-tag=<rdbd-tag value>
key-tag=<key-tag>
sig-alg=<sig-alg>

~~~

The Relating-domain and Related-domain values MUST be the 'A-label'
representation of these names.

The trailing "." representing the DNS root MUST NOT be included in
the to-be-signed data, so a Relating-domain value above might be
"example.com" but "example.com." MUST NOT be used as input to 
signing.

A linefeed MUST be included after the "sig-alg" value in the
last line.

[[Presentation syntax and to-be-signed details are very liable to change.]]

See the examples in the Appendix for further details.

# Directionality and Cardinality

RDBD relationships are uni-directional. If bi-directional relationships
exist, then both domains can publish RDBD RRs and optionally sign those.

If one domain has relationships with many others, then the relevant
RDBD RRs (and RDBDKEY RRs) can be published to represent those or
one RDBD RR can contain an HTTPS URL at which one can provide a list of
names.

# Conflicting Tag Values

It is possible to define a relationship more than once.  If it an
investigating entity finds that a domain is related to more than once,
and the `rdbd-tag` has a conflicting value, the investigator SHOULD treat
the relationship as unstated.

# Undocumented Tags

If a relationship is found to have an invalid or undocumented `rdbd-tag`, 
the investigating party SHOULD treat the relationship as unstated.

# HTTPS Resources

If the RDBD record references an HTTPS URI for inclusion, the URI MUST
be located at the domain stating the relationship using a 
".well-known" [?RFC8615] location.  The base location for the domain
`example.com` asserting relationships might be located within:

https://example.com/.well-known/rdbd/

The domain may wish to use a sub-domain such as `reference.example.com`.
Furthermore, the URI will specify a file within the `.well-known` directory
stated above, but the filename is left to the diescretion of the domain owner.
An example of a full URI might be:

https://www.example.com/.well-known/rdbd/affirmative.json

The document being reference MUST be a well-formed JSON [?RFC8259] document.
If the document does not validate as a JSON document, the contents of the 
document SHOULD be ignored.

There should is no defined maximum size for these documents, but a referring 
site should be considerate of the retrieving entity's resources.

## Document Retrieval

When retrieving the document via HTTPS, the certificate presented MUST 
properly validate.  If the certificate fails to validate, the retreiving 
entity SHOULD ignore the contents of the file located at that resource.

A site may employ an HTTP redirection if they choose, and the retreiving
entity should honor that redirect.

# Time-To-Live

The relationship is deemed to be enforced for the duration of time matching
the TTL value of the RDBD record.

# Use-cases for Signatures

[[The signature mechanism is pretty complex, relative to anything
else here, so it might be considered as an at-risk feature.]]

We see two possibly interesting use-cases for the signature mechanism
defined here. They are not mutually exclusive.

## Extending DNSSEC

If the Relating-domain and Related-domain zones are both DNSSEC-signed,
then the signature mechanism defined here adds almost no value and so
is unlikely to be worth deploying. If neither zone is DNSSEC-signed,
then again, there may be less value in deploying RDBD signatures. The
minimal value that remains in either such case, is that if a client
has acquired and cached the RDBDKEY values in some secure manner, 
then the RDBD signatures do offer some benefit. However, at this
point it is fairly unklikely that RDBDKEY values will be acquired
and cached via some secure out-of-band mechanisms, so we do not 
expect much deployment of RDBD signatures in either the full-DNSSEC
or no-DNSSEC cases.

However, where the Relating-domain's zone is DNSSEC-signed, but the
Related-domain's zone is not DNSSEC signed, then the RDBD signatures
do provide value, in essence by extending DNSSEC "sideways" to the
Related-domain. Figure 17 below illustrates this situation.

~~~ ascii-art

+-----------------+
| Relating-domain |
| (DNSSEC-signed) |         +---------------------+
| RDBDKEY-1       |<----+   + Related-domain      |
+-----------------+     |   | (NOT DNSSEC-signed) |
                        +---+ RDBD RR with SIG    |
                            +---------------------+

Figure 17: Extending DNSSEC use-case for RDBD signatures

~~~

The overall benefit is that the Relating-domain in this case
need not publish new RR values for each Related-domain.
Without the signatures, every new related domain would
require an update to the zone file for the Relating-domain.
With signatures, the relevant private key holder can
publish a new RR value in each Related-domain without
there being any need to update the Relating-domain.

## Many-to-one Use-Case 

Providing reasonable confidence that a relationship
exists without use of the signature mechanism likely
requires both the Relating-domain zone and the 
Related-domain zone to be updated.

If a relationship exists between one Relating-domain 
and many Related-domains and the signature scheme is
not used, then making the many required changes to the 
Relating-domain zone could be onerous. Instead, the 
signature mechanism allows one to publish a stable
value (the RDBDKEY) once in the Relating-domain.
Each Related-domain can then also publish a stable
value (the RDBD RR with a signature) where the
signature provides confirmation that both domains
are involved in the relationship.

This scenario makes sense if the relationship (represented
by the rdbd-tag) between
the domains is inherently directional, for example, if
the relationship between the Related-domains and
Relating-domain is akin to a membership relationship.

If the relationship in question is more "balanced" then
by definition we are in a many-to-one situation, but
rather a many-to-many situation where the signature
mechanism again is no real help.

# Required Signature Algorithms

Consumers of RDBD RRs MAY support signature verification. They
MUST be able to parse/process unsigned or signed RDBD RRs even if they 
cannot cryptographically verify signatures.

Implementations producing RDBD RRs SHOULD support optional signing of those
and production of RDBDKEY RRs.

Implementations of this specification that support signing or verifying
signatures MUST support use of RSA with
SHA256 (sig-alg==8) with at least 2048 bit RSA keys. [@?RFC5702]

RSA keys MUST use a 2048 bit or longer modulus.

Implementations of this specification that support signing or verifying
signatures SHOULD support use of Ed25519 
(sig-alg==15). [@?RFC8080][@?RFC8032]

# Validation 

A validated signature is solely meant to be additional evidence that the
relevant domains are related, or that one disavows such a relationship.  The
existence or disavowal of a relationship does not by itself mean that data or
services from any domain should be considered as more or less trustworthy.  

# Security Considerations

## Efficiacy of signatures

The optional signature mechanism defined here offers no protection against an
active attack if both the RDBD and RDBDKEY values are accessed via an untrusted
path.

If the RDBDKEY value has been cached, or is otherwise known via some
sufficiently secure mechanism, then the RDBD signature does confirm that the
holder of the private key (presumably the Relating-domain) considered that the
relationship, or lack thereof, with a Related-domain was real at some point
in time. 

## DNSSEC

RDBD does not require DNSSEC. Without DNSSEC it is possible for an attacker to
falsify DNS query responses for someone investigating a relationship.
Conversely, an attacker could delete the response that would normally
demonstrate the relationship, causing the investigating party to believe there
is no link between the two domains.  An attacker could also replay an old RDBD
value that is actually no longer published in the DNS by the Related-domain.

Deploying signed records with DNSSEC should allow for detection
of these kinds of attack.

If the Relating-domain has DNSSEC deployed, but the Related-domain
does not, then the optional signature can (in a sense) extend the
DNSSEC chain to cover the RDBD RR in the Related-domain's zone.

If both domains have DNSSEC deployed, and if the Relating-domain public key has
been cached, then the the signature mechanism provides additional protection
against active attacks involving a parent of one of the domains.  Such attacks
may in any case be less likely and detectable in many scenarios as they would
be generic attacks against DNSSEC-signing (e.g. if a regisgtry injected a bogus
DS for a Relating-domain into the registry's signed zone). If the
public key from the relevant RDNDKEY RRs is read from the DNS at the
same time as a related RDBD RR, then the signature mechanism provided here
may provide litle additional value over and above DNSSEC.

## Lookup Loops

It's conceivable that an attacker could create a loop of relationships, such as
a.com->b.com->c.com->a.com or similar.  This could cause a resource issue for
any automated system.  A system SHOULD only perform three lookups from the
first domain (a.com->b.com->c.com->d.com).  The Related-domain and Relating-domains
SHOULD attempt to keep links direct and so that only the fewest number of
lookups are needed, but it is understood this may not always be possible.

# IANA Considerations

This document introduces two new DNS RR types, RDBD and RDBDKEY.  [[Codepoints
for those are not yet allocated by IANA, nor have codepoints been requested
so far.]]

[[New rdbd-tag value handling wll need to be defined if we keep
that field. Maybe something
like: 0-255: RFC required; 256-1023: reserved; 1024-2047: Private
use; 2048-65535: FCFS.]]

# Acknowledgements

Thanks to all who commented on this on the dbound and other lists,
in particular to the following who provided comments that caused us
to change the draft: 
Bob Harold, 
John Levine, 
Pete Resnick,
Andrew Sullivan,
Tim Wisinski,
Suzanne Woolf,
Joe St. Sauver,
and
Paul Wouters.
(We're not implying any of these fine folks actually like this
draft btw, but we did change it because of their comments:-)
Apologies to anyone we missed, just let us know and we'll add
your name here.

{backmatter}

# Implementation (and Deployment:-) Status

[[Note to RFC-editor: according to RFC 7942, sections such as
this one ought not be part of the final RFC. I still dislike
that idea, but whatever;-)]]

We are not aware of any independent implementations so far.  One of the authors
has a github repo at https://github.com/sftcd/rdbd-deebeedeerrr with scripts
that allow one to produce zone file fragments and signatures for a set of
domains. See the README there for details.

In terms of deployments, we used the above for a "toy" deployment in the
tolerantnetworks.ie domain and other related domains that one cen determine by
following the relevant trail:-) 

{{appendix.md}}

# Ed25519 Signing Code

Since OpenSSL does not yet support Ed25519 signing via its command
line tool, we generate our example using the python script below,
which is called as "ed25519-signer.py" above. 
This uses the python library from Appendix A of [@?RFC8032].

~~~ ascii-art

#!/usr/bin/env python3
# CODE_BEGINS
import argparse, sys, binascii
from eddsa2 import Ed25519

# from https://gist.github.com/wido/4c6288b2f5ba6d16fce37dca3fc2cb4a
def calc_keyid(flags, protocol, algorithm, dnskey):
    st=struct.pack('!HBB', int(flags), int(protocol), int(algorithm))
    st+=base64.b64decode(dnskey)
    cnt = 0
    for idx in range(len(st)):
        s = struct.unpack('B', st[idx:idx+1])[0]
        if (idx % 2) == 0:
            cnt += s << 8
        else:
            cnt += s
    return ((cnt & 0xFFFF) + (cnt >> 16)) & 0xFFFF

def main():
    parser=argparse.ArgumentParser(description='Ed25519 signing')
    parser.add_argument('-s','--secret',
                        dest='secret', help='secret key')
    parser.add_argument('-r','--relating',
                        dest='relating', help='relating domain')
    parser.add_argument('-d','--related',
                        dest='related', help='related domain')
    parser.add_argument('-n','--negative',
                        dest='negative', help='negative assertion')
    args=parser.parse_args()

    if args.secret is None:
        print("You do need a secret... - exiting")
        sys.exit(1)
    # secret has to be 32 octets funnily enuugh:-)
    # e.g. secret="rdbd-example0001rdbd-example0002".encode('utf-8')
    if len(args.secret)!=32:
        print("Secret has to be 32 octets... - exiting")
        sys.exit(1)
    if args.relating is None:
        print("You do need a relating domain... - exiting")
        sys.exit(1)
    if args.related is None:
        print("You do need a related domain... - exiting")
        sys.exit(1)
    secret=args.secret.encode('utf-8')
    privkey,pubkey = Ed25519.keygen(secret)
    print("private:"+ str(binascii.hexlify(privkey)))
    print("public:"+ str(binascii.hexlify(pubkey)))

    b64pubkey=binascii.b2a_base64(pubkey).rstrip().decode("utf-8")
    print("b64pubkey: " + b64pubkey)

    keyid=calc_keyid("0","3","15",b64pubkey)
    print("keyid: " + str(keyid))

    rdbdtag="1"
    if args.negative:
        rdbdtag="0"

    tbs="relating="+args.relating+"\nrelated="+\
          args.related+"\nrdbd-tag="+rdbdtag+\
          "\nkey-tag="+str(keyid)+"\nsig-alg=15\n"
    print("to-be-signed:|" + str(tbs)+"|")

    with open("ed25519.priv", "wb") as privf:
        privf.write(privkey)
    with open("ed25519.pub","wb") as pubf:
        pubf.write(pubkey)
    with open("to-be-signed-15.txt","wb") as tbsf:
        tbsf.write(tbs.encode('utf-8'))

    msg=tbs.encode('utf-8')
    signature = Ed25519.sign(privkey, pubkey, msg)
    print("sig:"+ str(binascii.hexlify(signature)))
    with open("ed25519.sig", "wb") as sigf:
        sigf.write(signature)
    return

if __name__ == "__main__":
    main()

# CODE_ENDS
~~~


# Changes and Open Issues

[[RFC editor: please delete this appendix ]]

## Changes from -02 to -03

- Incorporated feedback/comments from IETF-105
- Adopted some experimental RRCODE value

## Changes from -01 to -02

- Added negative assertions based on IETF104 feedback
- Added URL option based on IETF104 feedback
- Made sample generation script
- Typo fixes etc.

## Changes from -00 to -01

- Changed from primary/secondary to relating/related (better suggestions
  are still welcome)
- Moved away from abuse of TXT RRs
- We now specify optional DNSSEC-like signatures (we'd be fine with moving
  back to a more DKIM-like mechanism, but wanted to see how this looked)
- Added Ed25519 option 
- Re-worked and extended examples 

## Open Issues

Current open github issues include: 

* #5: specify input for signing more precisely - e.g. is there a CR or NULL or not
* #6: what, if anything, does rdbd for example.com mean for foo.example.com?

These can be seen at: https://github.com/abrotman/related-domains-by-dns/issues


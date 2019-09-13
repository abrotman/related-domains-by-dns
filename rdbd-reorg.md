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

This document describes a mechanism by which a DNS domain can 
publicly document the existence or absence of a relationship with a different domain, called 
"Related Domains By DNS", or "RDBD".

[[THIS IS A PROPOSED RESTRUCTURE FOR -03, IT MAY DISAPPEAR IF ALEX HATES IT:-)]]

{mainmatter}

# Introduction

Determining relationships between DNS domains can be one of the more difficult
investigations on the Internet.  It is typical to see something such as 
`example.com` and `dept-example.com` and be unsure if there is an actual
relationship between those two domains, or if one might be an attacker 
attempting to impersonate the other.  In some cases, anecdotal evidence from 
the DNS or WHOIS/RDAP may be sufficient.  However, service providers of various
kinds may err on the side of caution and treat one of the domains as 
untrustworthy or abusive if it is not clear that the two domains are in 
fact related. This specification provides a way for one domain to 
explicitly document, or disavow, a relationship other domains, utilizing DNS records.

The use cases for this include: 

- where an organisation has names below different ccTLDs, and would like to
  allow others to correlate their ownership more easily, consider `example.de`
and `example.ie` registered by regional offices of the same company;
- following an acquisition, a domain holder might want to indicate that
  example.net is now related to example.com in order to make a later migration
easier;
- when doing Internet surveys, we should be able to provide more accurate
  results if we have information as to which domains are, or are not, related.
- a domain holder may wish to declare that no relationship exists with some
  other domain, for example "good.example" may want to declare that it is not
associated with "g00d.example" if the latter is currently being used in some
cousin-domain style attack. In such cases, it is more likely that there can be
a larger list of names (compared to the "positive" use-cases) for which there
is a desire to disavow a relationship.

It is not a goal of this specification to provide a high-level of
assurance as to whether or not two domains are definitely related, nor to provide
fine-grained detail about the kinds of relationships that may 
exist between domains. However, the mechanism defined here is 
extensible in a way that should allow use-cases calling for such
declarations to be handled later. 

<!--
Using "Related Domains By DNS", or "RDBD", it is possible to
declare that two domains are related, or to disavow such a
relationship.

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
-->

[[Discussion of this draft is taking place on the dnsop@ietf.org mailing list.
Previously, there was discussion on the dbound@ietf.org list.
There's a github repo for this draft at 
https://github.com/abrotman/related-domains-by-dns -
issues and PRs are welcome there.]]

## Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and
"OPTIONAL" in this document are to be interpreted as described in
[@!RFC2119].

The following terms are used throughout this document:

* Relating-domain: this refers to the domain that is 
declarating a relationship exists. (This was called the
"parent/primary" in -00). 
   
* Related-domain: This refers to the domain that is
referenced by the Relating-domain, such as `dept-example.com`.
(This was called the "secondary" in -00.)

# New Resource Record Types

We define a resource record type (RDBD) that can declare, or disavow, a
relationship.

RDBD also includes an optional digital signature mechanism that can somewhat
improve the level of assurance with which an RDBD declaration can be handled.
This mechanism is partly modelled on how DKIM [@?RFC6376] handles public keys
and signatures - a public key is hosted at the Relating-domain (e.g.,
`club.example.com`), using an RDBDKEY resource record, and the RDBD record of
the Related-domain (e.g., `member.example.com`) can contain a signature
(verifiable with the `example.com` public key) over the text representation
('A-label') of the two names (plus a couple of other inputs).

## RDBDKEY Resource Record Definition

The RDBDKEY record is published at the apex of the Relating-domain zone.

The wire and presentation format of the RDBDKEY 
resource record is identical to the DNSKEY record. [@!RFC4034]

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

RDBD relationships are uni-directional. If bi-directional relationships
exist, then both domains can publish RDBD RRs and optionally sign those.

The wire format for an RDBD RDATA consists of a two octet rdbd-tag, a
domain name or URL, and the optional signature fields which are: a two-octet
key-tag, a one-octet signature algorithm, and the digital signature bits.

~~~ ascii-art
                        1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |           rdbd-tag            |                               /
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                               /
   /                        domain name or URL                     /
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

The domain name field contains either a single domain
name, or an HTTPS URL. In the latter case, successfully de-referencing that
URL is expected to result in a JSON object that contains a list of domain
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
the corresponding public key, and is calculated as defined in 
[@!RFC4034] appendix B.

If the optional signature is omitted, then the presentation form of the
key-tag, sig-alg and signature fields MAY be omitted. If not omitted then the
sig-alg and key-tag fields MUST be zero and the signature field MUST be a an
empty string. [[Is that the right way to have optional fields in prsentation
sytax for RRs? Not sure.]]

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

# RDBD processing

- If multiple RDBD records exist
with conflicting `rdbd-tag` values, those RDBD records SHOULD be ignored.

- If an RDBD record has an invalid or undocumented `rdbd-tag`, 
that RDBD record SHOULD be ignored.

<!--
If the RDBD record references an HTTPS URI for inclusion, the URI MUST
be located at the domain stating the relationship using a 
".well-known" [@RFC8615] location.  The base location for the domain
`example.com` asserting relationships might be located within:

https://example.com/.well-known/rdbd/

The domain may wish to use a sub-domain such as `reference.example.com`.
Furthermore, the URI will specify a file within the `.well-known` directory
stated above, but the filename is left to the diescretion of the domain owner.
An example of a full URI might be:

https://www.example.com/.well-known/rdbd/affirmative.json
-->

- The document being referenced by a URL within an RDBD record MUST be a
well-formed JSON [?RFC8259] document.  If the document does not validate as a
JSON document, the contents of the document SHOULD be ignored.

- There is no defined maximum size for these documents, but a referring 
site ought be considerate of the retrieving entity's resources.

- When retrieving the document via HTTPS, the certificate presented MUST 
properly validate.  If the certificate fails to validate, the retreiving 
entity SHOULD ignore the contents of the file located at that resource.

- Normal HTTP processing rules apply when de-referencing a URL found
in an RDBD record, for example, a site may employ HTTP redirection.

- Consumers of RDBD RRs MAY support signature verification. They
MUST be able to parse/process unsigned or signed RDBD RRs even if they 
cannot cryptographically verify signatures.

- Implementations producing RDBD RRs SHOULD support optional signing of those
and production of RDBDKEY RRs.

- Implementations of this specification that support signing or verifying
signatures MUST support use of RSA with
SHA256 (sig-alg==8) with at least 2048 bit RSA keys. [@!RFC5702]

- RSA keys MUST use a 2048 bit or longer modulus.

- Implementations of this specification that support signing or verifying
signatures SHOULD support use of Ed25519 
(sig-alg==15). [@!RFC8080][@!RFC8032]

- A validated signature is solely meant to be additional evidence that the
relevant domains are related, or that one disavows such a relationship.  

# Use-cases for Signatures

[[The signature mechanism is pretty complex, relative to anything
else here, so it might be considered as an at-risk feature.]]

We see two possibly interesting use-cases for the signature mechanism
defined here. They are not mutually exclusive.

## Many-to-one Use-Case 

If a bi-directional relationship exists between one Relating-domain and many
Related-domains and the signature scheme is not used, then making the many
required changes to the Relating-domain zone could be onerous. Instead, the
signature mechanism allows one to publish a stable value (the RDBDKEY) once in
the Relating-domain.  Each Related-domain can then also publish a stable value
(the RDBD RR with a signature) where the signature provides confirmation that
both domains are involved in declaraing the relationship.

This scenario also makes sense if the relationship (represented by the rdbd-tag)
between the domains is inherently directional, for example, if the relationship
between the Related-domains and Relating-domain is akin to a membership
relationship.

## Extending DNSSEC

If the Relating-domain and Related-domain zones are both DNSSEC-signed, then
the signature mechanism defined here adds almost no value and so is unlikely to
be worth deploying in that it provides no additional cryptorgraphic security
(though the many-to-one advantage could still apply).
If neither zone is DNSSEC-signed,
then again, there may be little value in deploying RDBD signatures. 

The minimal value that remains in either such case, is that if a client
has acquired and cached RDBDKEY values in some secure manner, 
then the RDBD signatures do offer some benefit. However, at this
point it is fairly unklikely that RDBDKEY values will be acquired
and cached via some secure out-of-band mechanisms, so we do not 
expect much deployment of RDBD signatures in either the full-DNSSEC
or no-DNSSEC cases.

However, where the Relating-domain's zone is DNSSEC-signed, but the
Related-domain's zone is not DNSSEC signed, then the RDBD signatures
do provide value, in essence by extending DNSSEC "sideways" to the
Related-domain. The figure below illustrates this situation.

~~~ ascii-art

+-----------------+
| Relating-domain |
| (DNSSEC-signed) |         +---------------------+
| RDBDKEY-1       |<----+   + Related-domain      |
+-----------------+     |   | (NOT DNSSEC-signed) |
                        +---+ RDBD RR with SIG    |
                            +---------------------+

  Extending DNSSEC use-case for RDBD signatures

~~~

# Security Considerations

## Efficiacy of signatures

The optional signature mechanism defined here offers no protection against an
active attack if both the RDBD and RDBDKEY values are accessed via an untrusted
path.

## DNSSEC

RDBD does not require DNSSEC. Without DNSSEC it is possible for an attacker to
falsify DNS query responses for someone investigating a relationship.
Conversely, an attacker could delete the response that would normally
demonstrate the relationship, causing the investigating party to believe there
is no link between the two domains.  An attacker could also replay an old RDBD
value that is actually no longer published in the DNS by the Related-domain.

Deploying signed records with DNSSEC should allow for detection
of these kinds of attack.

## Lookup Loops

A bad actor could create a loop of relationships, such as
a.example->b.example->c.example->a.example or similar.  
Automated systems SHOULD protect against such loops. For example,
only perform a configured number of lookups from the first
domain.
Related-domain and Relating-domains
SHOULD attempt to keep links direct and so that only the fewest number of
lookups are needed, but it is understood this may not always be possible.

# IANA Considerations

This document introduces two new DNS RR types, RDBD and RDBDKEY.  [[Codepoints
for those are not yet allocated by IANA, nor have codepoints been requested so
far.]]

[[New rdbd-tag value handling will need to be defined if we keep that field.
Maybe something like: 0-255: RFC required; 256-1023: reserved; 1024-2047:
Private use; 2048-65535: FCFS. It will also likely be useful to define a string
representation for each registered rdbd-tag value, e.g.  perhaps "UNRELATED"
for rdbd-tag value 0, and "RELATED" for rdbd-tag value 1, so that tools
displaying RDBD information can be consistent.]]

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

# Implementation (and Toy Deployment:-) Status

[[Note to RFC-editor: according to RFC 7942, sections such as
this one ought not be part of the final RFC. I still dislike
that idea, but whatever;-)]]

We are not aware of any independent implementations so far.  One of the authors
has a github repo at https://github.com/sftcd/rdbd-deebeedeerrr with scripts
that allow one to produce zone file fragments and signatures for a set of
domains. There is also a wrapper script for the dig tool that provides
a nicer view of RDBD and RDBDKEY records. See the README there for details.

In terms of deployments, we used the above for a "toy" deployment in the
tolerantnetworks.ie domain and other related domains that one can determine by
following the relevant trail:-) 

# Examples

These examples have been generated using the proof-of-concept implementation
mentioned above. These are intended for interop, not for beauty:-) The
dig wrapper script referred to above produces more readable output, 
shown further below..  

The following names and other values are used in these
examples.

- Relating domain: my.example
- Related domain: my-way.example
- Unrelated domain: my-bad.example
- URL for other related domains: <https://my.example/related-names>
- URL for other unrelaed domains: <https://my.example/unrelateds>

{{newapp.md}}

# Possible dig output...

Below we show the output that a modified dig tool might display
for the my.example assertions above.

~~~
$ dig RDBD my.example

; <<>> DiG 9.11.5-P1-1ubuntu2.5-Ubuntu <<>> RDBD my.example
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 4289
;; flags: qr rd ra ad; QUERY: 1, ANSWER: 5, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: e69085d4b9a18cca63ae96035d7bc0aa96580e0d6255c122 (good)
;; QUESTION SECTION:
;my.example. IN RDBD

;; ANSWER SECTION:
my.example. 3600 IN RDBD RELATED may-way.example KeyId: 50885 Alg: 15 Sig: UIi04agb...
my.example. 3600 IN RDBD UNRELATED my-bad.example
my.example. 3600 IN RDBD RELATED https://my-way.example/mystuff.json
my.example. 3600 IN RDBD UNRELATED https://my-way.example/notmystuff.json

;; Query time: 721 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Fri Sep 13 17:15:38 IST 2019
;; MSG SIZE rcvd: 600


~~~

# Changes and Open Issues

[[RFC editor: please delete this appendix ]]

## Changes from -02 to -03

- Incorporated feedback/comments from IETF-105
- Adopted some experimental RRCODE value
- Fixed normative vs. informative refs
- Changed the examples to use the PoC implementation.
- Restructured text a lot

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


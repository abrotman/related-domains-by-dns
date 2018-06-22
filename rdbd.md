%%%

   Title = "Related Domains By DNS"
   abbrev = "RDBD"
   category = "std"
   docName = "draft-ietf-uta-brotman-rdbd-01"
   ipr = "trust200902"
   area = "Applications"
   workgroup = "uta"
   keyword = [""]

   date = 2018-06-16T00:00:00Z
   
   [[author]]
   initials="A."
   surname="Brotman"
   fullname="Alex Brotman"
   organization="Comcast, Inc"
     [author.address]
     email="alex_brotman@comcast.com"

%%%


.# Abstract

This document outlines a mechanism by which a domain can create a
relationship to a different domain, called "Related Domains By 
DNS", or "RDBD".

{mainmatter}

# Introduction

Determining relationships between domains can be one of the more difficult
investigations on the Internet.  It is typical to see something such as 
`example.com` and `dept-example.com` and be unsure if there is an actual
relationship between those two domains, or if it might be an attacker 
attempting to impersonate the original domain.  Providers may err on 
the side of caution and mark the secondary domain as spam or invalid 
because it is not clear that they should be related.

By using "Related Domains By DNS", or "RDBD", it will be possible to
determine that the secondary domain is related to the primary domain.
This mechanism will include a public key hosted at the parent domain
("example.com") and a reference from the secondary domain 
("dept-example.com") along with a hash of the text representation of 
that domain.

There already exists Vouch By Reference (VBR) [@?RFC5518], however
this only applies to email.  This is a more general purpose solution
that could be applied to other use cases, as well as the SMTP realm.

This document will explain the various options to be used, how to
create a record, and the method of validation.

## Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and
"OPTIONAL" in this document are to be interpreted as described in
[RFC2119].

The following terms are used throughout this document:
   
* Parent domain: This refers to the master domain that is to be
  referenced, such as `example.com`.
   
* Secondary domain: This will refer to the domain that has been created, 
  that would like to reference the parent domain, such as "dept-example.com".
   
   
# Creating a Signature for the Secondary Domain

Appendix C of [@!RFC6376] has some reference material on 
how to create a set of keys for use in this type of use case. The key
length is recommended to be at least 2048 bits instead of the 1024 
recommended in that appendix.

# DNS Record for Secondary Domain

There are a few options when publishing the reference to the parent domain.

* `v`: Version string, which should be set to `RDBD1`.
* `d`: The Parent Domain.  This should be in the form of "example.com".
* `s`: The selector, which is the same as defined in [@!RFC6376] and
  used to denote which published public key should be used.
* `h`: The base64 encoded sha256 hash of the secondary domain, creating 
  using the private key.

A sample TXT record for `dept-example.com` would appear as:

"v=RDBD1;s=2018a;d=example.com;
h=OQHYRUmBjTAYrMlAjZFvq5HTMJFVBcdJCrpS9JbOTAY+v1wa4mKktkpzQhbZlLuKLYFzljF7uHl5
Z5g5x+oyUhQxaDzBFtPYB0sIRZIrqftr09jfnlX4wdHhmgZn00m/D3DJ0/RMGYK8SmkbzzLKqzce
9K56oNRsP3GUaympykq/tj512IfVJDxTt4ccqAopVYEvLYuFnQ0d6lP4FC20CTGaNlD+vdZgryl2
aJE7PSotJ/tDc5u6jmpRa0uhzwyE2Xmbr1X5+gymF99sT4lnfvsUsk6Nlpbk1SXdB52GZJ4qr6Km
8tEVvDK0soJ89FhTwpb0NsTBAQxFpcaTyka7uQ=="

# DNS Record for Parent Domain

* `v`: Version string, which should be set to `RDBD1`.
* `s`: The selector, which is the same as defined in [@!RFC6376] and
  is a string used to denote a specific public key published by the 
  Parent Domain.
* `k`: The public key published for this selector, encoded using base64.

A sample TXT record for the parent domain of `example.com`:

"v=RDBD1;s=2018a;
k=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2LNjBAdNAtZOMdd3hlem
ZF8a0onOcEo5g1KWnKzryDCfH4LZkXOPzAJvz4yKMHW5ykOz9OzGL01GMl8ns8Ly
9ztBXc4obY5wnQpl4nbvOdf6vyLy7Gqgp+dj6RrycSYJdLitiYapHwRyuKmERlQL
6MDWLU9ZSWlqskzLVPgwqtT80xchU65HipKkr2luSAySZyyNEf58pRea3D3pBkLy
5hCDhr2+6GF2q9lJ9qMopd2P/ZXxHkvzl3TFtX6GjP5LTsb2dy3tED7vbf/EyQfV
wrs4495a8OUkOBy7V4YkgKbFYSSkGPmhWoPbV7hCQjEAURWLM9J7EUou3U1WIqTj
1QIDAQAB"

# Validation 

The validation process merely notes a relationship between the domains,
and is not meant to guarantee that the data should be more trustworthy.


# Steps to validate

A validating system should use the combination of the Secondary Domain
and key from the Parent Domain record to be able to recreate the hash 
that is stored in the record for the Secondary Domain.  This is
demonstrated in the appendices.

# Appendix

## Sample Signature

Creation of keys:

openssl genrsa -out rsa.private 2048
openssl rsa -in rsa.private -out rsa.public -pubout -outform PEM

Keys in use:

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

File containing domain, domain.txt:

$ cat domain.txt
foo-example.com

$ openssl dgst -sha256 -sign rsa.private -out foo.sign domain.txt

$ base64 foo.sign
OQHYRUmBjTAYrMlAjZFvq5HTMJFVBcdJCrpS9JbOTAY+v1wa4mKktkpzQhbZlLuKLYFzljF7uHl5
Z5g5x+oyUhQxaDzBFtPYB0sIRZIrqftr09jfnlX4wdHhmgZn00m/D3DJ0/RMGYK8SmkbzzLKqzce
9K56oNRsP3GUaympykq/tj512IfVJDxTt4ccqAopVYEvLYuFnQ0d6lP4FC20CTGaNlD+vdZgryl2
aJE7PSotJ/tDc5u6jmpRa0uhzwyE2Xmbr1X5+gymF99sT4lnfvsUsk6Nlpbk1SXdB52GZJ4qr6Km
8tEVvDK0soJ89FhTwpb0NsTBAQxFpcaTyka7uQ==

The published record would be:
"v=RDBD1;s=2018a;d=example.com;
h=OQHYRUmBjTAYrMlAjZFvq5HTMJFVBcdJCrpS9JbOTAY+v1wa4mKktkpzQhbZlLuKLYFzljF7uHl5
Z5g5x+oyUhQxaDzBFtPYB0sIRZIrqftr09jfnlX4wdHhmgZn00m/D3DJ0/RMGYK8SmkbzzLKqzce
9K56oNRsP3GUaympykq/tj512IfVJDxTt4ccqAopVYEvLYuFnQ0d6lP4FC20CTGaNlD+vdZgryl2
aJE7PSotJ/tDc5u6jmpRa0uhzwyE2Xmbr1X5+gymF99sT4lnfvsUsk6Nlpbk1SXdB52GZJ4qr6Km
8tEVvDK0soJ89FhTwpb0NsTBAQxFpcaTyka7uQ=="

To verify:

with "foo.base64" containing the above signature:

$ openssl base64 -d -in foo.base64 -out sign.sha256

$ openssl dgst -sha256 -verify rsa.public -signature sign.sha256 domain.txt
Verified OK

# Security Concerns

## DNSSEC

This mechanism does not require DNSSEC. It could be possible for an
attacker to falsify DNS query requests while investigating a
relationship. Consider that in these cases, a relationship could be
falsified.  Deploying signed records with DNSSEC could be considered
an advantage, and an additional defense against that type of attack.


# Contributors





{backmatter}


%%%

   Title = "Related Domains By DNS"
   abbrev = "RDBD"
   category = "std"
   docName = "draft-ietf-uta-brotman-rdbd-01"
   ipr = "trust200902"
   area = "Applications"
   workgroup = "uta"
   keyword = [""]

   date = 2018-03-07T00:00:00Z
   
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
investigations on the Internet.  It is typical to see
something such as `example.com` and `dept-example.com` and be unsure if 
there is an actual relationship between thosetwo domains, or if it  might be an 
attacker attempting to impersonate the original domain.  Providers
may err on the side of caution and mark the secondary domain as spam
or invalid because it is not clear that they should be related.

By using "Related Domains By DNS", or "RDBD", it will be possible to
determine that there is a relationship between those two domains.
This mechanism will include a public key hosted at the parent domain
("example.com") and a reference from the secondary domain 
("dept-example.com") along with a hash of the text representation of 
that domain.

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

Appendix C of {@!RFC6376] has some reference material on 
how to create a set of keys for use in this type of situation. The key
length is recommended to be 2048 bits instead of the 1024 in that
appendix.

# DNS Record for Secondary Domain

There are a few options when publishing the reference to the parent domain.

* `v`: Version string, which should be set to `RDBD1`.
* `d`: The Parent Domain.  This should be in the form of "example.com".
* `s`: The selector, which is the same as defined in [@!RFC6376] and
  used to denote which published public key should be used.
* `h`: The sha256 hash of the secondary domain, creating using the private key.

A sample TXT record for `dept-example.com` would appear as:

"v=RDBD1;d=example.com;s=2018a;h=3f3af3a3fa3298t32g;"

# DNS Record for Parent Domain

* `v`: Version string, which should be set to `RDBD1`.
* `s`: The selector, which is the same as defined in [@!RFC6376] and
  used to denote a specific public key published by the Parent Domain.
* `k`: The public key published for this selector.

A sample TXT record for the parent domain of `example.com`:

"v=RDBD1;s=2018a;k=af3ajalkuay3f7yaiuyf3lua3ylkjfh;"

# Validation 

# Appendix

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

Determining relationships can be one of the more difficult
investigations on the Internet.  It is quite typical to see
something `example.com` and `dept-example.com` and be unsure if 
there is an actual relationship between those, or if it's an 
attacker attempting to impersonate the original domain.  Many providers
might err on the side of caution and mark the secondary domain as spam
or invalid because it is not clear that they should be related.

Using "Related Domains By DNS", or "RDBD", it will be possible to
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

# DNS Record for Secondary Domain

# DNS Record for Parent Domain

# Validation 

# Appendix

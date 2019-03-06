#!/usr/bin/env python3
import sys, binascii
from eddsa2 import Ed25519

# secret chosen to be 32 octets funnily enuugh:-)
secret="rdbd-example0001rdbd-example0002".encode('utf-8')
privkey,pubkey = Ed25519.keygen(secret)
msg=open('to-be-signed-15.txt','r').read().encode('utf-8')
signature = Ed25519.sign(privkey, pubkey, msg)

print("private:"+ str(binascii.hexlify(privkey)))
print("public:"+ str(binascii.hexlify(pubkey)))
print("sig:"+ str(binascii.hexlify(signature)))
print("to-be-signed:" + str(msg))

with open("ed25519.sig", "wb") as sigf:
    sigf.write(signature)
with open("ed25519.pub","wb") as pubf:
    pubf.write(pubkey)



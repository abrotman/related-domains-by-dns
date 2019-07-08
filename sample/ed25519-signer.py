#!/usr/bin/env python3
# CODE_BEGINS
import argparse, sys, binascii
from eddsa2 import Ed25519

def main():
    parser=argparse.ArgumentParser(description='Ed25519 signing')
    parser.add_argument('-s','--secret',dest='secret', help='secret key')
    parser.add_argument('-r','--relating',dest='relating', help='relating domain')
    parser.add_argument('-r','--related',dest='related', help='related domain')
    args=parser.parse_args()

    # secret chosen to be 32 octets funnily enuugh:-)
    # secret="rdbd-example0001rdbd-example0002".encode('utf-8')
    if args.secret is None:
        print("You do need a secret... - exiting")
        sys.exit(1)
    secret=args.secret.encode('utf-8')
    privkey,pubkey = Ed25519.keygen(secret)
    print("private:"+ str(binascii.hexlify(privkey)))
    print("public:"+ str(binascii.hexlify(pubkey)))
    with open("ed25519.priv", "wb") as privf:
        privf.write(privkey)
    with open("ed25519.pub","wb") as pubf:
        pubf.write(pubkey)
    msg_str=args.relating+". IN 3600 RDBD 1" args.related

    print("to-be-signed:" + str(msg_str))
    msg=msg_str.encode('utf-8')
    signature = Ed25519.sign(privkey, pubkey, msg)
    print("sig:"+ str(binascii.hexlify(signature)))
    with open("ed25519.sig", "wb") as sigf:
        sigf.write(signature)
    return

if __name__ == "__main__":
    main()

# CODE_ENDS

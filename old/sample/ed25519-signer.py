#!/usr/bin/env python3
# CODE_BEGINS
import argparse, sys, binascii
from eddsa2 import Ed25519
from keytag3 import calc_keyid

def main():
    parser=argparse.ArgumentParser(description='Ed25519 signing')
    parser.add_argument('-s','--secret',dest='secret', help='secret key')
    parser.add_argument('-r','--relating',dest='relating', help='relating domain')
    parser.add_argument('-d','--related',dest='related', help='related domain')
    parser.add_argument('-n','--negative',dest='negative', help='negative assertion')
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

    tbs="relating="+args.relating+"\nrelated="+args.related+"\nrdbd-tag="+rdbdtag+"\nkey-tag="+str(keyid)+"\nsig-alg=15\n"
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

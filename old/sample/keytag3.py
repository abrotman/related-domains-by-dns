#!/usr/bin/env python3
import struct, hashlib, base64, os, sys, argparse, gc, json


# from https://gist.github.com/wido/4c6288b2f5ba6d16fce37dca3fc2cb4a
def calc_keyid(flags, protocol, algorithm, dnskey):
    st = struct.pack('!HBB', int(flags), int(protocol), int(algorithm))
    st += base64.b64decode(dnskey)
    cnt = 0
    for idx in range(len(st)):
        s = struct.unpack('B', st[idx:idx+1])[0]
        if (idx % 2) == 0:
            cnt += s << 8
        else:
            cnt += s
    return ((cnt & 0xFFFF) + (cnt >> 16)) & 0xFFFF

def oldcalc_keyid(flags, protocol, algorithm, st):
  """
  @param owner        The corresponding domain
  @param flags        The flags of the entry (256 or 257)
  @param protocol     Should always be 3
  @param algorithm    Should always be 5
  @param st           The public key as listed in the DNSKEY record.
                      Spaces are removed.
  @return The key tag
  """
  # Remove spaces and create the wire format
  st0=st.replace(' ', '')
  st2=struct.pack('!HBB', int(flags), int(protocol), int(algorithm))
  st2+=base64.b64decode(st0)

  # Calculate the tag
  cnt=0
  for idx in range(len(st2)):
    s=struct.unpack('B', st2[idx])[0]
    if (idx % 2) == 0:
      cnt+=s<<8
    else:
      cnt+=s

  ret=((cnt & 0xFFFF) + (cnt>>16)) & 0xFFFF

  return(ret)

# generate our samples
#rsapub="MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2LNjBAdNAtZOMdd3hlemZF8a0onOcEo5g1KWnKzryDCfH4LZkXOPzAJvz4yKMHW5ykOz9OzGL01GMl8ns8Ly9ztBXc4obY5wnQpl4nbvOdf6vyLy7Gqgp+dj6RrycSYJdLitiYapHwRyuKmERlQL6MDWLU9ZSWlqskzLVPgwqtT80xchU65HipKkr2luSAySZyyNEf58pRea3D3pBkLy5hCDhr2+6GF2q9lJ9qMopd2P/ZXxHkvzl3TFtX6GjP5LTsb2dy3tED7vbf/EyQfVwrs4495a8OUkOBy7V4YkgKbFYSSkGPmhWoPbV7hCQjEAURWLM9J7EUou3U1WIqTj1QIDAQAB"
#print("RSA: " + str(calc_keyid("0","3","8",rsapub)))

#ed25519pub="NT/DHhFoyR8K9l1sJv1EH7fflnGiOnRrs+yGvo01tkg="
#print("Ed25519: " + str(calc_keyid("0","3","15",ed25519pub)))

def main():
    alg=8 # default to RSA, Ed25519 is 15
    pubkey=""
    parser=argparse.ArgumentParser(description='figure out DNSSEC key ids')
    parser.add_argument('-a','--algorithm',type=int,dest='alg', help='algorithm to use')
    parser.add_argument('-p','--public',dest='pubkey', help='base64 encoded public key')
    args=parser.parse_args()
    if args.pubkey is None or args.pubkey=="":
        print("Can't do empty public key - exiting")
        sys.exit(1)
    pubkey=args.pubkey
    if args.alg is not None:
        alg=args.alg
        if alg != 8 and alg != 15:
            print(("Bad alg: " + str(alg) + " - must be 8 or 15"))
            sys.exit(2)
    print((str(calc_keyid("0","3",str(alg),pubkey))))
    return

if __name__ == "__main__":
    main()

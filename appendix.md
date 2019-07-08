# Examples

This appendix provides examples of RDBD-related values.
The following names and other values are used in these examples.

- Relating domain: my.example
- Related domain: my-way.example
- Unrelated domain: my-bad.example
- URL for other related domains: https://example.com/related-names
- URL for other unrelaed domains: https://example.com/unrelateds

The github repo 
https://github.com/abrotman/related-domains-by-dns 
has a script in sample/mk_samples.sh that generated this appendix.

## Unsigned Examples

~~~ ascii-art

;ZONE FILE FRAGMENT STARTS
; assertion that my-way.example claims to be related 
; to my.example
my-way.example. 3600 IN RDBD 1 my.example.

; assertion that my-way.example claims not to be 
; related to my-bad.example
my-way.example. 3600 IN RDBD 0 my-bad.example.

; assertion that my-way.example claims to be related 
; to whatever is at https://example.com/related-names
my-way.example. 3600 IN RDBD 1 https://example.com/related-names

; assertion that my-way.example claims not to be 
; related to whatever is at https://example.com/related-names
my-way.example. 3600 IN RDBD 0 https://example.com/unrelateds

;ZONE FILE FRAGMENT ENDS

~~~


## RSA-signed Example

~~~ ascii-art

# BASH SNIPPET STARTS
# HOWTO generate RSA key pair
$ openssl genrsa -out rsa.private 2048
Generating RSA private key, 2048 bit long modulus (2 primes)
.....................+++++
.....................+++++
e is 65537 (0x010001)
writing RSA key
$ openssl rsa -in rsa.private -out rsa.public -pubout \
     -outform PEM 
$ cat rsa.private
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA3qg68hd/EOys5T4WrhsjXpTPjYoIUzIggTC9N5Q5aBb86/lH
RwHCjrKg6ws31SR9LEqeHMq0Wv/oUZOISs54yLWZWa5B0ZtaJw/3b8wwMFsu2IAO
c5vnYqryR61Ln10CsDRsrzLXxqfGYbnUzZ5WkDjwBYflGw1XfLLSugvAaYIq+gz8
J/SxwLkZqfsR0Jkvcn+kHh51YLNMFNBn8CUElA3tSkWDR9wIK4WK9LRT3e9xc6rH
lHRi/Ubst+E21r7loxfU08OHVeUL0G1F9dEswT8BYaCtUnf3wpWoFknrZD4HWU+E
mG54MDjSQPBNu0iKLS3sBGn6obrmGTMdWSqyxwIDAQABAoIBAFbhBb8Y8/fCoeQB
ShA9fpuVLTdpOL5dvNksD2j0aUH4VlAtQGawhR3xDWEpS2vbhQwXQYKyhZVMbXYH
PxMRZYfLdD7OA9ip6Y98Z2w0HEmCCtFnhjwOBUc2tLrLH8rbHAVtL0tdZ1yYcowH
WsWwls5HqUA/OmJH3m9Fx3vYwgdojL0BfTD9BzMdrRnYGn3D4W+5nyhK3Cfkm3fZ
EYrG7ZfPyGf1eVQ7fMw9U95iANnz52N4fUN8C+EhwgZHCCmlSpK64aPG8dXkNOXW
G99MHL3rw4e+z3XbpNQvzL0xfsqh4vCEImTJ0I7MMRUVuRHK/SV+YHMrstcAKysU
BiO4ogECgYEA9iTg6OHQGSW8hgYxgXx8IgZhkTJI/QrddgZB83g4nypu0KggtQza
qoAomUnw8uT372ACgu2+KFBjiv0BlRPfCJDxNqN3jPfG8H74YpPSjNuw5xe9Jye4
1VJfncqJssEeblHTot43x/MuIewfP4FkbyW2DYGf8NE3rAlNl+Vb3MECgYEA55KY
2i/Q+5edOvKU3N+kctEyjCeZXB3tMCaeDuD+X0IqJEjJiGrE+DN9nmD72ST3p6Tl
umFXxbIT19vb7GVlztCqKHkrr8H3ZX+3lYYIwVpbl8pyKwVGS6UkiCTEEMrXEA4u
NStgFIrCXvMU6IJ9Z2NLHu0GH7tCX8p3/UQWiYcCgYBRp6hI+Whcf01MNM/FgfN4
Ih/J2CGoeCtBlQ/Z4f7+pkf+xlebWDlOKJfPSl05ZsXtTi9nGdFkdE6hdA9LUj1C
DTtIAfCN/kCr1aM2qI1HlzXXY+OnEqFZeysnIGKPv0sGE/UeaZOdrEmYjUlMevND
gAIl9uOFMxLB6pAoHLldwQKBgQCBL95H8l8CzH0xkn0Lj1Q9nYk2eSzsH+Hfd9u7
bzdZSx8ZaOXNTcsesBMHVRGK/T2P78UdKgr+Ri8dwBC7m4GlU/FpbNe7UFlE7XAs
YT7nJxJr5su0RlgGAVYVAXXD7HT4BwEuNkl+jD6NG8zxPULad6FD2nUNJLmNmPVB
fEeaZwKBgDdfhcNhnLNP0CQjPlte5ZStdM0mTT7sxW9kdZdKgjvuNomxEOsPB20j
9GKFXD5WeH+U70l0eQsuX5JPzBDiYczv6KJk9WZlJE+kMzgSehiH2LyBQzGfQqZa
pHeX0ceNO7dbe85QxUUQ9W65ydMvF2D83dj7EIvpUwdgDmA3F5Q/
-----END RSA PRIVATE KEY-----
$ cat rsa.public
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3qg68hd/EOys5T4Wrhsj
XpTPjYoIUzIggTC9N5Q5aBb86/lHRwHCjrKg6ws31SR9LEqeHMq0Wv/oUZOISs54
yLWZWa5B0ZtaJw/3b8wwMFsu2IAOc5vnYqryR61Ln10CsDRsrzLXxqfGYbnUzZ5W
kDjwBYflGw1XfLLSugvAaYIq+gz8J/SxwLkZqfsR0Jkvcn+kHh51YLNMFNBn8CUE
lA3tSkWDR9wIK4WK9LRT3e9xc6rHlHRi/Ubst+E21r7loxfU08OHVeUL0G1F9dEs
wT8BYaCtUnf3wpWoFknrZD4HWU+EmG54MDjSQPBNu0iKLS3sBGn6obrmGTMdWSqy
xwIDAQAB
-----END PUBLIC KEY-----
# To-be-signed data for RSA
$ cat  to-be-signed-8.txt
relating=my.example
related=my-way.example
rdbd-tag=1
key-tag=33971
sig-alg=8
# Sign that
$ openssl dgst -sha256 -sign rsa.private -out rsa.sig \
        to-be-signed-8.txt
# Hexdump of signature
$ hexdump rsa.sig
0000000 a9d7 6ad5 f74b ab42 8dec 6cc3 b992 69ce
0000010 0ef6 19d2 7e8a 26a0 7e31 cea5 8d79 73f6
0000020 1d9a 3222 dc2e d5b6 45b6 5275 9ce9 5a87
0000030 c29e fb91 85b8 33d6 9666 09bc 8d2c d0bd
0000040 a3fd 39da 8b94 7795 6120 8659 f5ec 8358
0000050 dd66 69d6 8f92 3d8b 3176 ae62 98ad a799
0000060 97bc 3db9 2f22 958b a4a3 3c26 7ead c016
0000070 ad8d 701c b3ad 416b b432 e7e5 e360 d2fe
0000080 35ba 4db1 143d d2bb 5cf2 fb21 5bbe 5bce
0000090 a5fb a7ab 528f a74b fe6e 3ef3 8547 5d8a
00000a0 9b1c 3393 459c 335c cc59 2479 5a5b 3de5
00000b0 ab6c 4333 8dac 233e e4ea 98ec ac00 f8d7
00000c0 f0c4 0e15 c737 5479 3247 c648 0127 cfc5
00000d0 c3ef bb05 dc95 4f12 f2ee 723b 9c17 3f24
00000e0 14c3 b225 c581 0134 8531 1800 b816 d775
00000f0 3597 3c68 6225 32e4 7238 c188 5309 ac2c
0000100
# BASH SNIPPET ENDS

; ZONE FILE FRAGMENT STARTS
; The RDBDKEY RR for my.example is...
my.example. 3600 IN RDBDKEY 0 3 8 (
            LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5C
            Z2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUEz
            cWc2OGhkL0VPeXM1VDRXcmhzagpYcFRQallvSVV6SWdnVEM5
            TjVRNWFCYjg2L2xIUndIQ2pyS2c2d3MzMVNSOUxFcWVITXEw
            V3Yvb1VaT0lTczU0CnlMV1pXYTVCMFp0YUp3LzNiOHd3TUZz
            dTJJQU9jNXZuWXFyeVI2MUxuMTBDc0RSc3J6TFh4cWZHWWJu
            VXpaNVcKa0Rqd0JZZmxHdzFYZkxMU3VndkFhWUlxK2d6OEov
            U3h3TGtacWZzUjBKa3ZjbitrSGg1MVlMTk1GTkJuOENVRQps
            QTN0U2tXRFI5d0lLNFdLOUxSVDNlOXhjNnJIbEhSaS9VYnN0
            K0UyMXI3bG94ZlUwOE9IVmVVTDBHMUY5ZEVzCndUOEJZYUN0
            VW5mM3dwV29Ga25yWkQ0SFdVK0VtRzU0TURqU1FQQk51MGlL
            TFMzc0JHbjZvYnJtR1RNZFdTcXkKeHdJREFRQUIKLS0tLS1F
            TkQgUFVCTElDIEtFWS0tLS0tCg== )
; The RDBD RR to be published by my-way.example is...
my-way.example. 3600 IN RDBD 1 my.example 33971 8 (
            16nVakv3QqvsjcNskrnOafYO0hmKfqAmMX6lznmN9nOaHSIy
            Lty21bZFdVLpnIdansKR+7iF1jNmlrwJLI290P2j2jmUi5V3
            IGFZhuz1WINm3dZpko+LPXYxYq6tmJmnvJe5PSIvi5WjpCY8
            rX4WwI2tHHCts2tBMrTl52Dj/tK6NbFNPRS70vJcIfu+W85b
            +6Wrp49SS6du/vM+R4WKXRybkzOcRVwzWcx5JFta5T1sqzND
            rI0+I+rk7JgArNf4xPAVDjfHeVRHMkjGJwHFz+/DBbuV3BJP
            7vI7checJD/DFCWygcU0ATGFABgWuHXXlzVoPCVi5DI4cojB
            CVMsrA== )
; ZONE FILE FRAGMENT ENDS

~~~


## Ed25519-signed Example

~~~ ascii-art
# BASH SNIPPET STARTS
# HOWTO generate an Ed25519 key pair...
$ ./ed25519-signer.py -s rdbd-example0001rdbd-example0002 \
   -r my.example -d my-way.example
private:b'726462642d6578616d706c6530303031726462642d6578616d
706c6530303032'
public:b'353fc31e1168c91f0af65d6c26fd441fb7df9671a23a746bb3e
c86be8d35b648'
b64pubkey: NT/DHhFoyR8K9l1sJv1EH7fflnGiOnRrs+yGvo01tkg=
keyid: 35988
to-be-signed:|relating=my.example
related=my-way.example
rdbd-tag=1
key-tag=35988
sig-alg=15
|
sig:b'64bc444ce759fb9435fe9c1875eb241c4ec6d0995cd8138a372782
32fc8e79f53cb8f88059f6040054c61be8cfd73fd44521f73994628fc7c3
0135fa929ab00f'
# hex dump of Ed25519 private
$ hexdump ed25519.priv
0000000 6472 6462 652d 6178 706d 656c 3030 3130
0000010 6472 6462 652d 6178 706d 656c 3030 3230
0000020
# hex dump of Ed25519 public
$ hexdump ed25519.pub
0000000 3f35 1ec3 6811 1fc9 f60a 6c5d fd26 1f44
0000010 dfb7 7196 3aa2 6b74 ecb3 be86 358d 48b6
0000020
# hex dump of Ed25519 signature
$ hexdump ed25519.sig
0000000 bc64 4c44 59e7 94fb fe35 189c eb75 1c24
0000010 c64e 99d0 d85c 8a13 2737 3282 8efc f579
0000020 b83c 80f8 f659 0004 c654 e81b d7cf d43f
0000030 2145 39f7 6294 c78f 01c3 fa35 9a92 0fb0
0000040
# BASH SNIPPET ENDS

; ZONE FILE FRAGMENT STARTS
; The RDBDKEY RR for my.example is...
my.example. 3600 IN RDBDKEY 0 3 15 (
            NT/DHhFoyR8K9l1sJv1EH7fflnGiOnRrs+yGvo01tkg= ) 
; The RDBD RR to be published by my-way.example is...
my-way.example. 3600 IN RDBD 0 my.example 35988 15 (
            ZLxETOdZ+5Q1/pwYdeskHE7G0Jlc2BOKNyeCMvyOefU8uPiA
            WfYEAFTGG+jP1z/URSH3OZRij8fDATX6kpqwDw== ) 
; ZONE FILE FRAGMENT ENDS

~~~

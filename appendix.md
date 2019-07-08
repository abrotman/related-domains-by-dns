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
MIIEowIBAAKCAQEA8qpGa2i6O76MdGiFVYGgd6UDYfUNl4qHpXfzmrqawUqb8JHM
5m8hjLTbKDGRpZJA5m9sQlaM41hQxpAPuW3mJXYvVOiqxtRCBlVTvUCR+Gkah7LU
FT54U8PT+ciF2or2ArL7O1LIT1PnEL0AZsbM6FwYLsRE8RX89PqeL9N/U4xJ7jQq
SRK88bnRRFs+W7F+iQuA5erHfIZHftq+yzRG8rtgTN7HvTOewkDa2XS2Tn/z0tRV
wNUX4Mi4e/DaEZU0u3kn7HqL0hyBXz/EEHUq9+57BURUT/ZQ41ORGgJ/4+tv2Gp8
mp1ydOJaAhzgqky2zGBL1RS+mBFCio9dXBIJywIDAQABAoIBAQDwE7ITtcr6LKy8
xmOTkul1NVZBZbYKxU0qUaA65n8Q2IWq3jR/jlb85DkmbNQRoL6AvJ+4ifRdQBS6
PfCwnZ/iVCjDsmSyzXB835I3XFiOET3kHvJgCiv1g3qGVvLGolB9nyGbMW1nvjSO
hM6O4AP9po9uRVOHyR84J3K1EmOX/PgmITPel61CEe+IdYwX3K3w1Mmm9C3ZSitx
rx8gpWHknpAG9Z+DA+f406TFTFtuTQe6xCDjKl0/uUGsT62UQqEiw00wekm8e+2b
rDdtqu61Lqq1aakhtGlozXIT7ED+oobp6cAnM1QbV09z7zZevXl95yrXt9xZ3odS
HNcHnMCRAoGBAP6N00vMmplk76OOJ738Twf6fsaL+zkwNmL74Rv85LJn96p6xQUm
wJdMsa7HoD7LwuxhJkhDbdTiq+oV+Mc4J+FAe5xRK5vD7wVmPNWtUcvwdTZXnpNr
6fU28PqL76feU22G/V2mthgKOXPvYehcteAJAEGbLwQoo1Q7qZa7Q9i/AoGBAPQL
KSqcOzGHJ57iYN+HbN0cqXpBburA7dZstl6WiwQO0U4+KsJ3eyyuUE0Mz6epXeQD
Ry1W8yoH9ypfLDEP3YwP3wp7dqISyGAzsRospGyGJ0tHkQ3orW+/6PgSl9W2aJV2
LqyfOPutrjfIRUkgALMq8cTRxR1xpx0HpVfOMCX1AoGAJi9SPfGgU1hf1lIRxh8e
H91EvTXsZqTD089i8lbaW6Ta8xjdiytIAqo/kS9i62iXgewE2Rw8Uo36KfBH1GKp
INISeN14RDJ9HXs7rvYD6irU+mTkZcrvWph2R69MMQtZynlQcob6k9qcybZkIn4d
zlCrWCwWPnJ2JcGZbAIFaHMCgYBXIdD95LABu/a6dKsPxANrYrtj6g7XBDEmuMPY
O7nApiW24N1Vd2FkD4yeJe/SNddO/JiiKIRDQnrOBxL5JWf9hQEmdfRiY4BlUK9v
3/aIxNEswI2awLODzao5QDIz3J+0lXCOs36d5WHpiriqJiH51mBh3F+bZqO66qrv
EbABLQKBgDUhcsEyIMI6oygKO/L+iVOZM+ao+64TtKxqUmgHU+gBgvdkY8h9GvxY
kL7L1hBOB9bAyP8ObU18R5CMbQgO7PITACRoU+uYIiQ67UREDKjBRtoDcgK0JrRX
kqy4v6LuuFCpS5OJKQL6rKfk2XNSjDD1ZwLuBZjHQDdc/gnn7XRx
-----END RSA PRIVATE KEY-----
$ cat rsa.public
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8qpGa2i6O76MdGiFVYGg
d6UDYfUNl4qHpXfzmrqawUqb8JHM5m8hjLTbKDGRpZJA5m9sQlaM41hQxpAPuW3m
JXYvVOiqxtRCBlVTvUCR+Gkah7LUFT54U8PT+ciF2or2ArL7O1LIT1PnEL0AZsbM
6FwYLsRE8RX89PqeL9N/U4xJ7jQqSRK88bnRRFs+W7F+iQuA5erHfIZHftq+yzRG
8rtgTN7HvTOewkDa2XS2Tn/z0tRVwNUX4Mi4e/DaEZU0u3kn7HqL0hyBXz/EEHUq
9+57BURUT/ZQ41ORGgJ/4+tv2Gp8mp1ydOJaAhzgqky2zGBL1RS+mBFCio9dXBIJ
ywIDAQAB
-----END PUBLIC KEY-----
# To-be-signed data for RSA
$ cat  to-be-signed-8.txt
relating=my.example
related=my-way.example
rdbd-tag=1
key-tag=38501
sig-alg=8
# Sign that
$ openssl dgst -sha256 -sign rsa.private -out rsa.sig \
        to-be-signed-8.txt
# Hexdump of signature
$ hexdump rsa.sig
0000000 8664 bd57 8cbf a8e1 9182 1b5f a4fc 5eb9
0000010 49b4 fe21 f1c7 8097 ed90 44a5 bcb1 543c
0000020 f784 c190 e1d9 2f2b 18ca d3c2 640f 3823
0000030 7f8a e446 d0eb bd14 6077 0597 6015 a82b
0000040 42d7 8677 b1a3 37fa a1e8 8109 07ec ff62
0000050 16b8 3895 66de d992 dc4d ed99 9ec3 0a62
0000060 6a07 3baa 45f2 d528 1e83 a147 60ce 9b25
0000070 a967 4ba0 3fb5 98db 5ff3 b070 058b 4d8f
0000080 f198 6c1f e6b6 7a6c 1e8c ad42 237f 5440
0000090 7856 caac f96c f87d e79c 4dc5 b833 bc03
00000a0 c52e 5603 46a7 59b5 9fe3 fccd 04ee e908
00000b0 71e7 21f8 47ad fea8 40bf 14a5 9e6b b3d4
00000c0 c61a 5b96 c559 3491 4dfa 91a0 4c0b f3ff
00000d0 e460 484c 7e49 5368 85e3 16be fe6b 809a
00000e0 117d c2cb be19 c5ba 7594 2f60 16ad 1132
00000f0 f978 6ca1 5448 180f 8ca7 e73d 1137 7064
0000100
# BASH SNIPPET ENDS

; ZONE FILE FRAGMENT STARTS
; The RDBDKEY RR for my.example is...
my.example. 3600 IN RDBDKEY 0 3 8 (
            LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5C
            Z2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUE4
            cXBHYTJpNk83Nk1kR2lGVllHZwpkNlVEWWZVTmw0cUhwWGZ6
            bXJxYXdVcWI4SkhNNW04aGpMVGJLREdScFpKQTVtOXNRbGFN
            NDFoUXhwQVB1VzNtCkpYWXZWT2lxeHRSQ0JsVlR2VUNSK0dr
            YWg3TFVGVDU0VThQVCtjaUYyb3IyQXJMN08xTElUMVBuRUww
            QVpzYk0KNkZ3WUxzUkU4Ulg4OVBxZUw5Ti9VNHhKN2pRcVNS
            Szg4Ym5SUkZzK1c3RitpUXVBNWVySGZJWkhmdHEreXpSRwo4
            cnRnVE43SHZUT2V3a0RhMlhTMlRuL3owdFJWd05VWDRNaTRl
            L0RhRVpVMHUza243SHFMMGh5Qlh6L0VFSFVxCjkrNTdCVVJV
            VC9aUTQxT1JHZ0ovNCt0djJHcDhtcDF5ZE9KYUFoemdxa3ky
            ekdCTDFSUyttQkZDaW85ZFhCSUoKeXdJREFRQUIKLS0tLS1F
            TkQgUFVCTElDIEtFWS0tLS0tCg== )
; The RDBD RR to be published by my-way.example is...
my-way.example. 3600 IN RDBD 1 my.example 38501 8 (
            ZIZXvb+M4aiCkV8b/KS5XrRJIf7H8ZeAkO2lRLG8PFSE95DB
            2eErL8oYwtMPZCM4in9G5OvQFL13YJcFFWArqNdCd4ajsfo3
            6KEJgewHYv+4FpU43maS2U3cme3DnmIKB2qqO/JFKNWDHkeh
            zmAlm2epoEu1P9uY819wsIsFj02Y8R9stuZseoweQq1/I0BU
            Vnisymz5ffic58VNM7gDvC7FA1anRrVZ45/N/O4ECOnncfgh
            rUeo/r9ApRRrntSzGsaWW1nFkTT6TaCRC0z/82DkTEhJfmhT
            44W+Fmv+moB9EcvCGb66xZR1YC+tFjIRePmhbEhUDxinjD3n
            NxFkcA== )
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
my-way.example. 3600 IN RDBD 1 my.example 35988 15 (
            ZLxETOdZ+5Q1/pwYdeskHE7G0Jlc2BOKNyeCMvyOefU8uPiA
            WfYEAFTGG+jP1z/URSH3OZRij8fDATX6kpqwDw== ) 
; ZONE FILE FRAGMENT ENDS

~~~

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
my-way.example. IN 3600 RDBD 1 my.example.

; assertion that my-way.example claims not to be 
; related to my-bad.example
my-way.example. IN 3600 RDBD 0 my-bad.example.

; assertion that my-way.example claims to be related 
; to whatever is at https://example.com/related-names
my-way.example. IN 3600 RDBD 1 https://example.com/related-names

; assertion that my-way.example claims not to be 
; related to whatever is at https://example.com/related-names
my-way.example. IN 3600 RDBD 0 https://example.com/unrelateds

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
MIIEpQIBAAKCAQEA5OvJEEMA9NJ3YvzgN+XB72wUujnSY3jXhTO70xKtC+Nzwdnj
qFQ0SV36vAfuOW8q9DzJf4mWXL1Hi3uvY52Ll+ySXSAWXP2gJEKZnNq05vCWg7SJ
jc5KM9cMc3UUoV9bQXw59gz6IztomXNJWPlE7UqKsAMLEGjnitlmDDDmX+zOzbhR
L3VymB88ka3ALewFsbOGCiBRA2n6yo3usBUKYz6hYzb4HomQIQmRxUbM1uHJ+o/V
844fLU7mlGzhAauOh+ZXN/OSjaQhA+RM+v+54nzPWlMPM5KHOp7DRml5H2ipogal
o7yhysdnWZn5t4SoNpp7AJXkqq4m46kg5VbriQIDAQABAoIBAQC4Ptmt3+/GHBsA
rbyc4KwNUjUAiYc+jkUQLUovoOlsFx3U2NS1Z0hKAHzMl6lxynqM5tvabVd6vtD1
f4/zIhr3JO3MTAYTxAH/DSdrqk9NTDgoOsc3PeBVBvE7f/EhzIi7FQvlcB5m+uq+
Dp7rIH0MayFidqCSDYzGISFUEItqib0YBHlYxTqMS2wWV+sYGqKPkbGXKifPVNmC
KYSemli0898HdCx/VG0F57WM0eizkbjK0QvcVsCsVcVikR0p8tf7AojPJPN3WKZP
vH+j9kqvk0eMqV4mwR9iVVfryO6ca4SYlRbpIbxRQLtbeP2aA2IEJcbo58P7xFz4
Bf/cbnctAoGBAPtSpOjfgH7sTblTNKqRIaJXqIx98YPVxubCPrkoOHRP7I225qow
aezF6o+CIfkCodj7R5HS+S4G+ORLRvFZyH9E6sEe0ol68EfJb4t6UudsccDeXSkw
82Dsd3187P/sZCLg2MG7FIUHSj5AZqlrJgp2GRiwRDwsCRIHHG2GVN0DAoGBAOku
ag66VvHFXdr2+SrP0y8atwy+SQY3p+/u4e6WrxlctxIH9Wk2mp7V+vS1ikPSpWdm
5HzOyQN6/uqznmNYT7ASz4nDMllowv4gZPxIxQSO34V4KmXsuhNMHcc4eTcEZ8mD
FQOxP2TnawaDLnb9QBBvKMfn3xhho7bQ74j0nvGDAoGBAKL81+IGgIjPqyBTK8aq
VIu6GZ7zVpvPGi0xMAhYYzRbWOgXA8S/nRJm0FW9aVbaNChJ3gJeNid5chRsFVgU
iAixoyUXXia2yflkU6i67eUT2Tnhe71o942WDXAegnz+y3orI6eQMiCLt8Rjc7DP
wl3qdSAjwDzdugws/GyzP3oNAoGBANZzsmSjKW0neB72PsgJ5I6QwkK9Cknmi9PV
XgJgoN7xbwjtOt2ts1xbLXc7MtMXerlzXrYOM764spNF6Ggzgu5LDoYDeF3URGkV
f+qqPk/n2lhU4KFmqucufMCJBqn7qjwhCwWfUM9LKhoOMYCLfwzePqJDdOFmgvuS
gonxd/BjAoGAG5TN5BepmSmL7vGUmPssavjnkP3T1uGSRrKy8JYBoYHtY3VAMTg/
BLuDtM4inZ3W3Zr7ECP5epqaL0IK9X5452Zn21JDyRRTGMfwR2EnktMVwpWNiiNm
35nUNhBTdNLpZoMvLDBQS7UM76saFDm6XQgtU/J/jrHvtPWgAzlJq4E=
-----END RSA PRIVATE KEY-----
$ cat rsa.public
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5OvJEEMA9NJ3YvzgN+XB
72wUujnSY3jXhTO70xKtC+NzwdnjqFQ0SV36vAfuOW8q9DzJf4mWXL1Hi3uvY52L
l+ySXSAWXP2gJEKZnNq05vCWg7SJjc5KM9cMc3UUoV9bQXw59gz6IztomXNJWPlE
7UqKsAMLEGjnitlmDDDmX+zOzbhRL3VymB88ka3ALewFsbOGCiBRA2n6yo3usBUK
Yz6hYzb4HomQIQmRxUbM1uHJ+o/V844fLU7mlGzhAauOh+ZXN/OSjaQhA+RM+v+5
4nzPWlMPM5KHOp7DRml5H2ipogalo7yhysdnWZn5t4SoNpp7AJXkqq4m46kg5Vbr
iQIDAQAB
-----END PUBLIC KEY-----
# To-be-signed data for RSA
$ cat  to-be-signed-8.txt
relating=my.example
related=my-way.example
rdbd-tag=1
key-tag=7460
sig-alg=8
# Sign that
$ openssl dgst -sha256 -sign rsa.private -out rsa.sig \
        to-be-signed-8.txt
# Hexdump of signature
$ hexdump rsa.sig
0000000 8f5e a53a adbe 2943 28f1 c912 0316 0037
0000010 530f a8a6 87ce 1676 112a b87b ebb2 f595
0000020 8a68 8020 8dc5 8fe6 c1d2 d210 dd61 9425
0000030 ac26 a348 7499 b4cd 48e9 b449 19eb 928f
0000040 b12f 766f 7aba fe30 caea c3a4 8a1f 9eaa
0000050 3496 879d 124e 39a0 427e f293 819d c6a4
0000060 19f3 c697 6e83 b773 7ab9 5372 b29e 4c8d
0000070 cfdb 7b74 8ec4 f8f4 c7e0 8939 1ada f32e
0000080 e8b6 461c 2ac4 a578 4b85 e622 0048 5e5c
0000090 8465 5fb5 e90f 9276 bc22 081a 593c 71fa
00000a0 8777 4fb6 2f52 82c9 453d 9cc2 e071 cae5
00000b0 1c67 a82d 6a1c 9fa9 97d6 2f06 70e8 cf83
00000c0 3fe1 a316 b693 bc3c 95e6 18c9 c29a 8aac
00000d0 5506 c133 fc3e 4cc7 7b42 5728 b12a 5d9d
00000e0 f744 97c9 5910 3135 526c 7406 8e08 3d44
00000f0 37de ae25 c97f a1e7 7e9e b571 f6c8 4fad
0000100
# BASH SNIPPET ENDS

; ZONE FILE FRAGMENT STARTS
; The RDBDKEY RR for my.example is...
my.example. IN 3600 RDBDKEY 0 3 8 (
            LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5C
            Z2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUE1
            T3ZKRUVNQTlOSjNZdnpnTitYQgo3MndVdWpuU1kzalhoVE83
            MHhLdEMrTnp3ZG5qcUZRMFNWMzZ2QWZ1T1c4cTlEekpmNG1X
            WEwxSGkzdXZZNTJMCmwreVNYU0FXWFAyZ0pFS1puTnEwNXZD
            V2c3U0pqYzVLTTljTWMzVVVvVjliUVh3NTlnejZJenRvbVhO
            SldQbEUKN1VxS3NBTUxFR2puaXRsbURERG1YK3pPemJoUkwz
            VnltQjg4a2EzQUxld0ZzYk9HQ2lCUkEybjZ5bzN1c0JVSwpZ
            ejZoWXpiNEhvbVFJUW1SeFViTTF1SEorby9WODQ0ZkxVN21s
            R3poQWF1T2grWlhOL09TamFRaEErUk0rdis1CjRuelBXbE1Q
            TTVLSE9wN0RSbWw1SDJpcG9nYWxvN3loeXNkbldabjV0NFNv
            TnBwN0FKWGtxcTRtNDZrZzVWYnIKaVFJREFRQUIKLS0tLS1F
            TkQgUFVCTElDIEtFWS0tLS0tCg== )
; The RDBD RR to be published by my-way.example is...
my-way.example. IN 3600 RDBD 1 my.example 7460 8 (
            Xo86pb6tQynxKBLJFgM3AA9TpqjOh3YWKhF7uLLrlfVoiiCA
            xY3mj9LBENJh3SWUJqxIo5l0zbTpSEm06xmPki+xb3a6ejD+
            6sqkwx+Kqp6WNJ2HThKgOX5Ck/KdgaTG8xmXxoNuc7e5enJT
            nrKNTNvPdHvEjvT44Mc5idoaLvO26BxGxCp4pYVLIuZIAFxe
            ZYS1Xw/pdpIivBoIPFn6cXeHtk9SL8mCPUXCnHHg5cpnHC2o
            HGqpn9aXBi/ocIPP4T8Wo5O2PLzmlckYmsKsigZVM8E+/MdM
            QnsoVyqxnV1E98mXEFk1MWxSBnQIjkQ93jclrn/J56GefnG1
            yPatTw== )
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
my.example. IN 3600 RDBDKEY 0 3 15 (
            NT/DHhFoyR8K9l1sJv1EH7fflnGiOnRrs+yGvo01tkg= ) 
; The RDBD RR to be published by my-way.example is...
my-way.example. 3600 RDBD 0 my.example 35988 15 (
            ZLxETOdZ+5Q1/pwYdeskHE7G0Jlc2BOKNyeCMvyOefU8uPiA
            WfYEAFTGG+jP1z/URSH3OZRij8fDATX6kpqwDw== ) 
; ZONE FILE FRAGMENT ENDS

~~~

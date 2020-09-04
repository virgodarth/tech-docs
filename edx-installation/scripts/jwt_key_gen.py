# Author: Virgo Darth
# Time: Sep 4, 2020

import getpass

from Cryptodome.PublicKey import RSA
from jwkest import jwk


KEY_SIZE = 2048  # recommended

key_phase = getpass.getpass(prompt='Enter your key phase: ')
print()

rsa_alg = RSA.generate(KEY_SIZE)

# generate private key
rsa_jwk = jwk.RSAKey(kid=key_phase, key=rsa_alg)

# generate public key
public_keys = jwk.KEYS()
public_keys.append(rsa_jwk)

# convert to string
serialized_private_keys = rsa_jwk.__str__()
serialized_public_keys = public_keys.dump_jwks()

print("=====Start JWT_PRIVATE_SIGNING_JWK=====\n", serialized_private_keys, "\n=====End JWT_PRIVATE_SIGNING_JWK=====\n")
print("=====Start JWT_PUBLIC_SIGNING_JWK_SET=====\n", serialized_public_keys, "\n=====End JWT_PUBLIC_SIGNING_JWK_SET=====")

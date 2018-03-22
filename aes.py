from Crypto import Random
from Crypto.Cipher import AES
import hashlib

class cryptor:
    """
    Encrypt and Decrypt Data/Strings via AES in Python

    Example Usage:
        from aes import cryptor
        cipher = cryptor('Really Strong Key')
        encrypted = cipher.encrypt('Hello World!')
        decrypted = cipher.decrypt(encrypted)
        print encrypted
        print decrypted
    """
    def __init__( self, key ):
        H = hashlib.sha1(); H.update(key)
        self.pad = lambda self, s: s + (self.BS - len(s) % self.BS) * "\x00"
        self.unpad = lambda self, s : s.rstrip('\x00')
        self.toHex = lambda self, x:"".join([hex(ord(c))[2:].zfill(2) for c in x])
        self.BS = 16
        self.key = H.hexdigest()[:32]
    def encrypt( self, raw ):
        raw = self.pad(self, raw)
        iv = Random.new().read( AES.block_size )
        cipher = AES.new( self.key, AES.MODE_CBC, iv )
        return self.toHex(self, iv + cipher.encrypt( raw ) )
    def decrypt( self, enc ):
        enc = (enc).decode("hex_codec")
        iv = enc[:16]
        cipher = AES.new(self.key, AES.MODE_CBC, iv )
        return self.unpad(self, cipher.decrypt( enc[16:] ))

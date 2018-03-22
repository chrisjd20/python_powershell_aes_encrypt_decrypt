# python_powershell_aes_encrypt_decrypt
python to powershell string encrypt and decrypt

# Python:

from aes import cryptor

cipher = cryptor('Really Strong Key')

encrypted = cipher.encrypt('Hello World!')

decrypted = cipher.decrypt(encrypted)

print encrypted

print decrypted

![alt text](https://raw.githubusercontent.com/chrisjd20/python_powershell_aes_encrypt_decrypt/master/pythonaes.png)

# PowerShell

$key = 'Really Strong Key'

$unencryptedString = "Hello World!"

$encryptedString = Encrypt-String $key $unencryptedString

$encryptedString

$decryptedString = Decrypt-String $key "6781c750387b405fb79f57cd34b312189e61a26d204a97b20a57f9109cfe09f5"

$decryptedString


![alt text](https://raw.githubusercontent.com/chrisjd20/python_powershell_aes_encrypt_decrypt/master/powershellaes.png)

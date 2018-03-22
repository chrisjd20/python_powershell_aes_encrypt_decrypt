
function Create-AesManagedObject($key, $IV) {
    $aesManaged = New-Object "System.Security.Cryptography.AesManaged"
    $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
    $aesManaged.BlockSize = 128
    $aesManaged.KeySize = 256
    if ($IV) {
        if ($IV.getType().Name -eq "String") {
            $aesManaged.IV = $IV
        }
        else {
            $aesManaged.IV = $IV
        }
    }
    $aesManaged.Key = [system.Text.Encoding]::UTF8.GetBytes($key)
    $aesManaged
}

function Create-AesKey() {
    $aesManaged = Create-AesManagedObject
    $aesManaged.GenerateKey()
    return $( Convert-BytesToHEX $aesManaged.Key)
}

function Encrypt-String($key, $unencryptedString) {
    $key = (Get-StringHash32 $key)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($unencryptedString)
    $aesManaged = Create-AesManagedObject $key
    $encryptor = $aesManaged.CreateEncryptor()
    $encryptedData = $encryptor.TransformFinalBlock($bytes, 0, $bytes.Length);
    [byte[]] $fullData = $aesManaged.IV + $encryptedData
    $aesManaged.Dispose()
    return $( Convert-BytesToHEX $fullData)
}

function Get-StringHash32 ($String) {
    #only grabs first 32 bytes of hash since thats what our python encryptor does
    $StringBuilder = New-Object System.Text.StringBuilder 
    [System.Security.Cryptography.HashAlgorithm]::Create("SHA1").ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))|%{ 
    [Void]$StringBuilder.Append($_.ToString("x2")) 
    } 
    return ($StringBuilder.ToString()).Substring(0,32)
}

function Decrypt-String($key, $encryptedStringWithIV) {
    $key = (Get-StringHash32 $key)
    $bytes = $( Convert-HexToBytes $encryptedStringWithIV)
    $IV = $bytes[0..15]
    $aesManaged = Create-AesManagedObject $key $IV
    $decryptor = $aesManaged.CreateDecryptor();
    $unencryptedData = $decryptor.TransformFinalBlock($bytes, 16, $bytes.Length - 16);
    $aesManaged.Dispose()
    [System.Text.Encoding]::UTF8.GetString($unencryptedData).Trim([char]0)
}

function Convert-BytesToHEX {
    param($DEC)
    $tmp = ''
    ForEach ($value in $DEC){
        $a = "{0:x}" -f [Int]$value
        if ($a.length -eq 1){
            $tmp += '0' + $a
        } else {
            $tmp += $a
        }
    }
    $tmp
}

function Convert-HexToBytes {
    param($HEX)
    $HEX = $HEX -split '(..)' | ? { $_ }
    ForEach ($value in $HEX){
        [Convert]::ToInt32($value,16)
    }
}

#Example:
#$key = 'Really Strong Key'
#$unencryptedString = "Hello World!"
#$encryptedString = Encrypt-String $key $unencryptedString
#$encryptedString
#$decryptedString = Decrypt-String $key "6781c750387b405fb79f57cd34b312189e61a26d204a97b20a57f9109cfe09f5"
#$decryptedString
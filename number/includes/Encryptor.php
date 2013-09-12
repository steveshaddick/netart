<?php

class Encryptor {

	public static function encrypt($text, $salt) 
    { 
        return base64_encode(mcrypt_encrypt(MCRYPT_RIJNDAEL_256, md5($salt), $text, MCRYPT_MODE_CBC, md5(md5($salt))));
        
    }

    public static function decrypt($crypt, $salt) 
    { 
    	
        return rtrim(mcrypt_decrypt(MCRYPT_RIJNDAEL_256, md5($salt), base64_decode($crypt), MCRYPT_MODE_CBC, md5(md5($salt))), "\0");
    } 

}

?>
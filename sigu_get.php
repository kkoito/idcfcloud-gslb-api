<?php

$api_key = 'xxxxxxxx';
$secret_key = 'xxxxxxxx';

#GET
$method = 'GET';
$path = '/api/v1/zones/xxxxxxxx';
$expire = null;
$query_string = null;

$array = array($method, $path, $api_key, $expire, $query_string);
$signature = base64_encode(hash_hmac('sha256', implode("\n", $array), $secret_key, true));
echo $signature;

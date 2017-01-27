<?php

$api_key = 'BHXrDGGFBdoEvzwzeAwSXkm4vF7pNlalXLIH6XNTMZduTFns0Pb1lPuESx5tYxfhsQ4w6DXoRRhvgUnEm13iCg';
$secret_key = 'bdjPL_97fS084h0aW7_rUI_LcC85kd-CILueSsom1UfQcxeLnQpiGrwdXSP9OtT_rkBjCT2uwPVpiBsEOaZePw';

$method = 'POST';
$path = '/api/v1/zones/09b3752d-92b4-4737-9a20-f649cc41900c/records';
$expire = null;
$query_string = null;

$array = array($method, $path, $api_key, $expire, $query_string);
$signature = base64_encode(hash_hmac('sha256', implode("\n", $array), $secret_key, true));
echo $signature;

<?php
//Create by JamesJara, editor VIM, 05-6-09
//Solo modifique la linea -->  rutadb  <---
//este archivo debe ir en la carpeta root del servidor

//server direccion
$addr =  $_SERVER['REMOTE_ADDR'];
//nombre del servidor
$server_one = "";
//direccion de los scripts desde el root
$server_two = "IpAccess"."/";
//ruta completa
$full_dir   = $server_one.$server_two;
//ruta de la database
$rutadb = "D:\xxx\xxxx  xxxx\Ip Access";
//string de conexion
$conexion .= "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=".$rutadb."\data.mdb;Persist Security Info=False";

//libreria para sacar el pais
require($full_dir."inc/geoip.inc"); 
$abir_bd = geoip_open($full_dir."inc/GeoIP.dat",GEOIP_STANDARD);

//sacamos las variables
$fecha		= substr(date("Y/m/d")		, 0, 	100);
$hora 		= substr(date("h:i:s")		, 0, 	100);
$referido   = substr($HTTP_REFERER	, 0, 	100);
$ip1		= substr($REMOTE_ADDR				, 0, 	100);
$pagina		= substr($_SERVER['REQUEST_URI']	, 0, 	100);
$pais		= substr(geoip_country_name_by_addr($abir_bd,$addr), 0, 	100);
$explorer	= substr($HTTP_USER_AGENT , 0, 100);


//Conexion a la db
$dbc = new COM("ADODB.Connection");
$dbc->open($conexion);

//insertamos los nuevos datos
$dbc->execute("INSERT INTO accesos(ip, fecha , hora, pais, refer, pagina, explorer  ) VALUES (
                       '".$ip1			."' ,
                       '".$fecha		."' ,
                       '".$hora			."' ,
                       '".$pais			."',
                       '".$referido		."' ,
                       '".$pagina		."',
                       '".$explorer		."' ) ");


//cerrar conexion
$dbc->close();  


?>

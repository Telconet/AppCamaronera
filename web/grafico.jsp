<%-- 
    Document   : grafico2
    Created on : May 26, 2016, 1:22:18 PM
    Author     : Eduardo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--
To change this template, choose Tools | Templates
and open the template in the editor.
-->
<!DOCTYPE html>
<html>
    <head>
        <title></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
         <link rel="stylesheet" type="text/css" href="estilo.css">
         <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
         <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js">
             
         </script>
    </head>
    <body>
        <div><h1>Gráfico Piscina</h1></div>       
        <script type="text/javascript">
            
          var medicion;
          var id_wasp;
          var user;
          <%                       
                    String id_wasp = (String)request.getAttribute("id_wasp");
                    String med = (String)request.getAttribute("medicion");
                    String user = (String)request.getAttribute("bd_cliente");
          %>
            
          <%= "medicion = \"" + med + "\";" %>
          <%= "id_wasp = \"" + id_wasp + "\";" %>
          <%= "user = \"" + user + "\";" %>
          
                      
          /*Función que invocara la el json con los datos y generará el gráfico de la medicion*/
          function generarGrafico(){
              
              //TODO://       
               $.get("/AppCamaronera/DatosGraficoCamaronera", { id_wasp: this.id_wasp, medicion: this.medicion, bd_cliente: this.user } , function(data, status){
                   
                   var chart = new google.visualization.LineChart(document.getElementById('grafico'));
                   
                   var tablaDatos = google.visualization.arrayToDataTable(data.data);
                   
                   //Añadimos opciones de estilo de gráfico
                   data.options.chartArea = {};
                   data.options.chartArea.height = '75%';
                   data.options.chartArea.height = '80%';
                   
                   data.options.lineWidth = 3.8;
                   
                  

                   if(medicion == 'DO'){
                       data.options.colors = ['#0000FF'];
                   }
                   else if(medicion == 'TCA'){
                        data.options.colors = ['#008000'];
                   }
                   else if(medicion == 'PH'){
                       data.options.colors = ['#FF0000'];
                   }
                   else if( medicion == 'BAT'){
                       data.options.colors = ['#000000'];
                   }                   
                   
                    chart.draw(tablaDatos, data.options);
               }, "json");
          }
          
             //cargamos la versión más actual del API  
            google.charts.load('current', {packages: ['corechart', 'line']});
            google.charts.setOnLoadCallback(generarGrafico);
            //generarGrafico();
            
            /*Configuramos el intermalo de refresco de la página*/
            function startInterval() {

                  setInterval("location.reload(true);" ,intervaloRefreshaPagina);           //Funcion para recargar y redibujar el gráfico
            }


            /*var intervaloRefreshaPagina = 60000;    //60 segundos.
            var primeraVez = 0;

            if(primeraVez == 0){
                window.onload = startInterval;
                primeraVez++;
            }
            else{
                window.onload = startInterval;
            }*/
            
        </script>
        <div id="grafico" class="grafico_linea"></div>        
    </body>
</html>

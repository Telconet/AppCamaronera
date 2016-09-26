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
        <div id="div_titulo"><h1 id="titulo">Gráfico Piscina</h1></div>  
        <div id="barra_herramientas"><button id="Reportes" class="botones_herramientas" onclick="recargarEstado(this)" onmouseover="cambiarBoton(this)" onmouseout="restaurarBoton(this)">Estado</button><button id="Reportes" class="botones_herramientas" onmouseover="cambiarBoton(this)" onmouseout="restaurarBoton(this)">Reportes</button><button id="Graficos" class="botones_herramientas" onclick="obtenerGraficoHistorico(this)" onmouseover="cambiarBoton(this)" onmouseout="restaurarBoton(this)">Gráficos</button></div>
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
              
          ///Botones
          function cambiarBoton(boton){
                
                boton.style.color = "#EB5E28";
                //boton.style.borderColor = "#EB5E28";
                //boton.style.borderBottom = "solid #EB5E28";
                //boton.style.borderWidth = "3px";
                boton.style.cursor = "pointer"
            }
            
            function restaurarBoton(boton){
                
                boton.style.color = "white";
               // boton.style.borderBottom = "none";
                boton.style.cursor = "default";
            }
            
            
            /* Carga la página de grafico Historico*/
          function obtenerGraficoHistorico(){
              
              //AJAX>>
              var url = "/AppCamaronera/GraficoHistorico?";
              /*url = url.concat(id_wasp);
              url = url.concat("&medicion=");
              url = url.concat(medicion);*/
              url = url.concat("bd_cliente=");
              url = url.concat(user);
              
              window.location.replace(url);
             
          }
            
          function recargarEstado(){
              window.location.href = "/AppCamaronera/";
          }
            
          
                      
          /*Función que invocara la el json con los datos y generará el gráfico de la medicion*/
          function generarGrafico(){
              
              //TODO://       
               $.get("/AppCamaronera/DatosGraficoCamaronera", { id_wasp: this.id_wasp, medicion: this.medicion, bd_cliente: this.user } , function(data, status){
                   
                   //Verificamos si tenemos datos
                   if(data.data.length == 0){
                       //No hay datos, mostrar texto de error
                       //Añadidmos un elemento al div
                       var div_grafico = document.getElementById('grafico');
                       
                       div_grafico.innerHTML = "No existen datos de las útimas 24 horas.";
                       
                       div_grafico.style.fontFamily = "Segoe UI";
                       div_grafico.style.fontSize = "40px";
                       div_grafico.style.fontWeigth = "bolder";
                       div_grafico.style.textAlign = "center";
                       div_grafico.style.verticalAlign = "middle";
                       div_grafico.style.lineHeight = "680px";          //!
                       //div_grafico.style.paddingTop = "300px";
                       //div_grafico.style.heigth = "468px";
                       //div_grafico.style.lineHeight = "700px";
                       
                       return;
                   }
                   
                   var chart = new google.visualization.LineChart(document.getElementById('grafico'));
                   
                   var tablaDatos = google.visualization.arrayToDataTable(data.data);
                   
                   //Añadimos opciones de estilo de gráfico
                   data.options.chartArea = {};
                   data.options.chartArea.height = '75%';
                   data.options.chartArea.height = '80%';
                   
                   data.options.lineWidth = 3.8;
                   
                   //leyenda
                   data.options.legend.position =  'none';
                   
                   //Titulo
                   data.options.titleFontSize = 27;
                   data.options.titleTextStyle = {};
                   data.options.titleTextStyle.fontName = "Segoe UI";
                   
                   //Ejes horizontales
                   data.options.hAxis = {};
                   data.options.hAxis.textStyle = {};
                   data.options.hAxis.textStyle.fontName = "Segoe UI";
                   data.options.hAxis.textStyle.italic = false;
                   data.options.hAxis.textStyle.bold = false;
                   data.options.hAxis.textStyle.fontSize = 15;
                   
                   data.options.hAxis.slantedText = false;
                   
                   data.options.hAxis = {};
                   data.options.hAxis.titleTextStyle = {};
                   data.options.hAxis.title = "Hora";
                   data.options.hAxis.titleTextStyle.fontName = "Segoe UI";
                   data.options.hAxis.titleTextStyle.italic = false;
                   data.options.hAxis.titleTextStyle.bold = true;
                   data.options.hAxis.titleTextStyle.fontSize = 20;
                   
                   data.options.hAxis.showTextEvery = 20;
                   
                   //Ejes verticales
                   data.options.vAxis = {};
                   data.options.vAxis.textStyle = {};
                   data.options.vAxis.textStyle.fontName = "Segoe UI";
                   data.options.vAxis.textStyle.italic = false;
                   data.options.vAxis.textStyle.bold = false;
                   
                   data.options.vAxis.titleTextStyle = {};
                   data.options.vAxis.titleTextStyle.fontName = "Segoe UI";
                   data.options.vAxis.titleTextStyle.italic = false;
                   data.options.vAxis.titleTextStyle.bold = true;
                   data.options.vAxis.titleTextStyle.fontSize = 20;
                   
                   //data.options.vAxis.format = "percent";
                   data.options.vAxis.ticks = [0,10,20,30,40,50,60,70,80,90,100,110];
                   
                   /*data.options.vAxis.gridlines.color = '#333';
                   data.options.vAxis.gridlines.count = 4;*/
                   
                   if(medicion == 'DO'){
                       data.options.colors = ['#0000FF'];
                       data.options.vAxis.title = "Oxígeno Disuelto (%)";
                       data.options.vAxis.ticks = [0,10,20,30,40,50,60,70,80,90,100];
                   }
                   else if(medicion == 'TCA'){
                        data.options.colors = ['#008000'];
                        data.options.vAxis.title = "Temperatura (C)";
                        data.options.vAxis.ticks = [0,5,10,15,20,25,30,35,40,45,50];
                   }
                   else if(medicion == 'PH'){
                       data.options.colors = ['#FF0000'];
                       data.options.vAxis.title = "pH";
                       data.options.vAxis.ticks = [0,1,2,3,4,5,6,7,8,9,10,11,12,13];
                   }
                   else if( medicion == 'BAT'){
                       data.options.colors = ['#000000'];
                       data.options.vAxis.title = "Bateria (%)";
                   }                   
                   //Falta salinidad
                   
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

<%-- 
    Document   : index
    Created on : May 16, 2016, 12:12:02 PM
    Author     : Eduardo Murillo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" type="text/css" href="estilo.css">        
    </head>
    <body>
        <div id="div_titulo"><h1 id="titulo">Estado Piscinas</h1></div>
        <div id="barra_herramientas"><button id="Reportes" class="botones_herramientas" onmouseover="cambiarBoton(this)" onmouseout="restaurarBoton(this)">Estado</button><button id="Reportes" class="botones_herramientas" onmouseover="cambiarBoton(this)" onmouseout="restaurarBoton(this)">Reportes</button><button id="Reportes" class="botones_herramientas" onmouseover="cambiarBoton(this)" onmouseout="restaurarBoton(this)">Gráficos</button></div>
        <script type="text/javascript" src="date-es-EC.js" ></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
        <script>
            /**
             *Funciones para cambio de color
             */
            
            //Sobre la pagina
            var botonAnteriorSeleccionado = null;       //que boton está seleccionado
            
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
            
        
        </script>
        <script>
            
          var respuesta;
          var mio;
          var user = "waspmote_data";
          
          //Obtenemos lo que nos mando el servidor
          
          
     
          
          //AppCamaronera/ para servidor local (sin s).
          function obtenerYPresentarDatos(){
            $.get("/AppCamaronera/AppCamaronera", { bd_cliente: user, ed: "tmp" } , function(data, status){


                for(i = 0; i < data.length; i++){
                    
                    var numeroMediciones = data[i].numero_mediciones;
                    var lista = document.getElementById("lista_piscinas");
                    var elementoListaPiscinas = document.createElement("DIV");
                    elementoListaPiscinas.setAttribute("class", "elemento_lista");

                    lista.appendChild(elementoListaPiscinas);

                    var w = window.innerWidth; 
                    var anchoElementoLista = Math.floor((w/(numeroMediciones + 1))) - 12 ;           //-6 de los bordes

                    //Hasta aqui ya tenemos los elementos
                    //Añadimos los nombres de las motas.
                    var nombrePiscina = document.createElement("TABLE");
                    nombrePiscina.width = anchoElementoLista;
                    nombrePiscina.setAttribute("class", "tabla_nombre_piscina");
                    elementoListaPiscinas.appendChild(nombrePiscina);

                    var filaNombre = document.createElement("TR");
                    filaNombre.setAttribute("class", "fila");
                    filaNombre.setAttribute("id", "nombre_piscina");
                    var filaFecha = document.createElement("TR");
                    filaFecha.setAttribute("class", "fila");
                     filaFecha.setAttribute("id", "fecha_med");
                    nombrePiscina.appendChild(filaNombre);
                    nombrePiscina.appendChild(filaFecha);

                    //Creamos parrafos dentro del SPAN
                    var col1 = document.createElement("TD");
                    col1.setAttribute("id", "nombre" );
                    col1.innerHTML = data[i].id_wasp;

                    var col2 = document.createElement("TD");
                    col2.setAttribute("id", "time" );


                    /*var fechaStr = data[i].timestamp;
                    fechaStr = fechaStr.slice(0,-2);
                    var fecha = Date.parse(fechaStr);*/

                    col2.innerHTML = data[i].timestamp; //fecha.toString('d MMM, HH:mm');                  
                    filaNombre.appendChild(col1);
                    filaFecha.appendChild(col2);

                    //Añadimos los CANVAS para los colores
                    

                    for(j = 0; j < numeroMediciones; j++){

                          var canvasMedicion = document.createElement("CANVAS");
                          canvasMedicion.setAttribute("class", "canvas_medicion");
                          
                          canvasMedicion.width = anchoElementoLista;
                          canvasMedicion.height = 100;

                          elementoListaPiscinas.appendChild(canvasMedicion);
                          var ctx;

                          ctx = canvasMedicion.getContext("2d");
                          ctx.beginPath();
                          ctx.rect(0, 0, canvasMedicion.width, canvasMedicion.height);



                          var id_med = data[i].id_wasp;
                          id_med = id_med.concat("-");
                          
                          /*gernemos el comando onclick con los parámetros necesarios*/
                          var comando = "obtenerGrafico(\""
                          comando = comando.concat(data[i].id_wasp);
                          comando = comando.concat("\",\"");
                          comando = comando.concat()
                          
                          if(j == 0){  //DO
                              id_med = id_med.concat("DO");
                              canvasMedicion.setAttribute("id", id_med);
                              comando = comando.concat("DO\")");
                              ctx.fillStyle = "blue";
                              ctx.fill();
                              ctx.fillStyle = "white";
                              ctx.font = "30px Arial";
                              ctx.fillText("Oxígeno (%)",10,40);
                              ctx.font = "38px Arial";
                              var tamanaTexto = ctx.measureText(data[i].DO).width;
                              var ubicacionXTexto = (canvasMedicion.width/2) + (canvasMedicion.width/2 - tamanaTexto)/2;
                              ctx.fillText(data[i].DO, ubicacionXTexto, 80);
                          }
                          else if(j == 1){ //TCA
                              id_med = id_med.concat("TCA");
                              canvasMedicion.setAttribute("id", id_med);
                              comando = comando.concat("TCA\")");
                              ctx.fillStyle = "green";
                              ctx.fill();
                              ctx.fillStyle = "white";
                              ctx.font = "30px Arial";
                              ctx.fillText("T (°C)",10,40);
                              ctx.font = "38px Arial";
                              var tamanaTexto = ctx.measureText(data[i].TCA).width;
                              var ubicacionXTexto = (canvasMedicion.width/2) + (canvasMedicion.width/2 - tamanaTexto)/2;
                              ctx.fillText(data[i].TCA, ubicacionXTexto, 80);
                          }
                          else if(j == 2){ //PH
                              id_med = id_med.concat("PH");
                              canvasMedicion.setAttribute("id", id_med);
                              comando = comando.concat("PH\")");
                              ctx.fillStyle = "red";
                              ctx.fill();
                              ctx.fillStyle = "white";
                              ctx.font = "30px Arial";
                              ctx.fillText("pH",10,40);
                              ctx.font = "38px Arial";
                              var tamanaTexto = ctx.measureText(data[i].PH).width;
                              var ubicacionXTexto = (canvasMedicion.width/2) + (canvasMedicion.width/2 - tamanaTexto)/2;
                              ctx.fillText(data[i].PH, ubicacionXTexto, 80);
                          }
                          else if(j == 4){ //BAT
                              id_med = id_med.concat("BAT");
                              canvasMedicion.setAttribute("id", id_med);
                              comando = comando.concat("BAT\")");
                              ctx.fillStyle = "black";
                              ctx.fill();
                              ctx.fillStyle = "white";
                              ctx.font = "30px Arial";
                              ctx.fillText("Batería (%)",10,40);
                              ctx.font = "38px Arial";
                              var tamanaTexto = ctx.measureText(data[i].BAT).width;
                              var ubicacionXTexto = (canvasMedicion.width/2) + (canvasMedicion.width/2 - tamanaTexto)/2;
                              ctx.fillText(data[i].BAT, ubicacionXTexto, 80);
                          }
                          else if(j == 3){
                              id_med = id_med.concat("COND");
                              canvasMedicion.setAttribute("id", id_med);
                              comando = comando.concat("COND\")");
                              ctx.fillStyle = "orange";
                              ctx.fill();
                              ctx.fillStyle = "white";
                              ctx.font = "30px Arial";
                              ctx.fillText("Salinidad (mS/cm)",10,40);
                              ctx.font = "38px Arial";
                              var tamanaTexto = ctx.measureText(data[i].COND).width;
                              var ubicacionXTexto = (canvasMedicion.width/2) + (canvasMedicion.width/2 - tamanaTexto)/2;
                              ctx.fillText(data[i].COND, ubicacionXTexto, 80);
                          }
                          
                          //Agregamos el envento onClick al CANVAS para que el usuerio pueda hacer click
                          //y se generen los gráficos.
                          canvasMedicion.setAttribute("onclick", comando)
                          //canvasMedicion.setAttribute("href", "/Telcometria/GraficoCamaronera");

                    }
                    //title.innerHTML = data[i].id_wasp;
                }

            }, "json");
          }
          
          /*Función que invocara la generación del gráfico de la medicion*/
          function obtenerGrafico(id_wasp, medicion){
              
              var url = "/AppCamaroneras/GraficoCamaronera?id_wasp=";
              url = url.concat(id_wasp);
              url = url.concat("&medicion=");
              url = url.concat(medicion);
              url = url.concat("&bd_cliente=");
              url = url.concat(user);
              
              window.location.replace(url);
             
          }
          
          /*Funcion para redibujar la tabla*/
          function actualizarDatos(){
              var nodo = document.getElementById("lista_piscinas");
              
              while(nodo.hasChildNodes()){    
                  nodo.removeChild(nodo.lastChild);
              }
              
              obtenerYPresentarDatos();
          }
          
          /*Configuramos el intermalo de refresco de la página*/
          function startInterval() {
              
                setInterval("actualizarDatos();" ,intervaloRefreshaPagina);
          }

          
          var intervaloRefreshaPagina = 60000;    //60 segundos.
          var primeraVez = 0;
          
          if(primeraVez == 0){
              obtenerYPresentarDatos();
              window.onload = startInterval;
              primeraVez++;
          }
          else{
              window.onload = startInterval;
          }
            

          //Aqui llamamos y recargamos
          //obtenerYPresentarDatos();
          
          
          
           
          
          
          
          
            
            
        </script>
        
        <!--Aqui viene la lista de las piscinas-->
        <div id="lista_piscinas">
            
            <!--span><p>psicina</p><p>fecha</p></span-->
            
        </div>
        
    </body>
</html>

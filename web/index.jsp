<%-- 
    Document   : index
    Created on : May 16, 2016, 12:12:02 PM
    Author     : Eduardo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            .canvas_medicion{
                padding: 0px;
                border-style: solid;        /*por ahora*/
                
            }
            
            body{
                height: 100%;
                width: 100%;
                background-color: white;
                margin: 0px;
                padding: 0px;
            }
            
            h1{
                font-family: 'Century Gothic';
                font-size: 50px;
                font-style: normal;
                font-variant: normal;
                font-weight: 500;
                text-align: center;
                padding: 30px;
                margin: 0px;
                background-color: #4C86A9;
                color: white;
            }
            
            
            #nombre {
                 display: inline;
                 width: 20%;
                 margin: 0%; 
            }
            
            #time {
                width: 20%;
                margin: 0%;
            }
            
            .tabla_nombre_piscina{
                display: inline-block;
                width: 18%; 
                height: 80px;
            }
            
            #nombre_piscina{
                /*Fuentes*/
                font-family: 'Century Gothic';
                font-size: 23px;
                font-style: normal;
                font-variant: normal;
                font-weight: bold;
                line-height: 23px;
                /*text-align: center;*/
                padding-left: 200px;
            }
            
            #fecha_med{
                /*Fuentes*/
                font-family: 'Century Gothic';
                font-size: 23px;
                font-style: normal;
                font-variant: normal;
                /*font-weight: 500;*/
                line-height: 15px;
                /*text-align: center;*/
            }
            
            .class fila{
                width: 10%;
            }
            
            table{
                height: 80px;
            }
            
            td{
                padding: 15px;
            }
            
            #lista_piscinas{
                border-color: black;
                border-width: 2px;
            }
            
            #div_titulo{
                margin: 10px;
                
            }
            
        </style>
        
    </head>
    <body>
        <div id="div_titulo"><h1 id="titulo">Estado Piscinas</h1></div>
        <script type="text/javascript" src="date-es-EC.js" ></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
        <script>
            
          var respuesta;
          var mio;
          
          //Obtenemos lo que nos mando el servidor
          
          function obtenerYPresentarDatos(){
            $.get("/Telcometria/AppCamaronera", { bd_cliente: "waspmote_data", ed: "tmp" } , function(data, status){


                for(i = 0; i < data.length; i++){
                    var lista = document.getElementById("lista_piscinas");
                    var elementoListaPiscinas = document.createElement("DIV");
                    elementoListaPiscinas.setAttribute("class", "elemento_lista");

                    lista.appendChild(elementoListaPiscinas);

                    var w = window.innerWidth; 
                    var anchoElementoLista = w/5;

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


                    var fechaStr = data[i].timestamp;
                    fechaStr = fechaStr.slice(0,-2);
                    var fecha = Date.parse(fechaStr);

                    col2.innerHTML = fecha.toString('d MMM yyyy, HH:mm:ss');                  
                    filaNombre.appendChild(col1);
                    filaFecha.appendChild(col2);

                    //Añadimos los CANVAS para los colores
                    var numeroMediciones = data[i].numero_mediciones;



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




                          if(j == 0){  //DO
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
                          else if(j == 1){ //pH
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
                          else if(j == 2){ //TCA
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
                          else if(j == 3){ //BAT
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
                          else if(j == 5){
                              //salinidad
                          }

                    }
                    //title.innerHTML = data[i].id_wasp;
                }

            }, "json");
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

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
            
        </style>
        
    </head>
    <body>
        <div><h1 id="titulo">Estado Piscinas</h1></div>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
        <script>
            
          var respuesta;
          var mio;
          
          //Obtenemos lo que nos mando el servidor
          
          $.get("/Telcometria/AppCamaronera", { bd_cliente: "waspmote_data", ed: "tmp" } , function(data, status){
              //data contiene la informacion
              /*var nombreFormulario = "formulario_usuario";
             
              //Creamos una form (para pedir la página de estadisticas
              var formulario = document.createElement("FORM");
              formulario.setAttribute("method", "get");
              formulario.setAttribute("action", "/Domotica/Estadisticas");
              formulario.setAttribute("id", nombreFormulario);
              
              var divFormulario = document.getElementById("div_formulario");
              divFormulario.appendChild(formulario);
              
              for(i = 0; i < data.length; i++){
                  var boton = document.createElement("BUTTON");
                  var texto = document.createTextNode(data[i]);
                  
                    boton.appendChild(texto);
                    boton.setAttribute("class", "botones_clientes");
                    boton.setAttribute("value", data[i]);
                    boton.setAttribute("form", nombreFormulario);
                    formulario.appendChild(boton);
              }*/
              
              
              for(i = 0; i < data.length; i++){
                  var lista = document.getElementById("lista_piscinas");
                  var elementoListaPiscinas = document.createElement("DIV");
                  elementoListaPiscinas.setAttribute("class", "elemento_lista");
                  
                  lista.appendChild(elementoListaPiscinas);
                  
                  var w = window.innerWidth; 
                  var anchoElementoLista = w/5;
                  
                  //Hasta aqui ya tenemos los elementos
                  //Añadimos los nombres de las motas.
                  var nombrePiscina = document.createElement("SPAN");
                  nombrePiscina.width = anchoElementoLista;
                  nombrePiscina.setAttribute("class", "nombre_piscina");
                  nombrePiscina.innerHTML = data[i].id_wasp;
                  elementoListaPiscinas.appendChild(nombrePiscina);
                  
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
          
           
          
          
          
          
            
            
        </script>
        
        <!--Aqui viene la lista de las piscinas-->
        <div id="lista_piscinas"></div>
        
    </body>
</html>

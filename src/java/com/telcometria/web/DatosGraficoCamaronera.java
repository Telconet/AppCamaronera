/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.telcometria.web;

import com.telcometria.modelo.BaseDeDatos;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.net.ntp.TimeStamp;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author Eduardo Murillo
 */
public class DatosGraficoCamaronera extends HttpServlet{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int i = 0;
            
            String bd_cliente = null;
            String id_wasp = null;
            String medicion = null;
                    
            
            bd_cliente = request.getParameter("bd_cliente");
            id_wasp =  request.getParameter("id_wasp");
            medicion = request.getParameter("medicion");
                    
                     
             ServletContext config = request.getSession().getServletContext();
            
            BaseDeDatos bd = new BaseDeDatos(BaseDeDatos.MYSQL_DB, "log_bd", config.getInitParameter("IP"),
                                                                             config.getInitParameter("usuario"),
                                                                             config.getInitParameter("clave"),
                                                                             Integer.parseInt(config.getInitParameter("puerto")),
                                                                             "0",
                                                                             bd_cliente);
            
            bd.conectar();
            
            Calendar cal = Calendar.getInstance();
            SimpleDateFormat año = new SimpleDateFormat("yyyy");
            
            SimpleDateFormat ahora = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            SimpleDateFormat hace24Horas = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            
            String ahoraStr = ahora.format(cal.getTime());
            cal.add(Calendar.HOUR_OF_DAY, -24);
            String hace24HorasStr = hace24Horas.format(cal.getTime());
            
            String nombreTabla = config.getInitParameter("tablaDatos") + "_" + año.format(cal.getTime());
            
            String consulta = "SELECT * FROM " + nombreTabla + " where timestamp between \'" + hace24HorasStr  + "\' and \'" +  ahoraStr + "\' and sensor = \'" + medicion +   "\' order by timestamp ASC";
            
            System.out.println(consulta);
             
            ResultSet datos  = bd.ejecutarConsulta(consulta);
            
            JSONArray arregloDatos = new JSONArray();
            JSONObject objetoOpciones = new JSONObject();
            JSONObject objetoConjunto = new JSONObject();       //Aqui van objetoDatos y objetoOpciones (lo que ya enviamos al app)
            
            String titulo = "";
            String tituloEjeVertical = "";
            
            //Configuramos las opciones
            if(medicion.equals("DO")){
                titulo = "Oxigeno Disuelto - "  + id_wasp;
                tituloEjeVertical = "Oxigeno Disuelto (%)";
            }
            else if(medicion.equals("PH")){
                titulo = "Acidez (pH) - " + id_wasp;
                tituloEjeVertical = "pH";
            }
            else if(medicion.equals("TCA")){
                titulo = "Temperatura - " + id_wasp;
                tituloEjeVertical = "Temperatura (grados C)";
            }
            else if(medicion.equals("BAT")){
                titulo = "Bateria - " + id_wasp;
                tituloEjeVertical = "Nivel de Bateria (%)";
            }
            
            objetoOpciones.put("title", titulo);
            objetoOpciones.put("curveType", "function");        //Grafico de Linea
            
            JSONObject leyenda = new JSONObject();
            
            leyenda.put("position", "bottom");
            objetoOpciones.put("legend", leyenda);
            
            
            
            //Metemos los datos
            boolean primeraIteracion = true;
            while(datos.next()){
                
                JSONArray medicionFecha = new JSONArray();
                
                //Crear el JSON
                if(primeraIteracion){
                    JSONArray nombreEjes = new JSONArray();
                    nombreEjes.put("hora");
                    nombreEjes.put(tituloEjeVertical);
                    
                    //En la primera pasada armamos el nombre de los ejes
                    arregloDatos.put(nombreEjes);
                    primeraIteracion = false;
                }
                
                //Empezamos a sacar los datos
                String valor = datos.getString("value");
                
                //La hora del datos
                String timestamp = datos.getString("timestamp");
                timestamp = timestamp.split(" ")[1];
                
                timestamp = timestamp.substring(0, timestamp.length()-5);
                
                medicionFecha.put(timestamp);
                medicionFecha.put(Float.parseFloat(valor));
                
                arregloDatos.put(medicionFecha);
                
            }
            
            //Creamos el JSON para Google Charts
            objetoConjunto.put("options", objetoOpciones);
            objetoConjunto.put("data", arregloDatos);
            
            
            //Serializamos el JSON 
            String salida = objetoConjunto.toString();
            response.setContentLength(salida.length());
            
            //Escribimos el string a la salida
            response.getOutputStream().write(salida.getBytes());
            response.getOutputStream().flush();
            response.getOutputStream().close();
            
            datos.close();
            bd.cerrar();
            
        } catch (SQLException ex) {
            Logger.getLogger(DatosGraficoCamaronera.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doGet(req, resp);
    }
    
    
}

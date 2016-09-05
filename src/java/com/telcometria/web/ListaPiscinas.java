/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.telcometria.web;

import com.telcometria.modelo.BaseDeDatos;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author Eduardo Murillo
 */
public class ListaPiscinas extends HttpServlet {
    
    
    @Override
    public void doGet(HttpServletRequest request,
                       HttpServletResponse response) throws IOException, ServletException
    {
        //Este servlet leera los datos de telemetria de las camaroneras.
        
        String bd_cliente = request.getParameter("bd_cliente");
        
        ServletContext config = request.getSession().getServletContext();
        
        
        String tabla_datos_actuales = config.getInitParameter("tablaDatosActual");
        
        BaseDeDatos bd = new BaseDeDatos(BaseDeDatos.MYSQL_DB, "log_bd", config.getInitParameter("IP"),
                                                                         config.getInitParameter("usuario"),
                                                                         config.getInitParameter("clave"),
                                                                         Integer.parseInt(config.getInitParameter("puerto")),
                                                                         "0",
                                                                         bd_cliente);
        //http://localhost:8084/AppCamaronera/AppCamaronera para server local
        bd.conectar();
        
        
        //TODO: leer datos de la BD
        String consultaDatos = "SELECT * FROM " + tabla_datos_actuales + " ORDER BY id_wasp ASC, sensor ASC";
        String numerofilas = "SELECT COUNT(*) FROM " + tabla_datos_actuales; 
        
        System.out.println(config.getInitParameter("IP"));
        System.out.println(config.getInitParameter("usuario"));
        System.out.println(config.getInitParameter("clave"));
        System.out.println( Integer.parseInt(config.getInitParameter("puerto")));
        System.out.println(bd_cliente);         //null???
        
       
        
        
        ResultSet resultado = bd.ejecutarConsulta(consultaDatos);
        
        
        
        
        
        JSONArray arregloJSON = new JSONArray();
        
        try {
            int res  = 0;
            int numeroMediciones = 5; //BAT, timestamp, 
            //Las mediciones estan ordenadas por id_wasp, y luego sensor
            int i = 0;
            JSONObject mota = null;
            
            
            while(resultado.next()){
                
                //TODO: aramamos el JSON
                //Sacamos mediciones por ID_WASP
                
                if(i % numeroMediciones == 0){          //cada 4 mediciones
                     mota = new JSONObject();
                     mota.put("id_wasp", resultado.getString("id_wasp"));
                     
                     mota.put("numero_mediciones", numeroMediciones);
                     arregloJSON.put(mota);
                     
                     
                     
                     String ts_str = resultado.getString("timestamp");
                     ts_str = ts_str.substring(0, ts_str.length()-2);
                     
                     SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                     Date fechaHora = null;
                    try {
                        fechaHora = sdf3.parse(ts_str);
                    } catch (ParseException ex) {
                        Logger.getLogger(ListaPiscinas.class.getName()).log(Level.SEVERE, null, ex);
                    }
                              
                     SimpleDateFormat sdf4 = new SimpleDateFormat("d MMM, HH:mm");
                     mota.put("timestamp", sdf4.format(fechaHora));
                }
                
                String sensor = resultado.getString("sensor");
                String valor = resultado.getString("value");

                if(sensor.contains("PH")){
                    mota.put("PH", valor);               
                }
                else if(sensor.contains("DO")){
                    mota.put("DO", valor);
                }
                else if(sensor.contains("TCA")){
                    mota.put("TCA", valor);  
                }
                else if(sensor.equals("BAT")){
                    mota.put("BAT", valor);  
                }
                else if(sensor.equals("COND")){
                    mota.put("COND", valor);  
                }
                i++;
                
                
                res++;
                           
            }
            resultado.close();
            bd.cerrar();
            
            //Serializamos el arreglo de datos
            String salida = arregloJSON.toString();
            response.setContentLength(salida.length());
            
            //And write the string to output.
            response.getOutputStream().write(salida.getBytes());
            response.getOutputStream().flush();
            response.getOutputStream().close();
            
        } 
        catch (SQLException ex) {
            Logger.getLogger(ListaPiscinas.class.getName()).log(Level.SEVERE, null, ex);           
        }
        finally{
           
           bd.cerrar(); 
        }
        
        //TODO: organizar objeto JSON
            
            //TODO: enviar objeto JSON.
    }
    
    
}

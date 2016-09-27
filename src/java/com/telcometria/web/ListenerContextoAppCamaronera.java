/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.telcometria.web;

import com.telcometria.modelo.TablaCorreccionSalinidad;
import com.telcometria.modelo.TablaOxigenoSaturacion;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 *
 * @author Eduardo
 */
public class ListenerContextoAppCamaronera implements ServletContextListener{
    
    TablaOxigenoSaturacion tablaOxigeno = null;
    TablaCorreccionSalinidad tablaSalinidad = null;    
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
              
        
        
        if(tablaOxigeno == null || tablaSalinidad == null){
            ServletContext context = sce.getServletContext();
            InputStream resourceContentOxigeno = context.getResourceAsStream("/WEB-INF/static/dotablesJSON");
            InputStream resourceContentSalinidad = context.getResourceAsStream("/WEB-INF/static/salinitytablesJSON");


            try {
                BufferedReader lector = new BufferedReader(new InputStreamReader(resourceContentOxigeno));
                BufferedReader lectorSalinidad = new BufferedReader(new InputStreamReader(resourceContentSalinidad));

                String text = null;

                    try {
                        while ((text = lector.readLine()) != null) {
                          //Pprocesamos la linea para hacer JSON
                          tablaOxigeno = new TablaOxigenoSaturacion(text);

                        }



                        double ox = tablaOxigeno.obtenerOxigenoSaturacion(35.5, 760);

                        System.out.println(ox);

                        text = null;
                        //Ahora la tabla de salinidad
                        while((text = lectorSalinidad.readLine()) != null){
                            tablaSalinidad = new TablaCorreccionSalinidad(text);
                        }

                        tablaSalinidad.obtenerCorrecionSalinidad(32.4, 35678.343);
                        context.setAttribute("tablaOxigeno", tablaOxigeno);
                        context.setAttribute("tablaSalinidad", tablaSalinidad);


                        //pasamos las tablas al servlet...


                    } catch (IOException ex) {
                        Logger.getLogger(ListenerContextoAppCamaronera.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    
                    lector.close();
                    lectorSalinidad.close();

                } catch (Exception ex) {
                    String e = ex.toString();
                    Logger.getLogger(ListenerContextoAppCamaronera.class.getName()).log(Level.SEVERE, null, ex);
                }
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
       
    }
    
}

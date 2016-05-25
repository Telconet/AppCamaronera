/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.telcometria.web;

import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Eduardo Murillo
 */
public class GraficoCamaronera extends HttpServlet{
    
    @Override
    public void doGet(HttpServletRequest request,
                       HttpServletResponse response) throws IOException, ServletException{
        
        //Mandamos la página...
        RequestDispatcher vista = request.getRequestDispatcher("grafico.html");
        vista.forward(request, response);

    }
    
}

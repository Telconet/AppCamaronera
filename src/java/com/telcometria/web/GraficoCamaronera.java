/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.telcometria.web;

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
        
        
        //String url = request.get
        
        String id_wasp = request.getParameter("id_wasp");
        String medicion = request.getParameter("medicion");
        String bd_cliente = request.getParameter("bd_cliente");
        
        request.setAttribute("id_wasp", id_wasp);
        request.setAttribute("medicion", medicion);
        request.setAttribute("bd_cliente", bd_cliente);
        
        //Mandamos la página...
        RequestDispatcher vista = request.getRequestDispatcher("grafico.jsp");
        vista.forward(request, response);

    }
    
}

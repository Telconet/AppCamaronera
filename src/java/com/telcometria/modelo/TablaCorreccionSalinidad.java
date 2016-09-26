/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.telcometria.modelo;

import java.util.Locale;
import org.json.JSONObject;

/**
 *
 * @author Eduardo
 */
public class TablaCorreccionSalinidad {
    
    JSONObject tabla;
    
    public TablaCorreccionSalinidad(String json){
        tabla = new JSONObject(json);
    }
    
    
    public double obtenerCorrecionSalinidad(double temperatura, double salinidad){
        
        //Salinidad viene en uS/cm...??
        
        String temperaturaStr = String.format(Locale.US, "%.1f",temperatura);
        
        //La salinidad hay que redondearla...
        String salinidadStr = String.format("%.0f", salinidad);
        
        salinidadStr = salinidadStr.substring(0, salinidadStr.length()-2) + "00";
        
        JSONObject fila = tabla.getJSONObject(temperaturaStr);
        String factor = fila.getString(salinidadStr);
        
        try{
            return Double.parseDouble(factor);
        }
        catch(NumberFormatException e){
            return -1.0;
        }
    }
    
}

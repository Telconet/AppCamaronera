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
public class TablaOxigenoSaturacion {
    JSONObject tabla;
    
    public TablaOxigenoSaturacion(String json){
        tabla = new JSONObject(json);
    }
    
    
    /**
     * Nos devuelve el nivel de oxigeno (mg/L) de saturación)
     * @param temperatura
     * @param presion
     * @return 
     */
    public double obtenerOxigenoSaturacion(double temperatura, int presion){
        
        String temperaturaStr = String.format(Locale.US, "%.1f",temperatura);
        String presionStr = String.format("%d", presion);
        
        JSONObject fila = tabla.getJSONObject(temperaturaStr);
        
        String oxigeno = fila.getString(presionStr);
        
        try{
            return Double.parseDouble(oxigeno);
        }
        catch(NumberFormatException e){
            return -1.0;
        }
    }
}

<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<%
            String homedir = System.getProperty("catalina.home");
            String jspPath=homedir+File.separator +"logs"+ File.separator;
            //String jspPath = "/opt/ScadaBR-EF/tomcat/logs/";
            String fileName = "mango.log";
            String txtFilePath = jspPath + fileName;
%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Read Text</title>
    </head>
    <body>

  <h2>Dados da Instalacao</h2>    
  <font sixe = "2" face="Verdana, Arial "  >
  <b> usuario: </b>
   <%=System.getProperty("user.name").toUpperCase() %><br/>
  <b> sistema: </b>
   <%=System.getProperty("os.name") %><br/>
  <b> Versao: </b>
   <%=System.getProperty("os.version").toUpperCase() %><br/>
  <b> Arquitetura: </b>
   <%=System.getProperty("os.arch") %><br/>
        
  <b> Versao do Java: </b>
   <%=System.getProperty("java.version") %><br/>
  <b> pasta do usuario: </b>
   <%=System.getProperty("user.home") %><br/>
 <b> Versao do Java: </b>
   <%=System.getProperty("java.version") %> 
   <b> Vendor: </b>    
   <%=System.getProperty("java.vendor") %><br/>
<b> CATALINA_BASE: </b>    
        <%=System.getProperty("catalina.base") %><br/>
<b> CATALINA_HOME: </b>        
        <%=System.getProperty("catalina.home") %><br/>
    
    <%!
  
    final boolean IsVerbo(String palavra)
    {
        if (palavra.equals("WARN"))       return true ; 
        else if (palavra.equals("ERRO"))  return true ;
        else if (palavra.equals("INFO"))  return true ;
        else return false;
    }
    
    final String ProcessaCMD(String strlinha)
                { 
                String sVerbo;
                String sClasse;
                String sData;
                String sMensagem;
                int i;
                int f;
                StringBuilder s = new StringBuilder();
                
                sVerbo=strlinha.substring(0,4);
                /* Se a linha comeca com Verbo, processa, senao
                   adiciona linha 
                */

                if (IsVerbo(sVerbo)) { 
                // É um verbo valido, processa a linha
                sData=strlinha.substring(6,30);
                sClasse=strlinha.substring(strlinha.indexOf("(")+1,strlinha.indexOf(")"));
             // mensagem inicia em - e termina no fim da linha
                f=strlinha.length();
                 sMensagem=(strlinha.substring(strlinha.indexOf('-',33),f));
                //sMensagem="Mensagem";
                String stINFO="style='background-color:#80e080;'";
                String stWARN="style='background-color:#fab469;'";
                String stERROR="style='background-color:#ffe0e0;'";
                String stTitulo="style='background-color:#aae;'";
                
                 if (sVerbo.equals("ERROR")){s.append("<td "+stERROR+">"+sVerbo+"</td>");}
                 if (sVerbo.equals("WARN" )){s.append("<td "+stWARN+ ">"+sVerbo+"</td>");}
                 if (sVerbo.equals("INFO" )){s.append("<td "+stINFO+ ">"+sVerbo+"</td>");}

                 s.append("<td>"+sData+"</td>");
                 s.append("<td>Classe:<br/>"+sClasse+"</td>");
                 s.append("<td>Mensagem:<br/>"+sMensagem+"</td>");
                 s.append("</tr>");

                 String singleString = s.toString();
                 return singleString;
                } else
                {
                  /* a linha não inicia com verbo, faz parte da linha anterior  */
                  s.append("<tr><td colspan='4'>"+strlinha+"</td></tr>");
                  return "";  
                }
                  
        }

    final String Processa(String linhaDoArquivo)
    {
      return ("Recebi a linha: <tt>"+linhaDoArquivo+"</tt><br/>");
    }
        %>
       <h2>Conteudo do arquivo</h2>
        <% 
 
  
            BufferedReader reader = new BufferedReader(new FileReader(txtFilePath));
            StringBuilder sb = new StringBuilder();
            StringBuilder sbTemp = new StringBuilder();
            String line;
            String sLinha = "";
            boolean flagSecundario = false;
            
            out.print("<p>arquivo: <b> ");
            out.println(txtFilePath+"</b></p>");
            out.print("<p>tabela abaixo:</p> ");
            out.print("<table border='1'>");
            
            while (true) {
				line = reader.readLine();
				
				if (line == null)
					break;
				/*
					Toda linha de comando começa com um verbo em MAIÚSCULAS
					vamos detectá-lo por Regex.
				*/   
				if (line.matches("^[A-Z]{4,15}...?[0-9]+.*$")) {
					// Encerrar células de linhas não-comando anteriores
					if (sbTemp.toString().length(   ) > 0)
						{ 
					  	  /* 
						    se FlagSecundario for Verdade, significa que 
						    se deve terminar a celula secundaria
						  */
						   
						if (flagSecundario = true) 
					 	  {
					 	   	sbTemp.append("</td> </tr>");
					 	   	flagSecundario = false;
						  }
						}
					// Adicionar comando à tabela
					sbTemp.append(ProcessaCMD(line)+"\n");	
					
					// Criar célula para receber as linhas não-comando subsequentes
					sbTemp.append("<td colspan='4'><tt>");
				} else if (sbTemp.toString().length() > 0) {
					sbTemp.append(line + "</tt><br>\n");
					flagSecundario=true;
				}
			}
			
			out.println(sbTemp.toString()); 
            out.print("</table>");
            
    %>
<h2> Lista dos arquivos de log </h2>

<h1>Arquivos de Log</h1>
 
 <ul>
<%
String root=System.getProperty("catalina.home")+File.separator+"logs"+File.separator  ;
java.io.File file;
java.io.File dir = new java.io.File(root);

String[] list = dir.list();

if (list.length > 0) {

for (int i = 0; i < list.length; i++) {
  file = new java.io.File(root + list[i]);
  if (!file.isDirectory()) {
  %>
  <li><a href="<%=list[i]%>" target="_top"><%=root+list[i]%></a><br>
  <%
     }
  }
}
%>
</ul>
 
 
<p> fim da lista
</p><br/>



    </body>
</html>

 

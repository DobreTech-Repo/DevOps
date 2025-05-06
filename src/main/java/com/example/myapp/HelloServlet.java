package com.example.myapp;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head>");
        out.println("<title>DevOps Pipeline Demo DobreTech</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }");
        out.println(".container { max-width: 800px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }");
        out.println("h1 { color: #333; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h1>Hello from DevOps Pipeline!</h1>");
        out.println("<p>This is a simple Java servlet deployed through our DevOps pipeline.</p>");
        out.println("<p>Server time: " + new java.util.Date() + "</p>");
        out.println("<p>Components used:</p>");
        out.println("<ul>");
        out.println("<li>GitHub</li>");
        out.println("<li>Jenkins</li>");
        out.println("<li>SonarQube</li>");
        out.println("<li>Maven</li>");
        out.println("<li>Nexus Repository</li>");
        out.println("<li>Ansible</li>");
        out.println("<li>Apache Web Server</li>");
        out.println("<li>Prometheus and Grafana</li>");
        out.println("</ul>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}

package controller.warehouse;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import utils.AuthorizationService;

@WebServlet(name = "ViewWarehousesServlet", urlPatterns = {"/admin/viewWarehouses"})
public class ViewWarehousesServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        response.setContentType("text/html;charset=UTF-8");

        // Chỉ forward đến JSP, JSP sẽ tự xử lý database bằng DAO
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/warehouse-list.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet that forwards to the warehouse list JSP.";
    }
}

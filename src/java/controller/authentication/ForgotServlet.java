/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.authentication;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SendMailOK;
import jakarta.mail.internet.MimeUtility;

@WebServlet(name = "ForgotServlet", urlPatterns = {"/forgotpass"})
public class ForgotServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO(); // Khởi tạo DAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/forgot.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email không được để trống.");
            request.getRequestDispatcher("forgot.jsp").forward(request, response);
            return;
        }

        boolean exists = userDAO.emailExists(email);
        if (!exists) {
            request.setAttribute("error", "Email chưa được đăng ký trong hệ thống.");
            request.getRequestDispatcher("forgot.jsp").forward(request, response);
            return;
        }

        try {
            // 1. Tạo mật khẩu mới ngẫu nhiên
            String newPassword = generateRandomPassword(8);

            // 2. Cập nhật mật khẩu mới cho user (nếu có mã hóa thì nhớ mã hóa)
            userDAO.updatePasswordByEmail(email, newPassword);

            // 3. Gửi mail mật khẩu mới cho user
            String subject = MimeUtility.encodeText("Thông báo cấp lại mật khẩu - Warehouse System", "UTF-8", "B");

            String body = """
             <div style='font-family: Arial, sans-serif; line-height: 1.6;'>
             <p>Xin chào bạn,</p>

             <p>Hệ thống Warehouse đã nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.<br>
              Mật khẩu tạm thời mới của bạn là:</p>

             <p style='font-size:16px; font-weight:bold; color:#2C3E50;'>
             """ + newPassword + """
              </p>

              <p>Vui lòng sử dụng mật khẩu này để đăng nhập và <b>đổi mật khẩu ngay sau khi đăng nhập</b> 
              nhằm đảm bảo an toàn cho tài khoản của bạn.</p>

             <p>Nếu bạn không thực hiện yêu cầu này, vui lòng liên hệ với bộ phận hỗ trợ của chúng tôi để được trợ giúp.</p>

             <p>Trân trọng,<br>
        
    </div>
""";

            SendMailOK.send("smtp.gmail.com", email, "minhnche180504@fpt.edu.vn", "sddk wkin vtqo drxe", subject, body);

            request.setAttribute("success", "Mật khẩu mới đã được gửi đến email của bạn.");
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi gửi email. Vui lòng thử lại.");
        }

        request.getRequestDispatcher("forgot.jsp").forward(request, response);
    }

// Hàm tạo password ngẫu nhiên (ký tự chữ và số)
    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }

}

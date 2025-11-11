/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Nguyen Duc Thinh
 */
public class AuthorizeDAO extends DBConnect{

    public AuthorizeDAO() {
    }

    // Load Authorization Map from Database
    public Map<String, String> loadAuthorizeMap() throws SQLException {
        Map<String, String> authorizeMap = new HashMap<>();
        String query = "SELECT [path], [user] FROM [AuthorizeMap]";

        try (PreparedStatement ps = connection.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                authorizeMap.put(rs.getString("path"), rs.getString("user"));
            }
        } catch (SQLException e) {
            throw new SQLException("Error loading authorization map", e);
        }

        return authorizeMap;
    }

    // Update Authorization Data
    public void setAuthorize(String path, String roles) throws SQLException {
        if (connection == null) {
            throw new SQLException("Lỗi: Không có kết nối đến database.");
        }

        if (path == null || path.trim().isEmpty()) {
            throw new IllegalArgumentException("Lỗi: `path` không được để trống.");
        }

        if (roles == null) {
            roles = ""; // Lưu vào database dưới dạng chuỗi rỗng nếu không có role nào
        }

        String query = "UPDATE [AuthorizeMap] SET [user] = ? WHERE [path] = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, roles);
            ps.setString(2, path);

            int affectedRows = ps.executeUpdate(); // Thực thi cập nhật

            if (affectedRows == 0) {
                throw new SQLException("Không có bản ghi nào được cập nhật! Path có thể không tồn tại: " + path);
            }

            System.out.println("Cập nhật thành công! Path: " + path + ", Roles: " + roles);
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi cập nhật quyền: " + e.getMessage());
            throw new SQLException("Lỗi khi cập nhật authorization map", e);
        }
    }
}

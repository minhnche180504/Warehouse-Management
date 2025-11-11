package dao;

import model.Supplier;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SupplierDAO extends DBConnect {

    protected ResultSet resultSet;
    protected PreparedStatement statement;

    public void closeResources() {
        try {
            if (resultSet != null && !resultSet.isClosed()) {
                resultSet.close();
            }
            if (statement != null && !statement.isClosed()) {
                statement.close();
            }
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException ex) {
            Logger.getLogger(SupplierDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConnection() {
        return new DBConnect().connection;
    }

    public Integer insert(Supplier supplier) {
        String sql = "INSERT INTO Supplier (name, address, phone, email, contact_person, date_created, is_delete) " +
                "VALUES (?, ?, ?, ?, ?, GETDATE(), 0)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, supplier.getName());
            statement.setString(2, supplier.getAddress());
            statement.setString(3, supplier.getPhone());
            statement.setString(4, supplier.getEmail());
            statement.setString(5, supplier.getContactPerson());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating supplier failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating supplier failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting supplier: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    public Boolean update(Supplier supplier) {
        String sql = "UPDATE Supplier SET name=?, address=?, phone=?, email=?, contact_person=?, " +
                "last_updated=GETDATE() WHERE supplier_id=? AND is_delete=0";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, supplier.getName());
            statement.setString(2, supplier.getAddress());
            statement.setString(3, supplier.getPhone());
            statement.setString(4, supplier.getEmail());
            statement.setString(5, supplier.getContactPerson());
            statement.setInt(6, supplier.getSupplierId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating supplier: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public Boolean delete(Integer supplierId) {
        String sql = "UPDATE Supplier SET is_delete=1, last_updated=GETDATE() WHERE supplier_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, supplierId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting supplier: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public Boolean restore(Integer supplierId) {
        String sql = "UPDATE Supplier SET is_delete=0, last_updated=GETDATE() WHERE supplier_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, supplierId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error restoring supplier: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public Supplier getById(Integer supplierId) {
        String sql = "SELECT * FROM Supplier WHERE supplier_id=? AND is_delete=0";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, supplierId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting supplier by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public Supplier getByIdIncludeDeleted(Integer supplierId) {
        String sql = "SELECT * FROM Supplier WHERE supplier_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, supplierId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting supplier by ID (include deleted): " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<Supplier> getAll() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM Supplier WHERE is_delete=0 ORDER BY supplier_id";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                suppliers.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting all suppliers: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return suppliers;
    }

    public List<Supplier> findSuppliersWithFilters(String nameFilter, String emailFilter, String phoneFilter, 
                                                   String contactPersonFilter, String statusFilter, Integer page, Integer pageSize) {
        List<Supplier> suppliers = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Supplier WHERE 1=1");

        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            if ("active".equals(statusFilter)) {
                sql.append(" AND is_delete=0");
            } else if ("deleted".equals(statusFilter)) {
                sql.append(" AND is_delete=1");
            }
        }
        // If no status filter, show all (both active and deleted)

        // Add other filters
        if (nameFilter != null && !nameFilter.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
        }
        if (emailFilter != null && !emailFilter.trim().isEmpty()) {
            sql.append(" AND email LIKE ?");
        }
        if (phoneFilter != null && !phoneFilter.trim().isEmpty()) {
            sql.append(" AND phone LIKE ?");
        }
        if (contactPersonFilter != null && !contactPersonFilter.trim().isEmpty()) {
            sql.append(" AND contact_person LIKE ?");
        }

        sql.append(" ORDER BY supplier_id");

        // Add pagination
        if (page != null && pageSize != null) {
            sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (nameFilter != null && !nameFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + nameFilter + "%");
            }
            if (emailFilter != null && !emailFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + emailFilter + "%");
            }
            if (phoneFilter != null && !phoneFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + phoneFilter + "%");
            }
            if (contactPersonFilter != null && !contactPersonFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + contactPersonFilter + "%");
            }

            if (page != null && pageSize != null) {
                statement.setInt(paramIndex++, (page - 1) * pageSize);
                statement.setInt(paramIndex, pageSize);
            }

            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                suppliers.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding suppliers with filters: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return suppliers;
    }

    public Integer getTotalFilteredSuppliers(String nameFilter, String emailFilter, String phoneFilter, 
                                           String contactPersonFilter, String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Supplier WHERE 1=1");

        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            if ("active".equals(statusFilter)) {
                sql.append(" AND is_delete=0");
            } else if ("deleted".equals(statusFilter)) {
                sql.append(" AND is_delete=1");
            }
        }
        // If no status filter, show all (both active and deleted)

        // Add other filters
        if (nameFilter != null && !nameFilter.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
        }
        if (emailFilter != null && !emailFilter.trim().isEmpty()) {
            sql.append(" AND email LIKE ?");
        }
        if (phoneFilter != null && !phoneFilter.trim().isEmpty()) {
            sql.append(" AND phone LIKE ?");
        }
        if (contactPersonFilter != null && !contactPersonFilter.trim().isEmpty()) {
            sql.append(" AND contact_person LIKE ?");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (nameFilter != null && !nameFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + nameFilter + "%");
            }
            if (emailFilter != null && !emailFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + emailFilter + "%");
            }
            if (phoneFilter != null && !phoneFilter.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + phoneFilter + "%");
            }
            if (contactPersonFilter != null && !contactPersonFilter.trim().isEmpty()) {
                statement.setString(paramIndex, "%" + contactPersonFilter + "%");
            }

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting total filtered suppliers: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public Boolean isNameExists(String name, Integer supplierId) {
        String sql = "SELECT COUNT(*) FROM Supplier WHERE name = ? AND is_delete=0";

        if (supplierId != null) {
            sql += " AND supplier_id <> ?";
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, name);

            if (supplierId != null) {
                statement.setInt(2, supplierId);
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking if name exists: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public Boolean isPhoneExists(String phone, Integer supplierId) {
        String sql = "SELECT COUNT(*) FROM Supplier WHERE phone = ? AND is_delete=0";

        if (supplierId != null) {
            sql += " AND supplier_id <> ?";
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, phone);

            if (supplierId != null) {
                statement.setInt(2, supplierId);
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking if phone exists: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public Boolean isEmailExists(String email, Integer supplierId) {
        String sql = "SELECT COUNT(*) FROM Supplier WHERE email = ? AND is_delete=0";

        if (supplierId != null) {
            sql += " AND supplier_id <> ?";
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);

            if (supplierId != null) {
                statement.setInt(2, supplierId);
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking if email exists: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public Supplier getFromResultSet(ResultSet rs) throws SQLException {
        Supplier supplier = new Supplier();
        supplier.setSupplierId(rs.getInt("supplier_id"));
        supplier.setName(rs.getString("name"));
        supplier.setAddress(rs.getString("address"));
        supplier.setPhone(rs.getString("phone"));
        supplier.setEmail(rs.getString("email"));
        supplier.setContactPerson(rs.getString("contact_person"));
        supplier.setDateCreated(rs.getDate("date_created"));
        supplier.setLastUpdated(rs.getDate("last_updated"));
        supplier.setIsDelete(rs.getBoolean("is_delete"));
        return supplier;
    }
} 
package dao;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Unit;

public class UnitDAO extends DBConnect {

    private PreparedStatement statement;
    private ResultSet resultSet;

    private void closeResources() {
        try {
            if (resultSet != null) {
                resultSet.close();
            }
            if (statement != null) {
                statement.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int create(Unit unit) {
        String sql = "INSERT INTO Unit (unit_name, unit_code, description, is_active, created_at, last_updated) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, unit.getUnitName());
            ps.setString(2, unit.getUnitCode());
            ps.setString(3, unit.getDescription());
            ps.setBoolean(4, unit.isIsActive());
            
            // Use current timestamp if not provided
            LocalDateTime now = LocalDateTime.now();
            ps.setTimestamp(5, unit.getCreatedAt() != null 
                    ? Timestamp.valueOf(unit.getCreatedAt()) 
                    : Timestamp.valueOf(now));
            ps.setTimestamp(6, unit.getLastUpdated() != null 
                    ? Timestamp.valueOf(unit.getLastUpdated()) 
                    : Timestamp.valueOf(now));

            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                return -1;
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    return -1;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating unit: " + e.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    public boolean update(Unit unit) {
        String sql = "UPDATE Unit SET unit_name = ?, unit_code = ?, description = ?, "
                + "is_active = ?, last_updated = ? WHERE unit_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, unit.getUnitName());
            ps.setString(2, unit.getUnitCode());
            ps.setString(3, unit.getDescription());
            ps.setBoolean(4, unit.isIsActive());
            ps.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(6, unit.getUnitId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating unit: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean delete(int unitId) {
        String sql = "DELETE FROM Unit WHERE unit_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, unitId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting unit: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    // Soft delete alternative by setting is_active to false
    public boolean softDelete(int unitId) {
        String sql = "UPDATE Unit SET is_active = 0, last_updated = ? WHERE unit_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, unitId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error soft deleting unit: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public Unit getById(int unitId) {
        String sql = "SELECT * FROM Unit WHERE unit_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, unitId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUnit(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving unit by ID: " + e.getMessage());
        } finally {
            closeResources();
        }

        return null;
    }

    public Unit getByCode(String unitCode) {
        String sql = "SELECT * FROM Unit WHERE unit_code = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, unitCode);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUnit(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving unit by code: " + e.getMessage());
        } finally {
            closeResources();
        }

        return null;
    }

    public List<Unit> getAll() {
        List<Unit> units = new ArrayList<>();
        String sql = "SELECT * FROM Unit";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                units.add(mapResultSetToUnit(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving all units: " + e.getMessage());
        } finally {
            closeResources();
        }

        return units;
    }

    public List<Unit> getAllActive() {
        List<Unit> units = new ArrayList<>();
        String sql = "SELECT * FROM Unit WHERE is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                units.add(mapResultSetToUnit(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving active units: " + e.getMessage());
        } finally {
            closeResources();
        }

        return units;
    }

    public boolean isUnitCodeUnique(String unitCode, Integer excludeUnitId) {
        String sql = "SELECT COUNT(*) FROM Unit WHERE unit_code = ?";
        
        if (excludeUnitId != null) {
            sql += " AND unit_id != ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, unitCode);
            
            if (excludeUnitId != null) {
                ps.setInt(2, excludeUnitId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking unit code uniqueness: " + e.getMessage());
        } finally {
            closeResources();
        }

        return false;
    }

    public boolean isUnitNameUnique(String unitName, Integer excludeUnitId) {
        String sql = "SELECT COUNT(*) FROM Unit WHERE unit_name = ?";
        
        if (excludeUnitId != null) {
            sql += " AND unit_id != ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, unitName);
            
            if (excludeUnitId != null) {
                ps.setInt(2, excludeUnitId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking unit name uniqueness: " + e.getMessage());
        } finally {
            closeResources();
        }

        return false;
    }

    private Unit mapResultSetToUnit(ResultSet rs) throws SQLException {
        Unit unit = new Unit();
        unit.setUnitId(rs.getInt("unit_id"));
        unit.setUnitName(rs.getString("unit_name"));
        unit.setUnitCode(rs.getString("unit_code"));
        unit.setDescription(rs.getString("description"));
        unit.setIsActive(rs.getBoolean("is_active"));
        
        Timestamp createdTimestamp = rs.getTimestamp("created_at");
        if (createdTimestamp != null) {
            unit.setCreatedAt(createdTimestamp.toLocalDateTime());
        }
        
        Timestamp updatedTimestamp = rs.getTimestamp("last_updated");
        if (updatedTimestamp != null) {
            unit.setLastUpdated(updatedTimestamp.toLocalDateTime());
        }
        
        return unit;
    }
}

package dao;

import model.SupplierRating;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SupplierRatingDAO extends DBConnect {

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
            Logger.getLogger(SupplierRatingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConnection() {
        return new DBConnect().connection;
    }

    public Integer insert(SupplierRating rating) {
        String sql = "INSERT INTO Supplier_Rating (supplier_id, user_id, delivery_score, quality_score, " +
                "service_score, price_score, comment, rating_date) VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, rating.getSupplierId());
            statement.setInt(2, rating.getUserId());
            statement.setInt(3, rating.getDeliveryScore());
            statement.setInt(4, rating.getQualityScore());
            statement.setInt(5, rating.getServiceScore());
            statement.setInt(6, rating.getPriceScore());
            statement.setString(7, rating.getComment());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating rating failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating rating failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting rating: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    public Boolean update(SupplierRating rating) {
        String sql = "UPDATE Supplier_Rating SET delivery_score=?, quality_score=?, service_score=?, " +
                "price_score=?, comment=? WHERE rating_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, rating.getDeliveryScore());
            statement.setInt(2, rating.getQualityScore());
            statement.setInt(3, rating.getServiceScore());
            statement.setInt(4, rating.getPriceScore());
            statement.setString(5, rating.getComment());
            statement.setInt(6, rating.getRatingId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating rating: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public Boolean delete(Integer ratingId) {
        String sql = "DELETE FROM Supplier_Rating WHERE rating_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, ratingId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting rating: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public SupplierRating getById(Integer ratingId) {
        String sql = "SELECT * FROM Supplier_Rating WHERE rating_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, ratingId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting rating by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<SupplierRating> getBySupplier(Integer supplierId) {
        List<SupplierRating> ratings = new ArrayList<>();
        String sql = "SELECT * FROM Supplier_Rating WHERE supplier_id=? ORDER BY rating_date DESC";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, supplierId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                ratings.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting ratings by supplier: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return ratings;
    }

    public List<SupplierRating> getByUser(Integer userId) {
        List<SupplierRating> ratings = new ArrayList<>();
        String sql = "SELECT * FROM Supplier_Rating WHERE user_id=? ORDER BY rating_date DESC";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                ratings.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting ratings by user: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return ratings;
    }

    public List<SupplierRating> findRatingsWithFilters(Integer supplierId, Integer userId, 
                                                      Integer minScore, Integer maxScore, 
                                                      Integer page, Integer pageSize) {
        List<SupplierRating> ratings = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Supplier_Rating WHERE 1=1");

        if (supplierId != null) {
            sql.append(" AND supplier_id=").append(supplierId);
        }

        if (userId != null) {
            sql.append(" AND user_id=").append(userId);
        }

        if (minScore != null) {
            sql.append(" AND (delivery_score + quality_score + service_score + price_score) / 4.0 >= ").append(minScore);
        }

        if (maxScore != null) {
            sql.append(" AND (delivery_score + quality_score + service_score + price_score) / 4.0 <= ").append(maxScore);
        }

        sql.append(" ORDER BY rating_date DESC");

        if (page != null && pageSize != null) {
            int offset = (page - 1) * pageSize;
            sql.append(" OFFSET ").append(offset).append(" ROWS FETCH NEXT ").append(pageSize).append(" ROWS ONLY");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                ratings.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding ratings with filters: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return ratings;
    }

    public Integer getTotalFilteredRatings(Integer supplierId, Integer userId, 
                                         Integer minScore, Integer maxScore) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Supplier_Rating WHERE 1=1");

        if (supplierId != null) {
            sql.append(" AND supplier_id=").append(supplierId);
        }

        if (userId != null) {
            sql.append(" AND user_id=").append(userId);
        }

        if (minScore != null) {
            sql.append(" AND (delivery_score + quality_score + service_score + price_score) / 4.0 >= ").append(minScore);
        }

        if (maxScore != null) {
            sql.append(" AND (delivery_score + quality_score + service_score + price_score) / 4.0 <= ").append(maxScore);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting total filtered ratings: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public Double getAverageRatingForSupplier(Integer supplierId) {
        String sql = "SELECT AVG((delivery_score + quality_score + service_score + price_score) / 4.0) " +
                "FROM Supplier_Rating WHERE supplier_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, supplierId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getDouble(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting average rating: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0.0;
    }

    public Boolean hasUserRatedSupplier(Integer userId, Integer supplierId) {
        String sql = "SELECT COUNT(*) FROM Supplier_Rating WHERE user_id=? AND supplier_id=?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, supplierId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking if user rated supplier: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    public SupplierRating getFromResultSet(ResultSet rs) throws SQLException {
        SupplierRating rating = new SupplierRating();
        rating.setRatingId(rs.getInt("rating_id"));
        rating.setSupplierId(rs.getInt("supplier_id"));
        rating.setUserId(rs.getInt("user_id"));
        rating.setDeliveryScore(rs.getInt("delivery_score"));
        rating.setQualityScore(rs.getInt("quality_score"));
        rating.setServiceScore(rs.getInt("service_score"));
        rating.setPriceScore(rs.getInt("price_score"));
        rating.setComment(rs.getString("comment"));
        rating.setRatingDate(rs.getDate("rating_date"));
        return rating;
    }
} 
package model;

import java.sql.Date;

public class User {
    private int userId;
    private String username;
    private String password;
    private String firstName;
    private String lastName;
    private int roleId;
    private String gender;
    private String address;
    private String email;
    private Date dateOfBirth;
    private String profilePic;
    private Role role;
    private Integer warehouseId;
    private String warehouseName;
    
    // NEW: Add status field
    private String status;
    
    // NEW: is_active field for backward compatibility
    private boolean isActive = true; // Default to active

    public User() {}
    
    public User(int userId, String username, String password, String firstName, String lastName,
                int roleId, String gender, String address, String email, Date dateOfBirth, 
                String profilePic, Integer warehouseId, boolean isActive, String status) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.firstName = firstName;
        this.lastName = lastName;
        this.roleId = roleId;
        this.gender = gender;
        this.address = address;
        this.email = email;
        this.dateOfBirth = dateOfBirth;
        this.profilePic = profilePic;
        this.warehouseId = warehouseId;
        this.isActive = isActive;
        this.status = status;
    }

    // Existing getters and setters...
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getFullName() { return firstName + " " + lastName; }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getProfilePic() { return profilePic; }
    public void setProfilePic(String profilePic) { this.profilePic = profilePic; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public Integer getWarehouseId() { return warehouseId; }
    public void setWarehouseId(Integer warehouseId) { this.warehouseId = warehouseId; }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }
    
    // NEW: status getter and setter
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
        // Optionally sync isActive boolean with status string
        this.isActive = "Active".equalsIgnoreCase(status);
    }
    
    // isActive getter and setter for backward compatibility
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { this.isActive = active; }
    
    // Utility method to get status as string
    public String getStatusText() {
        return status != null ? status : (isActive ? "Active" : "Inactive");
    }
    
    // Utility method to get CSS class for status badge
    public String getStatusCssClass() {
        return "Active".equalsIgnoreCase(status) ? "bg-success" : "bg-secondary";
    }
    
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", roleId=" + roleId +
                ", status=" + status +
                ", warehouseId=" + warehouseId +
                '}';
    }
}

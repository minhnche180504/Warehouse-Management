package model;

import java.sql.Date;

public class Supplier {
    private Integer supplierId;
    private String name;
    private String address;
    private String phone;
    private String email;
    private String contactPerson;
    private Date dateCreated;
    private Date lastUpdated;
    private Boolean isDelete;

    // Default constructor
    public Supplier() {
    }

    // All-args constructor
    public Supplier(Integer supplierId, String name, String address, String phone, String email, 
                   String contactPerson, Date dateCreated, Date lastUpdated, Boolean isDelete) {
        this.supplierId = supplierId;
        this.name = name;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.contactPerson = contactPerson;
        this.dateCreated = dateCreated;
        this.lastUpdated = lastUpdated;
        this.isDelete = isDelete;
    }

    // Builder pattern implementation
    public static class Builder {
        private Integer supplierId;
        private String name;
        private String address;
        private String phone;
        private String email;
        private String contactPerson;
        private Date dateCreated;
        private Date lastUpdated;
        private Boolean isDelete;

        public Builder supplierId(Integer supplierId) {
            this.supplierId = supplierId;
            return this;
        }

        public Builder name(String name) {
            this.name = name;
            return this;
        }

        public Builder address(String address) {
            this.address = address;
            return this;
        }

        public Builder phone(String phone) {
            this.phone = phone;
            return this;
        }

        public Builder email(String email) {
            this.email = email;
            return this;
        }

        public Builder contactPerson(String contactPerson) {
            this.contactPerson = contactPerson;
            return this;
        }

        public Builder dateCreated(Date dateCreated) {
            this.dateCreated = dateCreated;
            return this;
        }

        public Builder lastUpdated(Date lastUpdated) {
            this.lastUpdated = lastUpdated;
            return this;
        }

        public Builder isDelete(Boolean isDelete) {
            this.isDelete = isDelete;
            return this;
        }

        public Supplier build() {
            return new Supplier(supplierId, name, address, phone, email, contactPerson, 
                              dateCreated, lastUpdated, isDelete);
        }
    }

    public static Builder builder() {
        return new Builder();
    }

    // Getters and Setters
    public Integer getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Integer supplierId) {
        this.supplierId = supplierId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public Date getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated;
    }

    public Date getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public Boolean getIsDelete() {
        return isDelete;
    }

    public void setIsDelete(Boolean isDelete) {
        this.isDelete = isDelete;
    }

    // Getter method for JSP compatibility
    public Boolean getIsDeleted() {
        return this.isDelete;
    }

    @Override
    public String toString() {
        return "Supplier{" +
                "supplierId=" + supplierId +
                ", name='" + name + '\'' +
                ", address='" + address + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", contactPerson='" + contactPerson + '\'' +
                ", dateCreated=" + dateCreated +
                ", lastUpdated=" + lastUpdated +
                ", isDelete=" + isDelete +
                '}';
    }
} 
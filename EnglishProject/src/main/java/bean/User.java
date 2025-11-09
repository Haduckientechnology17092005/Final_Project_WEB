package bean;
import java.sql.Timestamp;

public class User {
    private int id;
    private String email;
    private String username;
    private String password;
    private String role;
    private boolean emailVerified;
    private String verificationToken;
    private String resetToken;
    private Timestamp resetTokenExpiry;
    
    public User() {
    }
    
    public User(int id, String email, String password, String role) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.role = role;
    }
    
    public User(int id, String email, String password) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.role = "user"; // Default role
    }
    
    public User(int id, String email, String username, String password, boolean emailVerified, String verificationToken)
    {
    	this.id = id;
    	this.email = email;
    	this.username=username;
    	this.password=password;
    	this.emailVerified=false;
    	this.verificationToken = verificationToken;
    }
    
    public User(String email, String username, String password) {
        this.email = email;
        this.username = username;
        this.password = password;
        this.role = "user";
        this.emailVerified = false;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public boolean isEmailVerified() {
		return emailVerified;
	}

	public void setEmailVerified(boolean emailVerified) {
		this.emailVerified = emailVerified;
	}

	public String getVerificationToken() {
		return verificationToken;
	}

	public void setVerificationToken(String verificationToken) {
		this.verificationToken = verificationToken;
	}

	public String getResetToken() {
		return resetToken;
	}

	public void setResetToken(String resetToken) {
		this.resetToken = resetToken;
	}

	public Timestamp getResesetTokenExpiry() {
		return resetTokenExpiry;
	}

	public void setResesetTokenExpiry(Timestamp resetTokenExpiry) {
		this.resetTokenExpiry = resetTokenExpiry;
	}

	public void setPassword(String password) {
        this.password = password;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", email='" + email + '\'' +
                ", username='" + username + '\'' +
                ", role='" + role + '\'' +
                ", emailVerified=" + emailVerified +
                '}';
    }
} 
package bo;

import dao.LoginDAO;
import bean.User;

public class LoginBO {
    private LoginDAO loginDAO;
    
    public LoginBO() {
        loginDAO = new LoginDAO();
    }
    
    // validate user credentials and return user object if valid
    public User authenticateUser(String email, String password) {
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            return null;
        }
        
        User user =  loginDAO.validateUser(email, password);
        
        if(user == null)
        {
        	return null;
        }
        
        if(!user.isEmailVerified())
        {
        	return null;
        }
        
        return user;
    }
    
    // check if user exists in database
    public boolean userExists(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        return loginDAO.checkUserExists(email);
    }
    
    // get user by email
    public User getUserByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        
        return loginDAO.getUserByEmail(email);
    }
} 
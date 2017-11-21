package au.com.dstil.ceres.services;

import au.com.dstil.ceres.entities.User.CustomUserDetails;
import au.com.dstil.ceres.entities.User.User;
import au.com.dstil.ceres.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username);
        return new CustomUserDetails(user);
    }
}

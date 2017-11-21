package au.com.dstil.ceres.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import javax.sql.DataSource;

@Configuration
public class AuthorizationServerSecurityConfig extends WebSecurityConfigurerAdapter {

    /** The DataSource that persists client/user/session data. */
    @Autowired
    DataSource dataSource;

    /** Provides a mechanism for securely hashing passwords before storing them in the database. */
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    /**
     * Configures an AuthenticationManager that uses JDBC-backed authentication
     * with simplified role-based authorisation.
     */
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.jdbcAuthentication()
            .dataSource(dataSource)
            .passwordEncoder(passwordEncoder)
            .usersByUsernameQuery(
                "select username, password, enabled from users where username=?")
            .authoritiesByUsernameQuery(
                "select users_username, roles_role_name from users_roles where users_username=?");
    }

    /**
     * Provides a mechanism for processing authentication requests.
     */
    @Override
    @Bean
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    /**
     * Configures security constraints for requests handled by this Authorisation Server.
     */
    @Override
    protected void configure(HttpSecurity http) throws Exception {
//        http.authorizeRequests()
//            .antMatchers("/login").permitAll()
//            .anyRequest().authenticated()
//            .and()
//            .formLogin().permitAll();
        http.authorizeRequests().anyRequest().authenticated();
    }
}

package au.com.dstil.ceres.config;

import au.com.dstil.ceres.services.CustomUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.core.env.Environment;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.oauth2.config.annotation.configurers.ClientDetailsServiceConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configuration.AuthorizationServerConfigurerAdapter;
import org.springframework.security.oauth2.config.annotation.web.configuration.EnableAuthorizationServer;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerEndpointsConfigurer;
import org.springframework.security.oauth2.config.annotation.web.configurers.AuthorizationServerSecurityConfigurer;
import org.springframework.security.oauth2.provider.code.AuthorizationCodeServices;
import org.springframework.security.oauth2.provider.code.JdbcAuthorizationCodeServices;
import org.springframework.security.oauth2.provider.token.TokenStore;
import org.springframework.security.oauth2.provider.token.store.JdbcTokenStore;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import javax.sql.DataSource;
import java.util.Arrays;

/**
 * Configures the application to act as an OAuth2 Authorisation Server.
 */
@Configuration
@EnableAuthorizationServer
@Order(2)
public class AuthorizationServerConfig extends AuthorizationServerConfigurerAdapter {

    /** The execution environment of the Spring application. Used for enforcing SSL in production. */
    @Autowired
    private Environment environment;

    /** The AuthenticationManager responsible for protecting the resources. Required for use of the 'password' grant type. */
    @Autowired
    @Qualifier("authenticationManagerBean")
    private AuthenticationManager authenticationManager;

    /** The DataSource that provides storage for clients, tokens, sessions, etc. */
    @Autowired
    private DataSource dataSource;

    /** Provides the mechanism for persisting OAuth2 tokens to the DataSource. */
    @Bean
    public TokenStore tokenStore() {
        return new JdbcTokenStore(dataSource);
    }

    /** Provides the interface for issuing and storing authorization codes. */
    @Bean
    protected AuthorizationCodeServices authorizationCodeServices() {
        return new JdbcAuthorizationCodeServices(dataSource);
    }

    /** Provides a mechanism for securely hashing passwords before storing them in the database. */
    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * Configures the ClientDetailsService, which is responsible for controlling what type of access
     * is granted to each Client. A Client is an application that accesses resources on behalf
     * of the Resource Owner (a.k.a. the user).
     *
     * The ClientDetailsService can be in-memory (session data lost upon restart) or backed by
     * a JDBC DataSource (more suitable for production environments).
     *
     * Useful links:
     *   - https://projects.spring.io/spring-security-oauth/docs/oauth2.html
     *   - https://alexbilbie.com/guide-to-oauth-2-grants/)
     */
    @Override
    public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
        clients
            .jdbc(dataSource)
            .passwordEncoder(passwordEncoder());
    }

    /**
     * Defines the endpoints that are used to authorise and obtain tokens. By default, the following endpoints are provided:
     *   - /oauth/confirm_access  <- Presented to the Resource Owner requesting their approval for the authorisation request (certain grant types only).
     *   - /oauth/authorize       <- Receives the Resource Owner's consent that they provided to /confirm_access.
     *   - /oauth/token           <- Used by Clients to exchange an authorisation code, along with their client ID and secret, for an access token.
     *   - /oauth/error           <- Displayed to the Resource Owner when an error occurs.
     *   - /oauth/check_token     <- Used by Resource Servers to decode access tokens.
     *   - /oauth/token_key       <- Exposes public key for token verification if using JWT tokens.
     */
    @Override
    public void configure(AuthorizationServerEndpointsConfigurer endpoints) throws Exception {
        endpoints
            .userDetailsService(userDetailsService())
            .tokenStore(tokenStore())
            .authenticationManager(authenticationManager);
    }

    /**
     * Defines a set of security constraints on the token endpoints.
     */
    @Override
    public void configure(AuthorizationServerSecurityConfigurer security) throws Exception {
        // Ensure that only authenticated clients can access token endpoints.
        security
            .passwordEncoder(passwordEncoder())
            .tokenKeyAccess("permitAll()")
            .checkTokenAccess("isAuthenticated()");

        // Enforce SSL in production environments.
        if (Arrays.asList(environment.getActiveProfiles()).contains("production")) {
            security.sslOnly();
        }
    }

    /**
     * Permit CORS configuration when authoring credentials
     */
//    @Bean
//    public FilterRegistrationBean simpleCorsFilter() {
//        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
//
//        CorsConfiguration config = new CorsConfiguration();
//        config.setAllowCredentials(true);
//        config.addAllowedOrigin("*");
//        config.addAllowedHeader("*");
//        config.addAllowedMethod("*");
//        source.registerCorsConfiguration("/**", config);
//
//        FilterRegistrationBean bean = new FilterRegistrationBean(new CorsFilter(source));
//        bean.setOrder(Ordered.HIGHEST_PRECEDENCE);
//
//        return bean;
//    }

    /**
     * The UserDetailsService that maps users into a format understood by Spring Security.
     */
    @Bean
    public CustomUserDetailsService userDetailsService() {
        return new CustomUserDetailsService();
    }
}

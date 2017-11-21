package au.com.dstil.ceres.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.security.oauth2.client.EnableOAuth2Sso;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.oauth2.config.annotation.web.configuration.EnableResourceServer;
import org.springframework.security.oauth2.config.annotation.web.configuration.ResourceServerConfigurerAdapter;
import org.springframework.security.oauth2.config.annotation.web.configurers.ResourceServerSecurityConfigurer;
import org.springframework.security.oauth2.provider.token.TokenStore;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

/**
 * Configures the application to fulfil the role of an OAuth2 Resource Server.
 *
 * A Resource Server serves resources that are protected by OAuth2, requiring a valid
 * token issued by an Authorisation Server to access resources.
 *
 * The Authorisation Server and Resource Server may exist in the same application. In some cases,
 * it may be preferable for many Resource Servers to share a single Authorisation Server.
 */
@Configuration
@EnableResourceServer
public class ResourceServerConfig extends ResourceServerConfigurerAdapter {

    /** The application name as set in application.yml. */
    @Value("${spring.application.name}")
    private String applicationName;

    /** Provides a mechanism for checking whether a given OAuth token is valid. */
    @Autowired
    private TokenStore tokenStore;

    /**
     * Configures the app to fulfil the role of an OAuth2 Resource Server.
     */
    @Override
    public void configure(ResourceServerSecurityConfigurer resources) throws Exception {
        resources
            .resourceId(applicationName)
            .tokenStore(tokenStore);
    }

    /**
     * Configures the mechanism responsible for configuring Cross-Origin Resource Sharing (CORS).
     */
    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();

        // Configure CORS settings.
        config.setAllowCredentials(true);
        config.addAllowedOrigin("*");
        config.addAllowedHeader("*");
        config.addAllowedMethod("*");

        // Define the set of paths for which the CORS configuration applies.
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);

        return source;
    }

    /**
     * Configures security constraints for requests handled by this Resource Server.
     */
    @Override
    public void configure(HttpSecurity http) throws Exception {
        http
            .cors().and()                                       // Allow anonymous CORS pre-flight requests
            .authorizeRequests()
                .antMatchers("/login/**").permitAll()// Permit all clients to access the root route and auth server
                .anyRequest().authenticated().and()             // Delegate further access to WebSecurityConfig
            .csrf().csrfTokenRepository(
                CookieCsrfTokenRepository.withHttpOnlyFalse()   // Persist CSRF token in a cookie
        );
    }
}

// =====================================================================================
// If running the Resource Server as a separate application, replace the class above
// with the one below.
//
// With a standalone Resource Server, we don't have local access to the TokenService
// for checking tokens like we do above. Instead, we need to use a RemoteTokenServices
// service for contacting the Authorisation Server remotely.
// =====================================================================================
//
//@Configuration
//@EnableResourceServer
//@EnableOAuth2Sso
//public class ResourceServerConfig extends ResourceServerConfigurerAdapter {
//
//    /** The application name as set in application.yml. */
//    @Value("${spring.application.name}")
//    private String applicationName;
//
//    /** Authorisation Server URI for checking if tokens are valid. */
//    @Value("${security.oauth2.client.checkTokenUri}")
//    private String checkTokenUri;
//
//    /** OAuth2 client ID. */
//    @Value("${security.oauth2.client.clientId}")
//    private String clientId;
//
//    /** OAuth2 client secret. */
//    @Value("${security.oauth2.client.clientSecret}")
//    private String clientSecret;
//
//    /**
//     * Configures the mechanism responsible for verifying whether a given token is valid.
//     * In this case, the RemoteTokenSerices object queries the /oauth/check_token endpoint
//     * on the Authorisation Server.
//     */
//    @Primary
//    @Bean
//    public RemoteTokenServices tokenService() {
//        RemoteTokenServices tokenService = new RemoteTokenServices();
//
//        tokenService.setCheckTokenEndpointUrl(checkTokenUri);
//        tokenService.setClientId(clientId);
//        tokenService.setClientSecret(clientSecret);
//
//        return tokenService;
//    }
//
//    /**
//     * Configures the mechanism responsible for configuring Cross-Origin Resource Sharing (CORS).
//     */
//    @Bean
//    CorsConfigurationSource corsConfigurationSource() {
//        CorsConfiguration config = new CorsConfiguration();
//
//        // Configure CORS settings.
//        config.setAllowCredentials(true);
//        config.addAllowedOrigin("*");
//        config.addAllowedHeader("*");
//        config.addAllowedMethod("*");
//
//        // Define the set of paths for which the CORS configuration applies.
//        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
//        source.registerCorsConfiguration("/**", config);
//
//        return source;
//    }
//
//    /**
//     * Configures the Resource Server to use the remote token service.
//     */
//    @Override
//    public void configure(ResourceServerSecurityConfigurer resources) throws Exception {
//        resources
//                .resourceId(applicationName)
//                .tokenServices(tokenService());
//    }
//
//    /**
//     * Configures an ordered set of security filters that specify how
//     * access to resources should be controlled.
//     */
//    @Override
//    public void configure(HttpSecurity http) throws Exception {
//        http
//            .cors().and()                                       // Allow anonymous CORS pre-flight requests
//            .authorizeRequests()
//                .antMatchers("/", "/auth").permitAll()          // Permit all clients to access the root route and auth server
//                .anyRequest().authenticated().and()             // Delegate further access to WebSecurityConfig
//            .csrf().csrfTokenRepository(
//                CookieCsrfTokenRepository.withHttpOnlyFalse()   // Persist CSRF token in a cookie
//            );
//    }
//}

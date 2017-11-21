package au.com.dstil.ceres.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.Map;

@RestController
public class LoginController {
    @GetMapping(value = "/private")
    public Map privateArea() {
        return Collections.singletonMap("response", "Welcome to the private area, you VIP you.");
    }
}

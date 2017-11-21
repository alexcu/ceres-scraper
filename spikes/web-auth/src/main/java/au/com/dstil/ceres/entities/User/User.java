package au.com.dstil.ceres.entities.User;

import au.com.dstil.ceres.entities.Role.Role;
import lombok.Data;

import javax.persistence.*;
import java.util.List;

@Data
@Entity(name = "users")
public class User {
    @Id
    private String username;
    private String password;
    private Integer callcenterId;
    @OneToMany(fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    private List<Role> roles;
    @Column(name = "enabled")
    private Boolean isEnabled;

    public User() {}
    public User(String username, String password, List<Role> roles, Integer callcenterId) {
        this.username = username;
        this.password = password;
        this.roles = roles;
        this.callcenterId = callcenterId;
    }
}

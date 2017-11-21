package au.com.dstil.ceres.entities.Role;

import lombok.Data;

import javax.persistence.*;

@Data
@Entity(name = "roles")
public class Role {
    @Id
    @Column(name = "role_name")
    private String name;

    public Role() {}
    public Role(String name) {
        this.name = name;
    }
}

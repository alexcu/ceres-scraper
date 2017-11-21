package au.com.dstil.ceres.entities.Callcenter;

import au.com.dstil.ceres.entities.Role.Role;
import lombok.Data;

import javax.persistence.*;
import java.util.List;

@Data
@Entity(name = "callcenters")
public class Callcenter {
    @Id
    private Integer id;
    private String name;
    private String domain;

    public Callcenter(Integer id, String name, String domain) {
        this.id = id;
        this.name = name;
        this.domain = domain;
    }
}

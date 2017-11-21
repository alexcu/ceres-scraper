package au.com.dstil.ceres.repositories;

import au.com.dstil.ceres.entities.User.User;
import org.springframework.data.repository.CrudRepository;

public interface UserRepository extends CrudRepository<User, Integer> {

    /**
     * Find a User by their username.
     *
     * @param username Username of the user
     * @return The User
     */
    User findByUsername(String username);
}

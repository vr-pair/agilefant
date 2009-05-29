package fi.hut.soberit.agilefant.business.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import fi.hut.soberit.agilefant.business.UserBusiness;
import fi.hut.soberit.agilefant.db.StoryDAO;
import fi.hut.soberit.agilefant.db.UserDAO;
import fi.hut.soberit.agilefant.model.User;

/**
 * 
 * @author rjokelai
 * 
 */
@Service("userBusiness")
public class UserBusinessImpl extends GenericBusinessImpl<User> implements
        UserBusiness {

    private StoryDAO storyDAO;
    private UserDAO userDAO;

    @Transactional(readOnly = true)
    public User retrieveByLoginName(String loginName) {
        return userDAO.getByLoginName(loginName);
    }

    @Transactional(readOnly = true)
    public List<User> getDisabledUsers() {
        return null;
    }

    @Transactional(readOnly = true)
    public List<User> getEnabledUsers() {
        return null;
    }

    @Transactional(readOnly = true)
    public boolean hasUserCreatedStories(User user) {
        return storyDAO.countByCreator(user) > 0;
    }

    @Autowired
    public void setUserDAO(UserDAO userDAO) {
        this.genericDAO = userDAO;
        this.userDAO = userDAO;
    }

    @Autowired
    public void setStoryDAO(StoryDAO storyDAO) {
        this.storyDAO = storyDAO;
    }

}
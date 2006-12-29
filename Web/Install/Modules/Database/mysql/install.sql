

CREATE TABLE cm_articlecategory(
articlecategoryid INT NOT NULL AUTO_INCREMENT,
title VARCHAR(100) NOT NULL,
summary VARCHAR(255),
syndicate TINYINT NOT NULL,
inserttimestamp TIMESTAMP NOT NULL,
updatetimestamp DATETIME NOT NULL,
PRIMARY KEY (articlecategoryid));


CREATE TABLE cm_feed(
feedid INT NOT NULL AUTO_INCREMENT,
sectionid INT NOT NULL,
url VARCHAR(255) NOT NULL,
title VARCHAR(100) NOT NULL,
pubdate DATETIME NOT NULL,
numberofitems INT NOT NULL,
inserttimestamp TIMESTAMP NOT NULL,
updatetimestamp DATETIME NOT NULL,
FOREIGN KEY (sectionid) REFERENCES cuyahoga_section (sectionid),
PRIMARY KEY (feedid));


CREATE TABLE cm_feeditem(
feeditemid INT NOT NULL AUTO_INCREMENT,
feedid INT NOT NULL,
url VARCHAR(255) NOT NULL,
title VARCHAR(100) NOT NULL,
content MEDIUMTEXT,
pubdate DATETIME NOT NULL,
author VARCHAR(100),
FOREIGN KEY (feedid) REFERENCES cm_feed (feedid),
PRIMARY KEY (feeditemid));


CREATE TABLE cm_article(
articleid INT NOT NULL AUTO_INCREMENT,
sectionid INT NOT NULL,
createdby INT NOT NULL,
modifiedby INT,
articlecategoryid INT,
title VARCHAR(100) NOT NULL,
summary VARCHAR(255),
content MEDIUMTEXT NOT NULL,
syndicate TINYINT NOT NULL,
dateonline DATETIME NOT NULL,
dateoffline DATETIME NOT NULL,
inserttimestamp TIMESTAMP NOT NULL,
updatetimestamp DATETIME NOT NULL,
FOREIGN KEY (articlecategoryid) REFERENCES cm_articlecategory (articlecategoryid),
FOREIGN KEY (sectionid) REFERENCES cuyahoga_section (sectionid),
FOREIGN KEY (createdby) REFERENCES cuyahoga_user (userid),
FOREIGN KEY (modifiedby) REFERENCES cuyahoga_user (userid),
PRIMARY KEY (articleid));


CREATE TABLE cm_articlecomment(
commentid INT NOT NULL AUTO_INCREMENT,
articleid INT NOT NULL,
userid INT,
name VARCHAR(100),
website VARCHAR(100),
commenttext TEXT NOT NULL,
userip VARCHAR(15),
inserttimestamp TIMESTAMP NOT NULL,
updatetimestamp DATETIME NOT NULL,
FOREIGN KEY (articleid) REFERENCES cm_article (articleid),
FOREIGN KEY (userid) REFERENCES cuyahoga_user (userid),
PRIMARY KEY (commentid));


CREATE TABLE cm_statichtml(
statichtmlid INT NOT NULL AUTO_INCREMENT,
sectionid INT NOT NULL,
createdby INT NOT NULL,
modifiedby INT,
title VARCHAR(255),
content MEDIUMTEXT NOT NULL,
inserttimestamp TIMESTAMP NOT NULL,
updatetimestamp DATETIME NOT NULL,
FOREIGN KEY (sectionid) REFERENCES cuyahoga_section (sectionid),
FOREIGN KEY (createdby) REFERENCES cuyahoga_user (userid),
FOREIGN KEY (modifiedby) REFERENCES cuyahoga_user (userid),
PRIMARY KEY (statichtmlid));

-- DATA --

INSERT INTO cuyahoga_moduletype (moduletypeid, name, assemblyname, classname, path, editpath, inserttimestamp, updatetimestamp) VALUES (1, 'StaticHtml', 'Cuyahoga.Modules', 'Cuyahoga.Modules.StaticHtml.StaticHtmlModule', 'Modules/StaticHtml/StaticHtml.ascx', 'Modules/StaticHtml/EditHtml.aspx', '2004-10-02 14:36:28.324', '2004-10-02 14:36:28.324');
INSERT INTO cuyahoga_moduletype (moduletypeid, name, assemblyname, classname, path, editpath, inserttimestamp, updatetimestamp) VALUES (2, 'Articles', 'Cuyahoga.Modules', 'Cuyahoga.Modules.Articles.ArticleModule', 'Modules/Articles/Articles.ascx', 'Modules/Articles/AdminArticles.aspx', '2004-10-02 14:36:28.324', '2004-10-02 14:36:28.324');
INSERT INTO cuyahoga_moduletype (moduletypeid, name, assemblyname, classname, path, editpath, inserttimestamp, updatetimestamp) VALUES (3, 'User', 'Cuyahoga.Modules', 'Cuyahoga.Modules.User.UserModule', 'Modules/User/User.ascx', NULL, '2004-10-02 14:36:28.324', '2004-10-02 14:36:28.324');
INSERT INTO cuyahoga_moduletype (moduletypeid, name, assemblyname, classname, path, editpath, inserttimestamp, updatetimestamp) VALUES (4, 'Search', 'Cuyahoga.Modules', 'Cuyahoga.Modules.Search.SearchModule', 'Modules/Search/Search.ascx', NULL, '2004-10-02 14:36:28.324', '2004-10-02 14:36:28.324');
INSERT INTO cuyahoga_moduletype (moduletypeid, name, assemblyname, classname, path, editpath, inserttimestamp, updatetimestamp) VALUES (5, 'LanguageSwitcher', 'Cuyahoga.Modules', 'Cuyahoga.Modules.LanguageSwitcher.LanguageSwitcherModule', 'Modules/LanguageSwitcher/LanguageSwitcher.ascx', NULL, '2004-10-02 14:36:28.324', '2004-10-02 14:36:28.324');
INSERT INTO cuyahoga_moduletype (moduletypeid, name, assemblyname, classname, path, editpath, inserttimestamp, updatetimestamp) VALUES (6, 'RemoteContent', 'Cuyahoga.Modules', 'Cuyahoga.Modules.RemoteContent.RemoteContentModule', 'Modules/RemoteContent/RemoteContent.ascx', 'Modules/RemoteContent/AdminRemoteContent.aspx', '2005-04-08 14:36:28.324', '2004-04-08 14:36:28.324');
INSERT INTO cuyahoga_moduletype (moduletypeid, name, assemblyname, classname, path, editpath, inserttimestamp, updatetimestamp) VALUES (7, 'UserProfile', 'Cuyahoga.Modules', 'Cuyahoga.Modules.User.ProfileModule', 'Modules/User/EditProfile.ascx', NULL, '2005-10-20 14:36:28.324', '2005-10-20 14:36:28.324');
INSERT INTO cuyahoga_moduletype (moduletypeid, name, assemblyname, classname, path, editpath, inserttimestamp, updatetimestamp) VALUES (8, 'SearchInput', 'Cuyahoga.Modules', 'Cuyahoga.Modules.Search.SearchInputModule', 'Modules/Search/SearchInput.ascx', NULL, '2005-10-20 14:36:28.324', '2005-10-20 14:36:28.324');
INSERT INTO cuyahoga_moduletype (moduletypeid, name, assemblyname, classname, path, editpath, inserttimestamp, updatetimestamp) VALUES (9, 'Sitemap', 'Cuyahoga.Modules', 'Cuyahoga.Modules.Sitemap.SitemapModule', 'Modules/Sitemap/SitemapControl.ascx', NULL, '2005-10-20 14:36:28.324', '2005-10-20 14:36:28.324');


INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (2, 'ALLOW_COMMENTS', 'Allow comments', 'System.Boolean', 0, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (2, 'NUMBER_OF_ARTICLES_IN_LIST', 'Number of articles to display', 'System.Int16', 0, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (2, 'DISPLAY_TYPE', 'Display type', 'Cuyahoga.Modules.Articles.DisplayType', 1, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (2, 'ALLOW_ANONYMOUS_COMMENTS', 'Allow anonymous comments', 'System.Boolean', 0, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (2, 'ALLOW_SYNDICATION', 'Allow syndication', 'System.Boolean', 0, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (2, 'SORT_BY', 'Sort by', 'Cuyahoga.Modules.Articles.SortBy', 1, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (2, 'SORT_DIRECTION', 'Sort direction', 'Cuyahoga.Modules.Articles.SortDirection', 1, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (3, 'SHOW_REGISTER', 'Show register link', 'System.Boolean', 0, 0);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (3, 'SHOW_RESET_PASSWORD', 'Show reset password link', 'System.Boolean', 0, 0);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (3, 'SHOW_EDIT_PROFILE', 'Show edit profile link', 'System.Boolean', 0, 0);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (4, 'RESULTS_PER_PAGE', 'Results per page', 'System.Int32', 0, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (4, 'SHOW_INPUT_PANEL', 'Show search input box', 'System.Boolean', 0, 0);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (5, 'DISPLAY_MODE', 'Display mode', 'Cuyahoga.Modules.LanguageSwitcher.DisplayMode', 1, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (5, 'REDIRECT_TO_USER_LANGUAGE', 'Redirect user to browser language when possible?', 'System.Boolean', 0, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (6, 'CACHE_DURATION', 'Local database cache duration (min)', 'System.Int32', 0, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (6, 'SHOW_CONTENTS', 'Show feed contents', 'System.Boolean', 0, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (6, 'SHOW_DATES', 'Show dates', 'System.Boolean', 0, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (6, 'BACKGROUND_REFRESH', 'Use background refreshing', 'System.Boolean', 0, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (6, 'SHOW_SOURCES', 'Show feed sources', 'System.Boolean', 0, 1);
INSERT INTO cuyahoga_modulesetting (moduletypeid, name, friendlyname, settingdatatype, iscustomtype, isrequired) VALUES (6, 'SHOW_AUTHORS', 'Show authors', 'System.Boolean', 0, 1);

INSERT INTO cuyahoga_version (assembly, major, minor, patch) VALUES ('Cuyahoga.Modules', 1, 5, 0);
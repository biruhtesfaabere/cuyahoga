/*                                                          */
/* File generated by "DeZign for databases"                 */
/* Create-date    :3/4/2004                                 */
/* Create-time    :10:58:46 PM                              */
/* project-name   :Cuyahoga                                 */
/* project-author :Martijn Boland                           */
/*                                                          */



CREATE TABLE Cuyahoga_User(
UserId serial NOT NULL UNIQUE PRIMARY KEY,
Username varchar(50) NOT NULL UNIQUE,
Password varchar(100) NOT NULL,
Firstname varchar(100),
Lastname varchar(100),
Email varchar(100) NOT NULL,
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL);


CREATE TABLE Cuyahoga_Role(
RoleId serial NOT NULL UNIQUE PRIMARY KEY,
Name varchar(50) NOT NULL UNIQUE,
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL);


CREATE TABLE Cuyahoga_UserRole(
UserRoleId serial NOT NULL UNIQUE PRIMARY KEY,
UserId int4 NOT NULL,
RoleId int4 NOT NULL,
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL,
FOREIGN KEY (RoleId) REFERENCES Cuyahoga_Role (RoleId),
FOREIGN KEY (UserId) REFERENCES Cuyahoga_User (UserId));


CREATE TABLE Cuyahoga_Template(
TemplateId serial NOT NULL UNIQUE PRIMARY KEY,
Name varchar(100) NOT NULL,
Path varchar(100) NOT NULL,
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL);


CREATE TABLE Cuyahoga_Node(
NodeId serial NOT NULL UNIQUE PRIMARY KEY,
ParentNodeId int4,
TemplateId int4,
Title varchar(255) NOT NULL,
Position int4 DEFAULT 0 NOT NULL,
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL,
FOREIGN KEY (ParentNodeId) REFERENCES Cuyahoga_Node (NodeId),
FOREIGN KEY (TemplateId) REFERENCES Cuyahoga_Template (TemplateId));


CREATE TABLE Cuyahoga_Module(
ModuleId serial NOT NULL PRIMARY KEY,
Name varchar(100) NOT NULL,
AssemblyName varchar(100),
ClassName varchar(255) NOT NULL UNIQUE,
Path varchar(255) NOT NULL,
EditPath varchar(255),
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL);


CREATE TABLE Cuyahoga_Section(
SectionId serial NOT NULL UNIQUE PRIMARY KEY,
NodeId int4,
ModuleId int4 NOT NULL,
Title varchar(100) NOT NULL,
ShowTitle bool DEFAULT 1 NOT NULL,
Placeholder varchar(100),
Position int4 DEFAULT 0 NOT NULL,
CacheDuration int4,
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL,
FOREIGN KEY (ModuleId) REFERENCES Cuyahoga_Module (ModuleId),
FOREIGN KEY (NodeId) REFERENCES Cuyahoga_Node (NodeId));


CREATE TABLE Cuyahoga_SectionRole(
SectionRoleId serial NOT NULL UNIQUE PRIMARY KEY,
RoleId int4 NOT NULL,
SectionId int4 NOT NULL,
ViewAllowed bool,
EditAllowed bool,
AddAllowed bool,
RemoveAllowed bool,
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL,
FOREIGN KEY (RoleId) REFERENCES Cuyahoga_Role (RoleId),
FOREIGN KEY (SectionId) REFERENCES Cuyahoga_Section (SectionId));


CREATE TABLE Cuyahoga_NodeRole(
NodeRoleId serial NOT NULL UNIQUE PRIMARY KEY,
RoleId int4 NOT NULL,
NodeId int4 NOT NULL,
ViewAllowed bool,
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL,
FOREIGN KEY (NodeId) REFERENCES Cuyahoga_Node (NodeId),
FOREIGN KEY (RoleId) REFERENCES Cuyahoga_Role (RoleId));


CREATE TABLE CM_StaticHtml(
StaticHtmlId serial NOT NULL UNIQUE PRIMARY KEY,
SectionId int4 NOT NULL,
CreatedBy int4 NOT NULL,
ModifiedBy int4,
Title varchar(255),
Content text NOT NULL,
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL,
FOREIGN KEY (SectionId) REFERENCES Cuyahoga_Section (SectionId),
FOREIGN KEY (CreatedBy) REFERENCES Cuyahoga_User (UserId),
FOREIGN KEY (ModifiedBy) REFERENCES Cuyahoga_User (UserId));


CREATE TABLE CM_ArticleCategory(
ArticleCategoryId serial NOT NULL UNIQUE PRIMARY KEY,
Title varchar(100) NOT NULL,
Summary varchar(255),
Syndicate bool NOT NULL,
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL);


CREATE TABLE CM_Article(
ArticleId serial NOT NULL UNIQUE PRIMARY KEY,
SectionId int4 NOT NULL,
CreatedBy int4 NOT NULL,
ModifiedBy int4,
ArticleCategoryId int4,
Title varchar(100) NOT NULL,
Summary varchar(255),
Content text NOT NULL,
Syndicate bool NOT NULL,
DateOnline timestamp NOT NULL,
DateOffline timestamp NOT NULL,
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL,
FOREIGN KEY (ArticleCategoryId) REFERENCES CM_ArticleCategory (ArticleCategoryId),
FOREIGN KEY (SectionId) REFERENCES Cuyahoga_Section (SectionId),
FOREIGN KEY (CreatedBy) REFERENCES Cuyahoga_User (UserId),
FOREIGN KEY (ModifiedBy) REFERENCES Cuyahoga_User (UserId));


CREATE TABLE CM_ArticleComment(
CommentId serial NOT NULL UNIQUE PRIMARY KEY,
ArticleId int4 NOT NULL,
UserId int4,
CommentText varchar(2000) NOT NULL,
InsertTimestamp timestamp DEFAULT current_timestamp NOT NULL,
UpdateTimestamp timestamp DEFAULT current_timestamp NOT NULL,
FOREIGN KEY (ArticleId) REFERENCES CM_Article (ArticleId),
FOREIGN KEY (UserId) REFERENCES Cuyahoga_User (UserId));


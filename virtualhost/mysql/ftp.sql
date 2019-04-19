/*
Navicat MySQL Data Transfer

Source Server         : 106.38.205.214
Source Server Version : 50720
Source Host           : 106.38.205.214:3306
Source Database       : ftp

Date: 2018-07-11 12:38:22
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for ftp_group
-- ----------------------------
CREATE TABLE IF NOT EXISTS `ftp_group` (
  `groupname` varchar(16) NOT NULL DEFAULT '',
  `gid` smallint(6) NOT NULL DEFAULT '82',
  `members` varchar(16) NOT NULL DEFAULT '',
  KEY `groupname` (`groupname`),
  KEY `groups_gid_idx` (`gid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='ProFTP group table';

-- ----------------------------
-- Table structure for ftp_user
-- ----------------------------
CREATE TABLE IF NOT EXISTS `ftp_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userid` varchar(32) NOT NULL DEFAULT '',
  `passwd` varchar(32) NOT NULL DEFAULT '',
  `uid` smallint(6) NOT NULL DEFAULT '82',
  `gid` smallint(6) NOT NULL DEFAULT '82',
  `homedir` varchar(255) NOT NULL DEFAULT '',
  `shell` varchar(16) NOT NULL DEFAULT '/sbin/nologin',
  `count` int(11) NOT NULL DEFAULT '0',
  `accessed` datetime NOT NULL DEFAULT '2018-03-02 13:45:45',
  `modified` datetime NOT NULL DEFAULT '2018-03-02 13:45:45',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userid` (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='ProFTP user table';
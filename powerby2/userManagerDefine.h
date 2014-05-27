//
//  userManagerDefine.h
//  powerby2
//
//  Created by spacewander on 14-5-19.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//
/**
 *	@file
 *  this file contains  variable used in the userManager and relative place. 
 *  Such as database filename, etc.
 */
#ifndef powerby2_userManagerDefine_h
#define powerby2_userManagerDefine_h

/**
 *	the filename of sqlite3 database
 */
#define dbFile @"userScores.db"

/**
 *	the name of NSNotifications. Used in the InfoViewController, the userManager,
 *  and the DBController.
 */
#define UPDATE_RANK @"UserManagerUpdateScore"
#define UPDATE_DB @"DBInsertScoreSuccess"

#endif

//
//  ContentsModel.m
//  SentisApp
//
//  Created by IThelp on 11/1/12.
//  Copyright (c) 2012 IThelp. All rights reserved.
//

#define strDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define strResourcePath [[NSBundle mainBundle] resourcePath]
#define DATABASE_NAME	@"mycontact.sqlite"

#import "DBHandler.h"
#import "AppDelegate.h"


@implementation DBHandler

- (id)init
{
    self = [super init];
    return self;
    
}

-(sqlite3 *) openDatabase
{
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", strDocumentPath,DATABASE_NAME];
    
    //NSLog(@"DB Data Path :%@", dbPath);
    
    sqlite3 *database = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath])
    {
        if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS tbl_mycontact (cip_id INTEGER PRIMARY KEY, ci_fullname TEXT, FirstName TEXT, LastName TEXT, ci_jobtitle TEXT, ci_department TEXT, ci_companyname TEXT, ci_mobilenum TEXT, ci_directnum TEXT, ci_companynum TEXT, ci_fax TEXT, ci_email TEXT, ci_reallycomname TEXT, ci_level TEXT, ci_address TEXT, ci_country TEXT, ci_photourl TEXT, ci_industry TEXT, ci_userabout TEXT, ci_jobfunction TEXT, ci_compwebsite TEXT, ci_index INTEGER, ci_user_status INTEGER, ci_prod_id INTEGER, ci_user_channel_group INTEGER, ci_user_comp_admin INTEGER, ci_user_cpadmin INTEGER, ci_user_job_satisfaction INTEGER, ci_user_last_active INTEGER, ci_user_last_bill INTEGER, ci_user_last_interaction INTEGER, ci_user_last_login INTEGER, ci_user_online INTEGER, ci_user_phone_ext INTEGER, ci_user_recruitment INTEGER, ci_user_sub_type INTEGER, ci_comp_dept TEXT, ci_user_country TEXT, ci_user_expiry_comp TEXT, ci_user_expiry_date TEXT, ci_user_joined TEXT, ci_user_lang TEXT, ci_user_mgr_email TEXT, ci_user_personal_email TEXT, ci_user_personal_facebook TEXT, ci_user_personal_linkedin TEXT, ci_user_personal_twitter TEXT, ci_location_phone TEXT, ci_comp_about TEXT, ci_street TEXT, ci_city TEXT, ci_state TEXT, ci_postal TEXT, ci_associated TEXT)";
            
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                sqlite3_close(database);
                return nil;
            }
        }
    }
    else
    {
        if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
            //NSLog(@"Error : %s, ", sqlite3_errmsg(database));

            return database;
    }
    return nil;
}


-(void)insertMyContactsList:(NSMutableArray *)list
{
    
    [self deleteAllMyContactsList];
    
	sqlite3_stmt *stmt = nil;
    sqlite3 *database = [self openDatabase];
    if (database)
    {
		const char *sql = "insert into tbl_mycontact(cip_id, ci_fullname, FirstName, LastName, ci_jobtitle, ci_department, ci_companyname, ci_mobilenum, ci_directnum, ci_companynum, ci_fax, ci_email, ci_reallycomname, ci_level, ci_address, ci_country, ci_photourl, ci_industry, ci_userabout, ci_jobfunction, ci_compwebsite, ci_index, ci_user_status, ci_prod_id, ci_user_channel_group, ci_user_comp_admin, ci_user_cpadmin, ci_user_job_satisfaction, ci_user_last_active, ci_user_last_bill, ci_user_last_interaction, ci_user_last_login, ci_user_online, ci_user_phone_ext, ci_user_recruitment, ci_user_sub_type, ci_comp_dept, ci_user_country, ci_user_expiry_comp, ci_user_expiry_date, ci_user_joined, ci_user_lang, ci_user_mgr_email, ci_user_personal_email, ci_user_personal_facebook, ci_user_personal_linkedin, ci_user_personal_twitter, ci_location_phone, ci_comp_about, ci_street, ci_city, ci_state, ci_postal, ci_associated) Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK)
        {
            sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, NULL);
            for (int i = 0; i < list.count; i++)
            {
                AccountInfo *obj = [list objectAtIndex:i];
                sqlite3_bind_int(stmt, 1, (int)obj.userID);
                sqlite3_bind_text(stmt, 2, [obj.strFullName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 3, [obj.strFirstName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 4, [obj.strSurName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 5, [obj.strJobTitle UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 6, [obj.strDepartment UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 7, [obj.strCompanyName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 8, [obj.strMobile UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 9, [obj.strDirect UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 10, [obj.strCompany UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 11, [obj.strFax UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 12, [obj.strEmail UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 13, [obj.strReallyCompanyName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 14, [obj.strLevel UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 15, [obj.strAddress UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 16, [obj.strCountry UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 17, [obj.strPhotoURL UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 18, [obj.strIndustry UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 19, [obj.strUserAbout UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 20, [obj.strJobFunction UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 21, [obj.strCompWebsite UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(stmt, 22, (int)obj.index);
                sqlite3_bind_int(stmt, 23, (int)obj.user_status);
                
                sqlite3_bind_int(stmt, 24, (int)obj.prod_id);
                sqlite3_bind_int(stmt, 25, (int)obj.user_channel_group);
                sqlite3_bind_int(stmt, 26, (int)obj.user_comp_admin);
                sqlite3_bind_int(stmt, 27, (int)obj.user_cpadmin);
                sqlite3_bind_int(stmt, 28, (int)obj.user_job_satisfaction);
                sqlite3_bind_int(stmt, 29, (int)obj.user_last_active);
                sqlite3_bind_int(stmt, 30, (int)obj.user_last_bill);
                sqlite3_bind_int(stmt, 31, (int)obj.user_last_interaction);
                sqlite3_bind_int(stmt, 32, (int)obj.user_last_login);
                sqlite3_bind_int(stmt, 33, (int)obj.user_online);
                sqlite3_bind_int(stmt, 34, (int)obj.user_phone_ext);
                sqlite3_bind_int(stmt, 35, (int)obj.user_recruitment);
                sqlite3_bind_int(stmt, 36, (int)obj.user_sub_type);
                sqlite3_bind_text(stmt, 37, [obj.comp_dept UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 38, [obj.user_country UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 39, [obj.user_expiry_comp UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 40, [obj.user_expiry_date UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 41, [obj.user_joined UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 42, [obj.user_lang UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 43, [obj.user_mgr_email UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 44, [obj.user_personal_email UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 45, [obj.user_personal_facebook UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 46, [obj.user_personal_linkedin UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 47, [obj.user_personal_twitter UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 48, [obj.location_phone UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 49, [obj.comp_about UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 50, [obj.strStreet UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 51, [obj.strCity UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 52, [obj.strState UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 53, [obj.strPostal UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 54, [obj.bAssociated UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_step(stmt);
                
                sqlite3_clear_bindings(stmt);
                sqlite3_reset(stmt);
            }
            
            sqlite3_exec(database, "END TRANSACTION", NULL, NULL, NULL);
            sqlite3_finalize(stmt);
        }
        NSLog(@"Error : %s, ", sqlite3_errmsg(database));
        sqlite3_close(database);
	}
}

-(void)deleteAllMyContactsList
{
    sqlite3 *database = [self openDatabase];
    if (database)
    {
        const char *sql = "DELETE FROM tbl_mycontact;";
        sqlite3_exec(database, sql, NULL, NULL, NULL);
        //NSLog(@"Error : %s, ", sqlite3_errmsg(database));
        sqlite3_close(database);
    }
}

-(NSMutableArray *)searchMyContactsList:(NSMutableArray *)array keyword:(NSString *)keyword
{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT cip_id, ci_fullname, FirstName, LastName, ci_jobtitle, ci_department, ci_companyname, ci_mobilenum, ci_directnum, ci_companynum, ci_fax, ci_email, ci_reallycomname, ci_level, ci_address, ci_country, ci_photourl, ci_industry, ci_userabout, ci_jobfunction, ci_compwebsite, ci_index, ci_user_status, ci_prod_id, ci_user_channel_group, ci_user_comp_admin, ci_user_cpadmin, ci_user_job_satisfaction, ci_user_last_active, ci_user_last_bill, ci_user_last_interaction, ci_user_last_login, ci_user_online, ci_user_phone_ext, ci_user_recruitment, ci_user_sub_type, ci_comp_dept, ci_user_country, ci_user_expiry_comp, ci_user_expiry_date, ci_user_joined, ci_user_lang, ci_user_mgr_email, ci_user_personal_email, ci_user_personal_facebook, ci_user_personal_linkedin, ci_user_personal_twitter, ci_location_phone, ci_comp_about, ci_street, ci_city, ci_state, ci_postal, ci_associated FROM tbl_mycontact WHERE (FirstName LIKE '%@%%%%') OR (LastName LIKE '%@%%%%')", keyword, keyword];
    return [self getDBResult:array query:strQuery];
}

-(NSMutableArray *)getMyContactsList:(NSMutableArray *)array orderby:(NSString *)orderby
{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT cip_id, ci_fullname, FirstName, LastName, ci_jobtitle, ci_department, ci_companyname, ci_mobilenum, ci_directnum, ci_companynum, ci_fax, ci_email, ci_reallycomname, ci_level, ci_address, ci_country, ci_photourl, ci_industry, ci_userabout, ci_jobfunction, ci_compwebsite, ci_index, ci_user_status, ci_prod_id, ci_user_channel_group, ci_user_comp_admin, ci_user_cpadmin, ci_user_job_satisfaction, ci_user_last_active, ci_user_last_bill, ci_user_last_interaction, ci_user_last_login, ci_user_online, ci_user_phone_ext, ci_user_recruitment, ci_user_sub_type, ci_comp_dept, ci_user_country, ci_user_expiry_comp, ci_user_expiry_date, ci_user_joined, ci_user_lang, ci_user_mgr_email, ci_user_personal_email, ci_user_personal_facebook, ci_user_personal_linkedin, ci_user_personal_twitter, ci_location_phone, ci_comp_about, ci_street, ci_city, ci_state, ci_postal, ci_associated FROM tbl_mycontact ORDER BY %@", orderby];
    return [self getDBResult:array query:strQuery];
}

-(void) searchMyContactsListByCharacter:(NSMutableArray *)array keyword:(NSString *)keyword type:(BOOL)bFirstNameSearch keyvalue:(NSString *)keyvalue
{
    NSString *strQuery = @"";
    if (bFirstNameSearch)
        strQuery = [NSString stringWithFormat:@"SELECT cip_id, ci_fullname, FirstName, LastName, ci_jobtitle, ci_department, ci_companyname, ci_mobilenum, ci_directnum, ci_companynum, ci_fax, ci_email, ci_reallycomname, ci_level, ci_address, ci_country, ci_photourl, ci_industry, ci_userabout, ci_jobfunction, ci_compwebsite, ci_index, ci_user_status, ci_prod_id, ci_user_channel_group, ci_user_comp_admin, ci_user_cpadmin, ci_user_job_satisfaction, ci_user_last_active, ci_user_last_bill, ci_user_last_interaction, ci_user_last_login, ci_user_online, ci_user_phone_ext, ci_user_recruitment, ci_user_sub_type, ci_comp_dept, ci_user_country, ci_user_expiry_comp, ci_user_expiry_date, ci_user_joined, ci_user_lang, ci_user_mgr_email, ci_user_personal_email, ci_user_personal_facebook, ci_user_personal_linkedin, ci_user_personal_twitter, ci_location_phone, ci_comp_about, ci_street, ci_city, ci_state, ci_postal, ci_associated FROM tbl_mycontact WHERE (FirstName LIKE '%@%%') AND  ci_fullname LIKE '%%%@%%' ORDER BY FirstName", keyword, keyvalue];
    else
        strQuery = [NSString stringWithFormat:@"SELECT cip_id, ci_fullname, FirstName, LastName, ci_jobtitle, ci_department, ci_companyname, ci_mobilenum, ci_directnum, ci_companynum, ci_fax, ci_email, ci_reallycomname, ci_level, ci_address, ci_country, ci_photourl, ci_industry, ci_userabout, ci_jobfunction, ci_compwebsite, ci_index, ci_user_status, ci_prod_id, ci_user_channel_group, ci_user_comp_admin, ci_user_cpadmin, ci_user_job_satisfaction, ci_user_last_active, ci_user_last_bill, ci_user_last_interaction, ci_user_last_login, ci_user_online, ci_user_phone_ext, ci_user_recruitment, ci_user_sub_type, ci_comp_dept, ci_user_country, ci_user_expiry_comp, ci_user_expiry_date, ci_user_joined, ci_user_lang, ci_user_mgr_email, ci_user_personal_email, ci_user_personal_facebook, ci_user_personal_linkedin, ci_user_personal_twitter, ci_location_phone, ci_comp_about, ci_street, ci_city, ci_state, ci_postal, ci_associated FROM tbl_mycontact WHERE (LastName LIKE '%@%%') AND ci_fullname LIKE '%%%@%%' ORDER BY LastName", keyword, keyvalue];
    
    [self getDBResult:array query:strQuery];
}

-(NSMutableArray *)getDBResult:(NSMutableArray *)array query:(NSString *)strQuery
{
    [array removeAllObjects];
    
    sqlite3_stmt *stmt = nil;
    sqlite3 *database = [self openDatabase];
	if (database)
    {
        const char *sql = [strQuery UTF8String];
		if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW)
            {
				AccountInfo *obj = [[AccountInfo alloc] init];
                obj.userID = sqlite3_column_int(stmt, 0);
				obj.strFullName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
                obj.strFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                obj.strSurName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                obj.strJobTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                obj.strDepartment = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                const unsigned char *str = sqlite3_column_text(stmt, 6);
                if (str == NULL) {
                    obj.strCompanyName = nil;
                } else
                    obj.strCompanyName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
                
                obj.strMobile = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
                obj.strDirect = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 8)];
                obj.strCompany = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 9)];
                obj.strFax = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 10)];
                obj.strEmail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 11)];
                const unsigned char *str1 = sqlite3_column_text(stmt, 12);
                if (str1 == NULL) {
                    obj.strReallyCompanyName = nil;
                } else
                    obj.strReallyCompanyName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 12)];
                
                const unsigned char *str2 = sqlite3_column_text(stmt, 13);
                if (str2 == NULL) {
                    obj.strLevel = nil;
                } else
                    obj.strLevel = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 13)];
                
                const unsigned char *str3 = sqlite3_column_text(stmt, 14);
                if (str3 == NULL) {
                    obj.strReallyCompanyName = nil;
                } else
                    obj.strAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 14)];
                
                const unsigned char *str4 = sqlite3_column_text(stmt, 15);
                if (str4 == NULL) {
                    obj.strCountry = nil;
                } else
                    obj.strCountry = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 15)];
                
                const unsigned char *str5 = sqlite3_column_text(stmt, 16);
                if (str5 == NULL) {
                    obj.strCountry = nil;
                } else
                    obj.strPhotoURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 16)];
                
                const unsigned char *str6 = sqlite3_column_text(stmt, 17);
                if (str6 == NULL) {
                    obj.strIndustry = nil;
                } else
                    obj.strIndustry = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 17)];
                
                const unsigned char *str7 = sqlite3_column_text(stmt, 18);
                if (str7 == NULL) {
                    obj.strUserAbout = nil;
                } else
                    obj.strUserAbout = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 18)];
                
                const unsigned char *str8 = sqlite3_column_text(stmt, 19);
                if (str8 == NULL) {
                    obj.strJobFunction = nil;
                } else
                    obj.strJobFunction = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 19)];
                
                const unsigned char *str9 = sqlite3_column_text(stmt, 20);
                if (str9 == NULL) {
                    obj.strCompWebsite = nil;
                } else
                    obj.strCompWebsite = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 20)];
                
                obj.index = sqlite3_column_int(stmt, 21);
                obj.user_status = sqlite3_column_int(stmt, 22);
                
                obj.prod_id = sqlite3_column_int(stmt, 23);
                obj.user_channel_group = sqlite3_column_int(stmt, 24);
                obj.user_comp_admin = sqlite3_column_int(stmt, 25);
                obj.user_cpadmin  = sqlite3_column_int(stmt, 26);
                obj.user_job_satisfaction = sqlite3_column_int(stmt, 27);
                obj.user_last_active = sqlite3_column_int(stmt, 28);
                obj.user_last_bill = sqlite3_column_int(stmt, 29);
                obj.user_last_interaction = sqlite3_column_int(stmt, 30);
                obj.user_last_login = sqlite3_column_int(stmt, 31);
                obj.user_online = sqlite3_column_int(stmt, 32);
                obj.user_phone_ext = sqlite3_column_int(stmt, 33);
                obj.user_recruitment = sqlite3_column_int(stmt, 34);
                obj.user_sub_type = sqlite3_column_int(stmt, 35);
                obj.comp_dept = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 36)];
                obj.user_country = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 37)];
                obj.user_expiry_comp = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 38)];
                obj.user_expiry_date = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 39)];
                obj.user_joined = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 40)];
                obj.user_lang = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 41)];
                obj.user_mgr_email = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 42)];
                obj.user_personal_email = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 43)];
                obj.user_personal_facebook = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 44)];
                obj.user_personal_linkedin = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 45)];
                obj.user_personal_twitter = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 46)];
                obj.location_phone = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 47)];
                obj.comp_about = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 48)];
                obj.strStreet = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 49)];
                obj.strCity = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 50)];
                obj.strState = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 51)];
                obj.strPostal = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 52)];
                obj.bAssociated = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 53)];


                [array addObject:obj];
                
            }
		}
        
        sqlite3_finalize(stmt);
        sqlite3_close(database);
	}
    
    return array;
}

- (NSString *) getNotNullValue:(NSObject *) param
{
    if (param == [NSNull null])
    {
        return @"";
    }
    
    return (NSString *)param;
}


@end

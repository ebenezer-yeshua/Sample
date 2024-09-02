#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/wait.h>

#define MAX_LEN 1024
#define MAX 256

/* Delete old backup */
int Deleteoldbackup(char* basepath)
{
    DIR *d;
    struct dirent *dir;
    char cmd[500];
    d = opendir(basepath);
    int result = 0;

    if (d)
    {
        while ((dir = readdir(d)) != NULL)
        {

         if (dir->d_name[0] == '.') {
           if (dir->d_name[1] == '\0') continue;
           if (dir->d_name[1] == '.') {
             if (dir->d_name[2] == '\0') continue;
           }
         }
         printf ("%s\n", dir->d_name);
         sprintf(cmd, "/usr/bin/barman delete localhost %s", dir->d_name);
         result = system(cmd);
          if (result == 0) {
        printf("It is deleted\n");
    } else {
        printf("Delete failed for the directory: %s\n", dir->d_name);
    }

        }
        closedir(d);
    }
}

/*Disable Waiting_for_wals*/
void Textreplace(char fname[MAX]) {
        FILE *fp1, *fp2;
        char word[MAX]="WAITING_FOR_WALS";
        char string[MAX], replace[MAX]="DONE";
        char temp[] = "temp.txt", *ptr1, *ptr2;
        char basepath[100] = "/var/lib/barman/localhost/base/";
        char filename[20] = "backup.info";
        char result[400];

        strcpy(result, basepath);
        strcat(result, fname); 
        strcat(result, "/");
        strcat(result, filename); 

        printf("%s\n", result); 

        fp1 = fopen(result, "r");

        if (!fp1) {
           printf("Unable to open the input file!!\n");
        }

        fp2 = fopen(temp, "w");

        if (!fp2) {
           printf("Unable to open temporary file!!\n");
        }

        while (!feof(fp1)) {
            strcpy(string, "\0");
            fgets(string, MAX, fp1);

            if (strstr(string, word)) {
               ptr2 = string;
               while (ptr1 = strstr(ptr2, word)) {
                   while (ptr2 != ptr1) {
                      fputc(*ptr2, fp2);
                      ptr2++;
                   }
                   ptr1 = ptr1 + strlen(word);
                   fprintf(fp2, "%s", replace);
                   ptr2 = ptr1;
               }

               while (*ptr2 != '\0') {
                   fputc(*ptr2, fp2);
                   ptr2++;
                }
                } else {
                        fputs(string, fp2);
                }
        }

        fclose(fp1);
        fclose(fp2);

        remove(result);
        rename(temp, result);
  }

/* Delete wal files*/
void Deletewal(){

    struct dirent *de;
    char files[100][500];
    int i = 0;
    char basepath[100] = "/var/lib/barman/localhost/wals/";
    char result[400];
    char cmd[32] = { 0 };
    int ret = 0;

    DIR *dr = opendir(basepath);

    if (dr == NULL)
    {
        printf("Could not open current directory" );
    }

    while ((de = readdir(dr)) != NULL) {
          strcpy(files[i], de->d_name);
            if(strstr(files[i], "000") != NULL)
            {
            strcpy(result, basepath);
            strcat(result, files[i]);
            sprintf(cmd, "rm -rf %s", result);
            ret = system(cmd);
               if (ret == 0)
                 printf("Wal directory deleted successfully\n");
               else
                 printf("Unable to delete directory %s\n", result);
            i++;
            }
    }
    closedir(dr);
}

/*Get backup list*/
void Getbackuplist(){

    DIR *d;
    struct dirent *dir;
    char cmd[500];
    char path[1000] = "/var/lib/barman/localhost/base";
    d = opendir(path);
    int result = 0;
 
    if (d)
    {
        while ((dir = readdir(d)) != NULL)
        {

         if (dir->d_name[0] == '.') {
           if (dir->d_name[1] == '\0') continue;
           if (dir->d_name[1] == '.') {
             if (dir->d_name[2] == '\0') continue;
           }
         }
         //printf ("%s\n", dir->d_name);
         Textreplace(dir->d_name);
        }
        closedir(d);
    }
}

/* Make new backup */
void Newbackup(){ 
   system("/usr/bin/barman backup localhost");
   sleep(10);  
   printf("Backup successfully done");
}

/* Get lastest backup id */ 
int isExceptionalDir(const char* name){
   if (name==NULL || name[0]=='\0') return 1;
   else if (name[0]=='.') {
     if (name[1]=='\0') return 1;
     else if (name[1]=='.' && name[2]=='\0') return 1;
   }
   return 0;
}

char buffer[MAX_LEN];

void recentByModification(const char* path, char* recent){
   struct dirent* entry;
   time_t recenttime = 0;
   struct stat statbuf;
   DIR* dir  = opendir(path);
   while (NULL != (entry = readdir(dir))) {
     if (!isExceptionalDir(entry->d_name)) {
       sprintf(buffer, "%s/%s", path, entry->d_name);
       stat(buffer, &statbuf);
       if (statbuf.st_mtime > recenttime) {
          strncpy(recent, entry->d_name, MAX_LEN);
         recenttime = statbuf.st_mtime;
       }
     }
   }
   closedir(dir);
}

void recentByName(const char* path, char* recent){
   DIR* dir  = opendir(path);
   struct dirent* entry;
   recent[0] = '\0';
   while (NULL != (entry = readdir(dir))) {
     if (!isExceptionalDir(entry->d_name)) {
       if (strncmp(recent, entry->d_name, MAX_LEN)<0) {
         strncpy(recent, entry->d_name, MAX_LEN);
       }
     }
   }
   closedir(dir);
}
void check_host_name(int hostname) { 
   if (hostname == -1) {
      perror("gethostname");
      exit(1);
   }
}
void check_host_entry(struct hostent * hostentry) { 
   if (hostentry == NULL) {
      perror("gethostbyname");
      exit(1);
   }
}
void IP_formatter(char *IPbuffer) { 
   if (NULL == IPbuffer) {
      perror("inet_ntoa");
      exit(1);
   }
}

/* Sync wal logs to s3. */
void Syncwals(){
   FILE *fp;
   char path[1035];

   fp = popen("/usr/bin/aws s3 sync /var/lib/barman/localhost/wals s3://backup-postgresql/`(hostname)`/wals", "r"); 
  
   if (fp == NULL) {
     printf("Failed to run command\n" );
     exit(1);
   }
    while (fgets(path, sizeof(path), fp) != NULL) {
     printf("%s", path);
    }

   pclose(fp);
}

char recent[MAX_LEN];

int main(int argc, char *args[], char* command){

/* Call functions */
   Deleteoldbackup(args[1]);
   Newbackup();
   Syncwals();
   Deletewal();

  if (argc < 2) {
    printf("Usage: %s path\n", args[0]);
    return 1;
  }

  for (int i=1; i<argc; i++) {
   recentByModification(args[i], recent);
   char host[256];
   char *IP;
   struct hostent *host_entry;
   int hostname;

   char *dirname = NULL;
   char *cmdline = NULL;
   size_t len;
   size_t dirlen = 0;
   int rv = 0;
   
   hostname = gethostname(host, sizeof(host));
   check_host_name(hostname);
   host_entry = gethostbyname(host); 
   check_host_entry(host_entry);
   IP = inet_ntoa(*((struct in_addr*) host_entry->h_addr_list[0]));
   printf("Current Host Name: %s", host);
   printf("Host IP: %s", IP);
   printf("Lastest PG Backup: %s\n", recent);

   printf("sync latest pg barman backup to s3.... ");
    if ( (len = getline(&dirname, &dirlen, stdout)) < 0) {
        perror("getline");
        exit(-1);
    }

/* Sync lastest pg barman backup to s3. */
   dirname[len-1] = 0;
   cmdline = malloc(len+216);
   snprintf(cmdline, dirlen+216, "/usr/bin/aws s3 sync /var/lib/barman/localhost/base/%s s3://backup-postgresql/%s/%s", recent, host, recent);
   rv = system(cmdline);
   free(cmdline); 
   free(dirname);
   rv = WEXITSTATUS(rv);
   return rv;
   }
}

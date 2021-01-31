![alt text](WebContent/img/zelectronics.png?raw=true "Title")

# Z Electronics
## Mamber

|Name          |Admin ID | 
|--------------|---------|
|Ang Yun, Zane |P1949955 |
|Poon Jun Hua  |P1937237 |

## Set up instruction
1. Run the file database.sql in the MySQL workbench you may want rename the database name
2. open the file in WebContent/WEB-INF/sql.properties change the user, password and database to what you have set in MySQL

```properties
user={MySQL user}
password={MySQL user password}
database={MYSQL schema}
host={MySQL hostname}
```
3. open the file in WebContent/WEB-INF/file.properties change the folder to where you want to save the uploaded image to

```properties
folder={image location}
accept={file type}
```
4. open the file in WebContent/WEB-INF/mail.properties change the the email address you can keep the default if you want

```properties
mail.smtp.auth =true
mail.smtp.starttls.enable =true
mail.smtp.host ={SMTP hostnmae}
mail.smtp.port=587
user={email address}
password={email password}
```

8. As I am using openJDK on my computer this project may not run right out of the box please change to your version of JRE (oracle JDK) in the java liberty

6. the admin user will be "admin@zElectronics.com.sg" and the password = "ItX6Dv8eGDqR14SneG4F"
7. the root user will be "root@zElectronics.com.sg" and the password = "kwy2VMUecxFfzXyb66Fn"

## Advanced Features
1. captcha
2. File upload
4. XSS prevention
5. Email server (working email Verify and forgot password)
6. upload to Azure  [p1949955.azurewebsites.net/](https://p1949955.azurewebsites.net/) account=root PW=Root (very unstable due to limited resources given to free account )
7. properties file (for easy change of config)
8. bcrypt 
9. Pagination
10. custom error page

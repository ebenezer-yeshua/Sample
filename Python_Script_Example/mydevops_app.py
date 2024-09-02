import os
import sys
from flask import Flask, render_template, request, redirect, url_for, session 
from pymongo import MongoClient
from pymongo import ReturnDocument
import random	
from werkzeug.utils import secure_filename
from datetime import datetime
from fastapi import FastAPI, HTTPException
from bson.objectid import ObjectId
import smtplib
from email.mime.text import MIMEText
import uuid
from flask_simple_captcha import CAPTCHA

UPLOAD_FOLDER = '/var/www/html/console/main/images'
ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])
MONGODBURL = MongoClient("mongodb://mydevops:*****@localhost:27017/")

#app = FastAPI()
app = Flask(__name__) 
app.secret_key = uuid.uuid4().hex
app.config['SESSION_TYPE'] = 'filesystem'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
YOUR_CONFIG = {
    'SECRET_CAPTCHA_KEY': 'LONG_KEY',
    'CAPTCHA_LENGTH': 6,
    'CAPTCHA_DIGITS': False,
    'EXPIRE_SECONDS': 600,
}
SIMPLE_CAPTCHA = CAPTCHA(config=YOUR_CONFIG)
app = SIMPLE_CAPTCHA.init_app(app)

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/uploadfile', methods=['GET', 'POST'])
def upload_file():
    try:
      que = request.args.get('filename', default='', type=str )
      if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        # if user does not select file, browser also
        # submit an empty part without filename
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            return redirect(url_for('upload_file',
                                    filename=filename))
    except:
      print("unable to upload")
    if(que):
      output = que + '  image upload successfully'
    else:
      output = que
    if 'username' in session:
      return render_template("uploadfile.html", result = output)
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route('/add_comment', methods=['POST'])
def add_comment():
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['comments']
      print("Connected successfully!!!2")
      randid = str(random.randint(10000, 9999999))
      now = datetime.now()
      dt_string = now.strftime("%d %B %y")
      result = request.form["id"]
      def get_commentcounter(name):
          collection = db.commentcounter
          document = collection.find_one_and_update({"_id": name}, {"$inc": {"value": 1}}, return_document=True)
          return document["value"]
      print(get_commentcounter("commentid"))
      rec={
        "_id": get_commentcounter("commentid"),
        "commentid": randid,
        "pageno":request.form["pageno"],
        "name": request.form["name"],
        "comment": request.form["comment"],
        "reply": 'None',
        "replyname": 'None',
        "created": dt_string
      }
    except:
      print("Could not connect to MongoDB")
    if request.method == 'POST':
        c_hash = request.form.get('captcha-hash')
        c_text = request.form.get('captcha-text')
        if SIMPLE_CAPTCHA.verify(c_text, c_hash):
             x = mycollection.insert_one(rec)
             print(x.inserted_id)
             commentstatus = "Comment added successfully"
             return redirect(url_for("singlepost", queue = result, status = commentstatus))
        else:
            captchacheck = "Wrong captcha"
            return redirect(url_for("singlepost", queue = result, status = captchacheck))
@app.route('/view_comments')
def view_comments():
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['comments']
      #print("Connected successfully!!!")
      rows = mycollection.find()
    except:
      print("Could not connect to MongoDB")
    return render_template('comment.html', comments=rows)

@app.route("/") 
def index():
    try:
      que = request.args.get('queue', default=0, type=int )
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['pages']
      myvideos = db['videos']
      #print("Connected successfully!!!")
      rows = mycollection.find()
      tags = mycollection.aggregate([{ "$group" :  {"_id" : "$tag"}} ])
      categorys = mycollection.aggregate([{ "$group" :  {"_id" : "$category"}} ])
      catemenu = mycollection.aggregate([{ "$group" :  {"_id" : "$category"}} ])
      trending =  mycollection.find().sort({'_id':1}).limit(5) 
      popular = mycollection.aggregate([{"$sample":{"size":2}}])
      vdata = myvideos.find().sort({'_id':-1}).limit(1);
      records = list(mycollection.find())
      num_records = len(records)
      print(num_records)
      dividevalue = (num_records // 2)
      metadata = [{"title": "System Administrator", "metadata": "Linux, Devops, Administrator", "description": "Blog have multiple technical guide lines for system administrator and devops engineer like Installation,Configuration and Tuning of IT infrastructure."}]
      if que == 0:
        print(que)
        queint = 1
      else:
        print(que)
        queint = que
      def get_items(page: int = queint, limit: int = 2):
            items = db.pages.find().sort({'_id':-1}).skip((page - 1) * limit).limit(limit)
            return items
     #get_items()
      for i in get_items():
          print("end")
    except:
      print("Could not connect to MongoDB")
    return render_template("index.html", results = get_items(queint), tags = tags, categorys = categorys, popular = popular, vdata = vdata, len = dividevalue, que = que, trending = trending, catemenu = catemenu, metadata = metadata)
@app.route("/categorys") 
def categorys():
    try:
      que = request.args.get('queue', default=0, type=int )
      category = request.args.get('category', default=None, type=str )
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['pages']
      myvideos = db['videos']
      #print("Connected successfully!!!")
      rows = mycollection.find({"category": category})
      tags = mycollection.aggregate([{ "$group" :  {"_id" : "$tag"}} ])
      categorys = mycollection.aggregate([{ "$group" :  {"_id" : "$category"}} ])
      trending = mycollection.find().sort({'_id':1}).limit(5)
      popular = mycollection.aggregate([{"$sample":{"size":2}}])
      vdata = myvideos.find().sort({'_id':-1}).limit(1)
      catemenu = mycollection.aggregate([{ "$group" :  {"_id" : "$category"}} ])
      metadata = [{"title": "System Administrator", "metadata": "Linux, Devops, Administrator", "description": "Blog have multiple technical guide lines for system administrator and devops engineer like Installation,Configuration and Tuning of IT infrastructure."}]
      records = list(mycollection.find({"category": category}))
      num_records = len(records)
      print(num_records)
      dividevalue = (num_records // 2)
      if que == 0:
        print(que)
        queint = 1
      else:
        print(que)
        queint = que
      def get_items(page: int = queint, limit: int = 2):
            items = db.pages.find().skip((page - 1) * limit).limit(limit)
            return items

      def get_items_category(page: int = queint, limit: int = 2):
            items = db.pages.find({"category": category}).skip((page - 1) * limit).limit(limit)
            return items
     #get_items()
      for i in get_items():
          print("end")
    except:
      print("Could not connect to MongoDB")
    if category == None:
      return render_template("category.html", results = get_items(queint), tags = tags, categorys = categorys, popular = popular, vdata = vdata, len = dividevalue, que = que, categoryvalue = category, trending = trending, catemenu = catemenu, metadata = metadata)
    else: 
      return render_template("category.html", results = get_items_category(queint), tags = tags, categorys = categorys, popular = popular, vdata = vdata, len = dividevalue, que = que, trending = trending, catemenu = catemenu, metadata = metadata)
@app.route("/tag") 
def tag():
    try:
      que = request.args.get('queue', default=0, type=int )
      tag  = request.args.get('tag', default=None, type=str )
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['pages']
      myvideos = db['videos']
      #print("Connected successfully!!!")
      rows = mycollection.find({"tag": tag})
      tags = mycollection.aggregate([{ "$group" :  {"_id" : "$tag"}} ])
      categorys = mycollection.aggregate([{ "$group" :  {"_id" : "$category"}} ])
      trending =  mycollection.find().sort({_id:1}).limit(5); 
      popular = mycollection.aggregate([{"$sample":{"size":2}}])
      vdata = myvideos.find().sort({'_id':-1}).limit(1)
      catemenu = mycollection.aggregate([{ "$group" :  {"_id" : "$category"}} ])
      metadata = [{"title": "System Administrator", "metadata": "Linux, Devops, Administrator", "description": "Blog have multiple technical guide lines for system administrator and devops engineer like Installation,Configuration and Tuning of IT infrastructure."}]
      records = list(mycollection.find({"tag": tag}))
      num_records = len(records)
      print(num_records)
      dividevalue = (num_records // 2)
      if que == 0:
        print(que)
        queint = 1
      else:
        print(que)
        queint = que
      def get_items(page: int = queint, limit: int = 2):
            items = db.pages.find().skip((page - 1) * limit).limit(limit)
            return items

      def get_items_category(page: int = queint, limit: int = 2):
            items = db.pages.find({"tag": tag}).skip((page - 1) * limit).limit(limit)
            return items
     #get_items()
      for i in get_items():
          print("end")
    except:
      print("Could not connect to MongoDB")
    if tag == None:
      return render_template("tag.html", results = get_items(queint), tags = tags, categorys = categorys, popular = popular, vdata = vdata, len = dividevalue, que = que, tagvalue = tag, trending = trending, catemenu = catemenu, metadata = medadata)
    else: 
      return render_template("tag.html", results = get_items_category(queint), tags = tags, categorys = categorys, popular = popular, vdata = vdata, len = dividevalue, que = que, trending = trending, catemenu = catemenu, metadata = metadata)
@app.route("/about")
def aboutus():
    return render_template("about.html")
@app.route("/contact", methods=['POST', 'GET'])
def contact():
        status  = request.args.get('status', default=None, type=str )
        new_captcha_dict = SIMPLE_CAPTCHA.create()
        return render_template('contact.html', captcha=new_captcha_dict, status = status)
@app.route("/sendmail", methods=['POST', 'GET'])
def sendmail():
    if request.method == 'POST':
        print("post")
        c_hash = request.form.get('captcha-hash')
        c_text = request.form.get('captcha-text')
        if SIMPLE_CAPTCHA.verify(c_text, c_hash):
            #return 'success'
            captchastatus = "Success"
            user = 'support@ehyehconsultancyservices.com'
            recipient = request.form["email"] 
            subject = request.form["subject"]
            body = request.form["message"]
            pwd = 'hiS#MDvt7'
            print(recipient)

            FROM = user
            TO = recipient if isinstance(recipient, list) else [recipient]
            SUBJECT = subject
            TEXT = body
            
            # Prepare actual message
            message = """From: %s\nTo: %s\nSubject: %s\n\n%s
            """ % (FROM, ", ".join(TO), SUBJECT, TEXT)
            try:
              server = smtplib.SMTP('smtp.ehyehconsultancyservices.com', 587)
              server.ehlo()
              server.starttls()
              server.login(user, pwd)
              server.sendmail(FROM, TO, message)
              server.close()
              print('successfully sent the mail')
              mailstatus = "successfully sent the mail"
            except:
              print('Failed mail')
              mailstatus = "Mail sent failed"
            print("test11")  
            return redirect(url_for('contact', status = mailstatus))
        else:
            #return 'failed captcha'
            captchacheck = "failed captcha"
            print("test22")
            return redirect(url_for('contact', status = captchacheck))
@app.route("/search", methods=['GET', 'POST'])
def searchresult():
    try:
      que = request.args.get('queue', default=0, type=int )
      search  = request.args.get('search', default=None, type=str )
      print(search)
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['pages']
      myvideos = db['videos']
      #print("Connected successfully!!!")
      rows = mycollection.find({"$text":{"$search": search}})
      tags = mycollection.aggregate([{ "$group" :  {"_id" : "$tag"}} ])
      categorys = mycollection.aggregate([{ "$group" :  {"_id" : "$category"}} ])
      trending =  mycollection.find().sort({'_id':1}).limit(5) 
      popular = mycollection.aggregate([{"$sample":{"size":2}}])
      vdata = myvideos.find().sort({'_id':-1}).limit(1)
      catemenu = mycollection.aggregate([{ "$group" :  {"_id" : "$category"}} ])
      records = list(mycollection.find({"$text":{"$search": search}}))
      num_records = len(records)
      print(num_records)
      dividevalue = (num_records // 2)
      if que == 0:
        print(que)
        queint = 1
      else:
        print(que)
        queint = que
      def get_items(page: int = queint, limit: int = 2):
            items = db.pages.find().skip((page - 1) * limit).limit(limit)
            return items

      def get_items_search(page: int = queint, limit: int = 2):
            items = db.pages.find({"$text":{"$search": search}}).skip((page - 1) * limit).limit(limit)
            return items

     #get_items()
      for i in get_items():
          print("end")
    except:
      print("Could not connect to MongoDB")
    if search == None:
       return render_template("search-result.html", results = get_items(queint), tags = tags, categorys = categorys, popular = popular, vdata = vdata, len = dividevalue, que = que, searchvalue = search, trending = trending, catemenu = catemenu)
    else: 
       return render_template("search-result.html", results = get_items(queint), tags = tags, categorys = categorys, popular = popular, vdata = vdata, len = dividevalue, que = que, trending = trending, catemenu = catemenu)
@app.route("/category")
def category():
    return render_template("category.html") 
@app.route("/singlepost", methods=['POST', 'GET'])
def singlepost():
    try:
      que = request.args.get('queue', default='', type=int )
      status  = request.args.get('status', default=None, type=str )
      print(que)
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['pages']
      mycomments = db['comments']
      myvideos = db['videos']
      #print("Connected successfully!!!")
      rows = mycollection.find({'_id': que})
      metadata = mycollection.find({'_id': que})
      data = mycollection.find({'_id': que})
      tags = mycollection.aggregate([{ "$group" :  {"_id" : "$tag"}} ])
      categorys = mycollection.aggregate([{ "$group" :  {"_id" : "$category"}} ])
      trending =  mycollection.find().sort({'_id':1}).limit(5) 
      popular = mycollection.aggregate([{"$sample":{"size":2}}])
      fetchpageno = data[0]['pageno']
      cdata = mycomments.find({'pageno': fetchpageno})
      vdata = myvideos.find().sort({'_id':-1}).limit(1)
      catemenu = mycollection.aggregate([{ "$group" :  {"_id" : "$category"}} ])
      new_captcha_dict = SIMPLE_CAPTCHA.create()
    except:
      print("Could not connect to MongoDB")
    return render_template("single-post.html", results = rows, tags = tags, categorys = categorys, popular = popular, comment = data, commentsdata = cdata, videodata = vdata, trending = trending, catemenu = catemenu, metadata = metadata, captcha = new_captcha_dict, status = status)
@app.route("/login", methods=['POST', 'GET'])
def adminlogin():
    try:
      que = request.args.get('result', default='', type=str )
    except:
      print('')
    return render_template("login.html", result = que)     
    #return redirect(url_for('index'))
@app.route("/adminlogout")
def adminlogout():
     session.pop('username', None)
     return redirect(url_for('adminlogin', result='Logged out successfully'))
@app.route('/checkadminuser', methods=['POST', 'GET'])
def chcekadminuser(): 
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['adminuser']
      print("Connected successfully!!!2")
      email = request.form["emailid"]
      passwd  = request.form["passwd"]
    except:   
      print("Could not connect to MongoDB")
    if mycollection.find_one({"$and":[{"emailid": email},{"password": passwd}]}):
       session["username"] = email
       print("exist in table")
       output = "Success"
    else:
       print("not exist in table")
       output = "Failed"
    if output == "Success":
      return redirect('/dashboard')
    else:
      return redirect(url_for('adminlogin', result="failed"))    
@app.route("/dashboard")
def dashboard():
    try:
       username = session['username']
       print(username)
    except:
       print("")
    if 'username' in session:
      return render_template("dashboard.html", result = username)
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route("/viewpage")
def viewpage():
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['pages']
      #print("Connected successfully!!!2")
      rows = mycollection.find()
      data = rows
      #for lines in rows:
       # print(lines)
      #getcount = len(lines)
      #print(getcount)
      username = session['username']
    except:
      print("Could not connect to MongoDB")
    if 'username' in session:
      return render_template("viewpage.html", results = mycollection.find())
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route("/viewcomment")
def viewcomment():
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['comments']
      #print("Connected successfully!!!2")
      rows = mycollection.find()
      data = rows
      #for lines in rows:
       # print(lines)
      #getcount = len(lines)
      #print(getcount)
      username = session['username']
    except:
      print("Could not connect to MongoDB")
    if 'username' in session:
      return render_template("viewcomment.html", results = mycollection.find())
    else:
      return redirect(url_for('adminlogin', result="Session expired"))
@app.route("/viewpagefull", methods=['POST', 'GET'])
def viewpagefull():
    try:
      que = request.args.get('queue', default='', type=int )
      print(que)
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['pages']
      #print("Connected successfully!!!2")
      rows = mycollection.find({'_id': que})
      for lines in rows:
       print(lines)
      username = session['username']
    except:
      print("Could not connect to MongoDB")      
    if 'username' in session:
      return render_template("viewpagefull.html", results = lines)
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route("/replycomment", methods=['POST', 'GET'])
def replycomment():
    try:
      que = request.args.get('queue', default='', type=int )
      print(que)
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['comments']
      #print("Connected successfully!!!2")
      rows = mycollection.find({'_id': que})
      username = session['username']
      for lines in rows:
        print(lines)
    except:
      print("Could not connect to MongoDB")
    if 'username' in session:
      return render_template("replycomment.html", results = lines)
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route('/updatecomment', methods=['POST', 'GET'])
def updatecomment(): 
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['comments']
      print("Connected successfully!!!")
      username = session['username']
      reqcommentid = request.form["commentid"]
      reqname = request.form["name"]
      reqcomment = request.form["comment"]
      reqpageno = request.form["pageno"]
      reqreply = request.form["reply"]
      reqreplyname = request.form["replyname"]
      now = datetime.now()
      dt_string = now.strftime("%d %B %y")
      print(reqpageno)
      def update_row(reqcommentid, reqreply, reqreplyname, requpdated):
          collection = db.comments
          document = collection.find_one_and_update({'commentid': reqcommentid}, {"$set": {"reply": reqreply, "replyname": reqreplyname, "updated": requpdated}}, return_document=True)
          return document
    except:
      print("Could not connect to MongoDB")
    if mycollection.find_one({"commentid": {"$eq": reqcommentid}}):
       status = "Values are updated successfully"
       print("exist in table")
       update_row(reqcommentid, reqreply, reqreplyname, dt_string)
    else:
      status = "Updated Failed"
      print("not exist in table")
    if 'username' in session:
      return redirect(url_for('viewcomment', result = status))
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route("/deletecomment", methods=['POST', 'GET'])
def deletecomment():
    try:
      que = request.args.get('queue', default='', type=int )
      print(que)
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['comments']
      username = session['username']
      #print("Connected successfully!!!2")
      def delete_row(que):
          collection = db.comments
          document = collection.delete_one({'_id': que})
          return document
    except:
      print("Could not connect to MongoDB")
    if mycollection.find_one({"_id": {"$eq": que}}):
       status = "Values are deleted successfully"
       print("exist in table")
       delete_row(que)
    else:
      status = "Deleted Failed"
      print("not exist in table")
    if 'username' in session:
      return redirect(url_for('viewcomment', result=status))
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route("/editpage", methods=['POST', 'GET'])
def editpage():
    try:
      que = request.args.get('queue', default='', type=int )
      print(que)
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['pages']
      #print("Connected successfully!!!2")
      rows = mycollection.find({'_id': que})
      username = session['username']
      for lines in rows:
        print(lines)
    except:
      print("Could not connect to MongoDB")
    if 'username' in session:
      return render_template("editpage.html", results = lines)
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route('/updatepage', methods=['POST', 'GET'])
def updatepage(): 
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['pages']
      print("Connected successfully!!!")
      username = session['username']
      reqpageno = request.form["pageno"]
      reqcategory = request.form["category"]
      reqtag = request.form["tag"]
      reqsubject = request.form["subject"]
      reqpagename = request.form["pagename"]
      reqimagename = request.form["imagename"]
      reqshortmessage = request.form["shortmessage"]
      reqmessage = request.form["message"]
      reqtitle = request.form["title"]
      reqmetadata = request.form["metadata"]
      reqdescription = request.form["description"]
      reqauthor = request.form["author"]
      print(reqpageno, reqtag)
      now = datetime.now()
      dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
      print("date and time =", dt_string)
      def update_row(pageno,category,tag,subject,pagename,imagename,shortmessage,message,title,metadata,description,author,updated):
          collection = db.pages
          document = collection.find_one_and_update({'pageno': pageno}, {"$set": {"cateogry": category, "tag": tag, "subject": subject, "pagename": pagename, "imagename": imagename, "shortmessage": shortmessage, "message": message, "title": title, "metadata": metadata, "description": description, "author": author, "updated": updated}}, return_document=True)
          return document
    except:
      print("Could not connect to MongoDB")
    if mycollection.find_one({"pageno": {"$eq": reqno}}):
       status = "Values are updated successfully"
       print("exist in table")
       update_row(reqpageno, reqcategory, reqtag, reqsubject, reqpagename, reqimagename, reqshortmessage, reqmessage, reqtitle, reqmetadata, reqdescription, reqauthor, dt_string)
    else:
      status = "Updated Failed"
      print("not exist in table")
    if 'username' in session:
      return redirect(url_for('viewpage', result=status))
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route("/deletepage", methods=['POST', 'GET'])
def deletepage():
    try:
      que = request.args.get('queue', default='', type=int )
      print(que)
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['pages']
      username = session['username']
      #print("Connected successfully!!!2")
      def delete_row(que):
          collection = db.pages
          document = collection.delete_one({'_id': que})
          return document
    except:
      print("Could not connect to MongoDB")
    if mycollection.find_one({"_id": {"$eq": que}}):
       status = "Values are deleted successfully"
       print("exist in table")
       delete_row(que)
    else:
      status = "Deleted Failed"
      print("not exist in table")
    if 'username' in session:
      return redirect(url_for('viewpage', result=status))
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route("/addpage")
def addpage():
    username = session['username']
    if 'username' in session:
      return render_template('addpage.html', results = username)
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route("/adminregistration")
def adminregistration():
   username = session['username']
   #if 'username' in session:
   return render_template("adminregistration.html")
   #else:
   #   return redirect(url_for('adminlogin', result="Session expired"))
@app.route("/viewvideo")
def viewvideo():
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['videos']
      #print("Connected successfully!!!2")
      rows = mycollection.find()
      data = rows
      #for lines in rows:
       # print(lines)
      #getcount = len(lines)
      #print(getcount)
      username = session['username']
    except:
      print("Could not connect to MongoDB")
    if 'username' in session:
      return render_template("viewvideo.html", results = mycollection.find())
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route('/addvideo', methods=['POST', 'GET']) 
def addvideo():
    username = session['username']
    if 'username' in session:
      return render_template('addvideo.html', results = username)
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route('/insertvideo', methods=['POST', 'GET'])
def insertvideo(): 
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['videos']
      print("Connected successfully!!!")
      #randid = random.randint(0,10000)
      randid = str(random.randint(10000, 9999999))
      now = datetime.now()
      dt_string = now.strftime("%d %B %y")
      print("date and time =", dt_string)
      def get_sequence(name):
          collection = db.videocounters
          document = collection.find_one_and_update({"_id": name}, {"$inc": {"value": 1}}, return_document=True)
          return document["value"]
      rec={
        "_id": get_sequence("videoid"),
        "videoid": randid, 
        "category": request.form["category"],
        "tag": request.form["tag"],
        "subject": request.form["subject"],
        "videoname": request.form["videoname"],
        "videolink": request.form["videolink"], 
        "description": request.form["description"],
        "created": dt_string,
        "updated": "none"
     }

    except:   
      print("Could not connect to MongoDB") 
    x = mycollection.insert_one(rec) 
    print(x.inserted_id);
    if x:
      output = "Page has been added successfully"
    else:
      output = "Page video failed"
    if 'username' in session:
      return render_template('addvideo.html', results = output)
    else:
      return redirect(url_for('adminlogin', result="Session expired"))
@app.route('/editvideo', methods=['POST', 'GET'])
def editvideo():
    try:
      que = request.args.get('queue', default='', type=int )
      print(que)
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['videos']
      #print("Connected successfully!!!2")
      rows = mycollection.find({'_id': que})
      username = session['username']
      for lines in rows:
        print(lines)
    except:
      print("Could not connect to MongoDB")
    if 'username' in session:
      return render_template("editvideo.html", results = lines)
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route('/updatevideo', methods=['POST', 'GET'])
def updatevideo(): 
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['videos']
      print("Connected successfully!!!")
      reqcategory = request.form["category"]
      reqtag = request.form["tag"]
      reqsubject = request.form["subject"]
      reqvideoid = request.form["videoid"]
      reqvideoname = request.form["videoname"]
      reqvideolink = request.form["videolink"]
      reqdescription = request.form["description"]
      now = datetime.now()
      dt_string = now.strftime("%d %B %y")
      print("date and time =", dt_string)
      def update_row(videoid,category,tag,subject,videoname,videolink,description,updated):
          collection = db.videos
          document = collection.find_one_and_update({'videoid': videoid}, {"$set": {"category": category, "tag": tag, "subject": subject, "videoname": videoname, "videolink": videolink, "description": description, "updated": updated}}, return_document=True)
          return document
    except:
      print("Could not connect to MongoDB")
    if mycollection.find_one({"videoid": {"$eq": reqvideoid}}):
       status = "Values are updated successfully"
       print("exist in table")
       update_row(reqvideoid, reqcategory, reqtag, reqsubject, reqvideoname, reqvideolink, reqdescription, dt_string)
    else:
      status = "Updated Failed"
      print("not exist in table")
    if 'username' in session:
      return redirect(url_for('viewvideo', result = status))
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route("/deletevideo", methods=['POST', 'GET'])
def deletevideo():
    try:
      que = request.args.get('queue', default='', type=int )
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['videos']
      username = session['username']
      #print("Connected successfully!!!2")
      def delete_row(que):
          collection = db.videos
          document = collection.delete_one({'_id': que})
          return document
    except:
      print("Could not connect to MongoDB")
    if mycollection.find_one({'_id': {"$eq": que}}):
       status = "Values are deleted successfully"
       print("exist in table")
       delete_row(que)
    else:
      status = "Deleted Failed"
      print("not exist in table")
    if 'username' in session:
      return redirect(url_for('viewvideo', result=status))
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route("/viewadminuser")
def viewadminuser():
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['adminuser']
      #print("Connected successfully!!!2")
      rows = mycollection.find()
      data = rows
      #for lines in rows:
       # print(lines)
      #getcount = len(lines)
      #print(getcount)
      username = session['username']
    except:
      print("Could not connect to MongoDB")
    if 'username' in session:
      return render_template("viewadminuser.html", results = mycollection.find())
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route("/editadminuser", methods=['POST', 'GET'])
def editadminuser():
    try:
      que = request.args.get('queue', default='', type=str )
      print(que)
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['adminuser']
      #print("Connected successfully!!!2")
      rows = mycollection.find({"adminuserid": que})
      username = session['username']
      for lines in rows:
        print(lines)
    except:
      print("Could not connect to MongoDB")
    if 'username' in session:
      return render_template("editadminuser.html", results = lines)
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route('/updateadminuser', methods=['POST', 'GET'])
def updateadminuser(): 
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['adminuser']
      print("Connected successfully!!!")
      reqadminuserid = request.form["adminuserid"]
      reqfirstname = request.form["firstname"]
      reqlastname = request.form["lastname"]
      reqemailid = request.form["emailid"]
      reqphoneno = request.form["phoneno"]
      reqpassword = request.form["password"]
      print(reqphoneno)
      def update_row(adminuserid,firstname,lastname,emailid,phoneno,password):
          collection = db.adminuser
          document = collection.find_one_and_update({'adminuserid': adminuserid}, {"$set": {"firstname": firstname, "lastname": lastname, "emailid": emailid, "phoneno": phoneno, "password": password}}, return_document=True)
          return document
    except:
      print("Could not connect to MongoDB")
    if mycollection.find_one({"adminuserid": {"$eq": reqadminuserid}}):
       status = "Values are updated successfully"
       print("exist in table")
       update_row(reqadminuserid, reqfirstname, reqlastname, reqemailid, reqphoneno, reqpassword)
    else:
      status = "Updated Failed"
      print("not exist in table")
    if 'username' in session:
      return redirect(url_for('viewadminuser', result = status))
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 
@app.route("/deleteadminuser", methods=['POST', 'GET'])
def deleteadminuser():
    try:
      que = request.args.get('queue', default='', type=str )
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['adminuser']
      username = session['username']
      #print("Connected successfully!!!2")
      def delete_row(que):
          collection = db.adminuser
          document = collection.delete_one({"adminuserid": que})
          return document
    except:
      print("Could not connect to MongoDB")
    if mycollection.find_one({"adminuserid": {"$eq": que}}):
       status = "Values are deleted successfully"
       print("exist in table")
       delete_row(que)
    else:
      status = "Deleted Failed"
      print("not exist in table")
    if 'username' in session:
      return redirect(url_for('viewadminuser', result=status))
    else:
      return redirect(url_for('adminlogin', result="Session expired")) 

@app.route('/insertadminuser', methods=['POST', 'GET'])
def insertadminuser(): 
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['adminuser']
      print("Connected successfully!!!2")
      randid = str(random.randint(10000, 9999999))
      email = request.form["emailid"]
      def get_admincounter(name):
          collection = db.admincounter
          document = collection.find_one_and_update({"_id": name}, {"$inc": {"value": 1}}, return_document=True)
          return document["value"]
      print(get_admincounter("adminid"))
      rec={
	"_id": get_admincounter("adminid"),
        "adminuserid": randid,
        "firstname": request.form["firstname"],
        "lastname": request.form["lastname"],
        "emailid": request.form["emailid"],
        "phoneno": request.form["phoneno"],
        "password": request.form["password"]
      }
    except:
      print("Could not connect to MongoDB")
    if mycollection.find_one({"emailid": {"$eq": email}}):
       print("exist in table")
       output = "Added user failed"
    else:
       print("not exist in table")
       output = "Added user successfully"
       x = mycollection.insert_one(rec)
       print(x.inserted_id)
    if 'username' in session:
       return render_template('viewadminuser.html', results = ouput)
    else:
       return redirect(url_for('adminlogin', result="Session expired"))
@app.route('/insertpage', methods=['POST', 'GET'])
def insertpage(): 
    try: 
      client = MONGODBURL
      db  = client['mydevops']
      mycollection = db['pages']
      print("Connected successfully!!!")
      #randid = random.randint(0,10000)
      randid = str(random.randint(10000, 9999999))
      now = datetime.now()
      dt_string = now.strftime("%d %B %y")
      print("date and time =", dt_string)
      def get_sequence(name):
          collection = db.counters
          document = collection.find_one_and_update({"_id": name}, {"$inc": {"value": 1}}, return_document=True)
          return document["value"]
      rec={
        "_id": get_sequence("pageid"),
        "pageno": randid, 
        "category": request.form["category"],
        "tag": request.form["tag"],
        "subject": request.form["subject"],
        "pagename": request.form["pagename"],
        "imagename": request.form["imagename"], 
        "shortmessage": request.form["shortmessage"],
        "message": request.form["message"],
        "title": request.form["title"],
        "metadata": request.form["metadata"],
        "description": request.form["description"],
        "author": request.form["author"],
        "created": dt_string,
        "updated": "none"
     }

    except:   
      print("Could not connect to MongoDB") 
    x = mycollection.insert_one(rec) 
    print(x.inserted_id);
    if x:
      output = "Page has been added successfully"
    else:
      output = "Page added failed"
    if 'username' in session:
      return render_template('addpage.html', results = output)
    else:
      return redirect(url_for('adminlogin', result="Session expired"))
@app.route("/account", methods=["POST", "GET"]) 
def account():
    usr = "<User Not Defined>" 
    if (request.method == "POST"): 
        usr = request.form["name"] 
        if not usr: 
            usr = "<User Not Defined>"
    return render_template("account.html",username=usr) 

if __name__ == "__main__": 
    app.run(debug=True,port=4949,host='0.0.0.0') 



require 'sinatra'

FILE_CONFIG           = File.dirname(__FILE__) + "/classes.csv"
FILE_USERS           = File.dirname(__FILE__) + "/users.csv"


FOLDER = 'views/mock/'
FILE_LOGIN            = FOLDER + 'login.html'
FILE_LOGOUT           = FOLDER + 'banner_logout.html'
FILE_LOGOUTDO         = FOLDER + 'banner_logoutdo.html'
FILE_WELCOME          = FOLDER + 'banner_welcome.html'
FILE_LOGIN_FAILED     = FOLDER + 'login_failed.html'
FILE_REG_AND_RECORDS  = FOLDER + 'banner_reg_and_records.html'
FILE_REGISTRATION     = FOLDER + 'banner_registration.html'
FILE_REG_AGREEMENT    = FOLDER + 'banner_reg_agreement.html'
FILE_SELECT_TERM      = FOLDER + 'banner_select_term.html'
FILE_LOOKUP_CLASSES   = FOLDER + 'banner_lookup_classes.html'
FILE_CLASS_LIST       = FOLDER + 'banner_class_list.html'
FILE_ADVANCED_SEARCH  = FOLDER + 'banner_advanced_search.html'
FILE_CLASS_RESULTS    = FOLDER + 'banner_class_results.html'
FILE_ADD_DROP_CLASSES = FOLDER + 'banner_add_drop_classes.html'
FILE_DETAILED				 = FOLDER + 'banner_detailed.html'

class Section
	attr_reader :course_reg_number
	attr_reader :subject
	attr_reader :course
	attr_reader :num_enrolled
	attr_reader :capacity
	attr_reader :name

	def initialize(crn,subj,crs,enrol,cap,nm)
		@course_reg_number = crn
		@subject = subj
		@course = crs
		@num_enrolled = enrol
		@capacity = cap
		@name = nm
	end

	#users can register for classes only if number of students enrolled in less than capacity
	def canRegister
		if(num_enrolled.to_i<capacity.to_i)
			return true
		else
			return false
		end
		end
end

class Subject
	attr_reader :subject
	attr_reader :name

	def initialize(subj,nm)
		@subject = subj
		@name = nm
	end
end

class MockUser
	attr_reader :netid
	attr_reader :password
	attr_reader :crns

	def initialize(id,pass)
		@netid = id
		@password = pass
		@crns = Array.new
	end

	def add_class(crn)
		@crns.push(crn)
	end

	def canRegister(crn,classes)
		if( classExists(crn,classes) )

			for sec in @crns
				if(sec==crn)
					return false
				end
			end

			return true
		end

		return false
	end

end

classes = Array.new
subjects = Array.new
users = Array.new

current_user = nil






#load all classes and subjects from config file
File.open( FILE_CONFIG, 'r') do |f1|
	while line = f1.gets
		line.delete! "\n"

		parsed_values = line.split(",")

		#if there are two values it is a new subject
		if(parsed_values.size == 2)

			subject = parsed_values[0]
			name 	 = parsed_values[1]
			new_subject = Subject.new( subject, name)

			subjects.push( new_subject )

		#if there are more than two values it is a course
		else
			course_number = parsed_values[0]
			subject 			= parsed_values[1]
			course				= parsed_values[2]
			num_enrolled  = parsed_values[3]
			capacity			= parsed_values[4]
			name					= parsed_values[5]

			new_section = Section.new( course_number, subject, course, num_enrolled, capacity, name )
			classes.push( new_section )
		end
	end
end

def classExists(crn,classes)
	for section in classes
			if(section.course_reg_number==crn)
				return true
			end
	end

	return false
end

def getSection(crn,classes)
	for section in classes
			if(section.course_reg_number==crn)
				return section
			end
	end

	return nil
end

#load all users with their passwords and what CRNs they're registered for
File.open( FILE_USERS, 'r') do |f1|
	while line = f1.gets
		line.delete! "\n"

		parsed_values = line.split(",")


		id = parsed_values[0]
		pass = parsed_values[1]

		new_user = MockUser.new( id, pass)


		#if there are more than two values, the third+ values are CRNs
		if(parsed_values.size > 2)
			for i in 2..(parsed_values.size-1)
				new_user.add_class(parsed_values[i])
			end
		end

		users.push( new_user )
	end
end

get '/enterprise' do
	html_output = ""

	File.open( FILE_LOGIN, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

get '/twbkwbis.P_Logout' do
	html_output = ""

	File.open( FILE_LOGOUT, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

post '/logout.do' do

	if( params[:BTN_YES] == 'Yes')
		html_output = ""

		File.open( FILE_LOGOUTDO, 'r') do |f1|
			while line = f1.gets
				html_output += line
			end
		end

		puts "LOGGED OUT: "+current_user.netid
		current_user = nil

		html_output
	end


end

post '/login.do' do

	authenticated = false

	for user in users
		if ( user.netid == params[:inputEnterpriseId] and user.password == params[:password] )
			current_user = user
			puts "LOGGED IN: "+current_user.netid

			authenticated = true
			break
		end
	end

	if authenticated

  	html_output = ""

		File.open( FILE_WELCOME, 'r') do |f1|
			while line = f1.gets
				html_output += line
			end
		end

	html_output

  else
  	html_output = ""
	  File.open( FILE_LOGIN_FAILED, 'r') do |f1|

			while line = f1.gets
				html_output += line
			end

		end
	html_output
  end

end

get '/reg_and_records' do
	html_output = ""

	File.open( FILE_REG_AND_RECORDS, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

get '/registration' do
	html_output = ""

	File.open( FILE_REGISTRATION, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

get '/registration_agreement' do
	html_output = ""

	File.open( FILE_REG_AGREEMENT, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

get '/select_term' do
	html_output = ""

	File.open( FILE_SELECT_TERM , 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	html_output
end

post '/select_classes' do
	html_output = ""



	File.open( FILE_LOOKUP_CLASSES, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	index = html_output.index("<!--OPTIONS-->")

	insertedOptions = ""
	for sub in subjects
		insertedOptions += "<OPTION VALUE=\""+sub.subject+"\">"+sub.name
	end

	html_output.insert(index,insertedOptions)

	html_output
end

post '/get_courses' do
	if params[:SUB_BTN] == "Course Search"
		html_output = ""

		File.open( FILE_CLASS_LIST, 'r') do |f1|
			while line = f1.gets
				html_output += line
			end
		end

		index = html_output.index("<!--SUBJECT-->")

		subName = "ERROR_NO_SUBJECT"
		for sub in subjects
			if(sub.subject== params[:sel_subj])
				subName = sub.name
			end
		end

		html_output.insert(index,"<TR><TH CLASS=\"ddheader\" scope=\"col\" colspan=\"4\" style=\"font-size:16px;\">"+subName+"</TH></TR>")


		rows = ""

		coursesListed = Array.new

		for course in classes

			if( (course.subject == params[:sel_subj]) && (!coursesListed.include?(course.course)))
				coursesListed.push(course.course)


				rows += "<TD CLASS=\"dddefault\"width=\"10%\">"+course.course+"</TD>
				<TD CLASS=\"dddefault\"width=\"35%\" text-align=\"left\">"+course.name+"</TD>
				<td>
				<FORM ACTION=\"/search_results\" METHOD=\"POST\" onSubmit=\"return checkSubmit()\">
				<input type=\"hidden\" name=\"term_in\" value=\"120141\" >
				<INPUT TYPE=\"hidden\" NAME=\"sel_subj\" VALUE=\"dummy\">
				<input type=\"hidden\" name=\"sel_subj\" value=\""+course.subject+"\" >
				<input type=\"hidden\" name=\"sel_crse\" value=\""+course.course+"\" >
				<input type=\"hidden\" name=\"SEL_TITLE\" value=\"\">
				<input type=\"hidden\" name=\"BEGIN_HH\" value=\"0\">
				<input type=\"hidden\" name=\"BEGIN_MI\" value=\"0\">
				<input type=\"hidden\" name=\"BEGIN_AP\" value=\"a\">
				<input type=\"hidden\" name=\"SEL_DAY\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_PTRM\" value=\"dummy\">
				<input type=\"hidden\" name=\"END_HH\" value=\"0\">
				<input type=\"hidden\" name=\"END_MI\" value=\"0\">
				<input type=\"hidden\" name=\"END_AP\" value=\"a\">
				<input type=\"hidden\" name=\"SEL_CAMP\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_SCHD\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_SESS\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_INSTR\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_INSTR\" value=\"%\">
				<input type=\"hidden\" name=\"SEL_ATTR\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_ATTR\" value=\"%\">
				<input type=\"hidden\" name=\"SEL_LEVL\" value=\"dummy\">
				<input type=\"hidden\" name=\"SEL_LEVL\" value=\"%\">
				<input type=\"hidden\" name=\"SEL_INSM\"  value=\"dummy\">
				<input type=\"hidden\" name=\"sel_dunt_code\"  value=\"\">
				<input type=\"hidden\" name=\"sel_dunt_unit\"  value=\"\">
				<input type=\"hidden\" name=\"call_value_in\"  value=\"\">
				<INPUT TYPE=\"hidden\" NAME=\"rsts\" VALUE=\"dummy\">
				<INPUT TYPE=\"hidden\" NAME=\"crn\" VALUE=\"dummy\">
				<input type=\"hidden\" name=\"path\" value=\"1\" >
				<INPUT TYPE=\"submit\" NAME=\"SUB_BTN\" VALUE=\"View Sections\" >
				</FORM>
				<BR>
				</td>
				</TR>"
			end
		end
		index = html_output.index("<!--COURSES-->")

		html_output.insert(index,rows)

		html_output
	else
		html_output = ""

		File.open( FILE_ADVANCED_SEARCH, 'r') do |f1|
			while line = f1.gets
				html_output += line
			end
		end

		index = html_output.index("<!--OPTIONS-->")

		insertedOptions = ""
		for sub in subjects
			insertedOptions += "<OPTION VALUE=\""+sub.subject+"\">"+sub.name
		end

		html_output.insert(index,insertedOptions)

		html_output
	end
end

post '/search_results' do
	output = ""

	File.open( FILE_CLASS_RESULTS, 'r') do |f1|
		while line = f1.gets
			output += line
		end
	end

	index = output.index("<!--SUBJECT-->")

	subName = "ERROR_NO_SUBJECT"
	for sub in subjects
		if(sub.subject == params[:sel_subj])
			subName = sub.name
		end
	end

	output.insert(index,"<TR><TH COLSPAN=\"26\" CLASS=\"ddtitle\" scope=\"colgroup\" >"+subName+"</TH></TR>")

	results =""
	for course in classes
	if( (course.subject == params[:sel_subj]) && (params[:sel_crse]=="" || params[:sel_crse]==course.course) && (params[:crn]=="dummy" || params[:sel_crn]==course.course_reg_number))
		if(course.canRegister)
		results += '<TR>
			<TD CLASS="dddefault"><ABBR title = "Available for registration">A</ABBR></TD>'
		else
		results += 	'<TR>
			<TD CLASS="dddefault"><ABBR title = Closed>C</ABBR></TD>'
		end

		results += '<TD CLASS="dddefault"><A HREF="/BANPROD1/bwckschd.p_disp_listcrse?term_in=120141&amp;subj_in=CS&amp;crse_in=125&amp;crn_in=31152" onMouseOver="window.status=\'Detail\';  return true" onFocus="window.status=\'Detail\';  return true" onMouseOut="window.status='';  return true"onBlur="window.status='';  return true">'+course.course_reg_number+'</A></TD>
					<TD CLASS="dddefault">'+course.subject+'</TD>
					<TD CLASS="dddefault">'+course.course+'</TD>
					<TD CLASS="dddefault">AL1</TD>
					<TD CLASS="dddefault">100</TD>
					<TD CLASS="dddefault">4.000</TD>
					<TD CLASS="dddefault">Intro to Computer Science</TD>
					<TD CLASS="dddefault">MWF</TD>
					<TD CLASS="dddefault">02:00 pm-02:50 pm</TD>
					<TD CLASS="dddefault">'+course.capacity+'</TD>
					<TD CLASS="dddefault">'+course.num_enrolled+'</TD>
					<TD CLASS="dddefault">'+(course.capacity.to_i-course.num_enrolled.to_i).to_s+'</TD>
					<TD CLASS="dddefault">0</TD>
					<TD CLASS="dddefault">0</TD>
					<TD CLASS="dddefault">0</TD>
					<TD CLASS="dddefault">0</TD>
					<TD CLASS="dddefault">0</TD>
					<TD CLASS="dddefault">0</TD>
					<TD CLASS="dddefault">Lawrence Christopher  Angrave (<ABBR title= "Primary">P</ABBR>)</TD>
					<TD CLASS="dddefault">01/21-05/07</TD>
					<TD CLASS="dddefault">1SIEBL 1404</TD>
					<TD CLASS="dddefault">UIUC: Quant Reasoning I</TD>
					</TR>'
		end
	end
	index = output.index("<!--SECTIONS-->")
	output.insert(index,results)

	output
end

get '/add_drop_classes' do
	html_output = ""

	File.open( FILE_ADD_DROP_CLASSES, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	if( current_user != nil && current_user.crns.size > 0 )
		table_start = '<h3>Current Schedule</h3>
		<table class="datadisplaytable" summary="Current Schedule">
		<tbody><tr>
		<th class="ddheader" scope="col">Status</th>
		<th class="ddheader" scope="col">Action</th>
		<th class="ddheader" scope="col"><acronym title="Course Reference Number">CRN</acronym></th>
		<th class="ddheader" scope="col"><abbr title="Subject">Subj</abbr></th>
		<th class="ddheader" scope="col"><abbr title="Course">Crse</abbr></th>
		<th class="ddheader" scope="col"><abbr title="Section">Sec</abbr></th>
		<th class="ddheader" scope="col">Level</th>
		<th class="ddheader" scope="col"><abbr title="Credit Hours">Cred</abbr></th>
		<th class="ddheader" scope="col">Grade Mode</th>
		<th class="ddheader" scope="col">Title</th>
		</tr>'

		table_end = '</tbody></table><br>'

		table_schedule = '<table class="plaintable" summary="Schedule Summary">
		<tbody><tr>
		<td class="pldefault">Total Credit Hours: </td>
		<td class="pldefault">    3.000</td>
		</tr>
		<tr>
		<td class="pldefault">Billing Hours:</td>
		<td class="pldefault">    3.000</td>
		</tr>
		<tr>
		<td class="pldefault">Minimum Hours:</td>
		<td class="pldefault">     12.000</td>
		</tr>
		<tr>
		<td class="pldefault">Maximum Hours:</td>
		<td class="pldefault">     18.000</td>
		</tr>
		<tr>
		<td class="pldefault">Date:</td>
		<td class="pldefault">Apr 08, 2014 09:18 am</td>
		</tr>
		</tbody></table>
		<br>'


		index = html_output.index("<!--CURRENT_SCHEDULE-->")

		inserted = ""

		inserted += table_start

		for crn in current_user.crns
			inserted += '<tr>
				<td class="dddefault"><input type="hidden" name="MESG" value="DUMMY">**Web Registered** on Apr 08, 2014</td>
				<td class="dddefault">
				<label for="action_id1"><span class="fieldlabeltextinvisible">Action</span></label>
				<select name="RSTS_IN" size="1" id="action_id1">
				<option value="" selected="">None
				</option><option value="DW">Web Drop Course
				</option></select>
				</td>
				<td class="dddefault"><input type="hidden" name="assoc_term_in" value="120148"><input type="hidden" name="CRN_IN" value="'+crn+'">'+crn+'<input type="hidden" name="start_date_in" value="08/25/2014"><input type="hidden" name="end_date_in" value="12/10/2014"></td>
				<td class="dddefault"><input type="hidden" name="SUBJ" value="SUBJ">SUBJ</td>
				<td class="dddefault"><input type="hidden" name="CRSE" value="101">101</td>
				<td class="dddefault"><input type="hidden" name="SEC" value="Q3">Q3</td>
				<td class="dddefault"><input type="hidden" name="LEVL" value="Undergrad - Urbana-Champaign">Undergrad - Urbana-Champaign</td>
				<td class="dddefault"><input type="hidden" name="CRED" value="    3.000">    3.000</td>
				<td class="dddefault"><input type="hidden" name="GMOD" value="Standard Letter">Standard Letter</td>
				<td class="dddefault"><input type="hidden" name="TITLE" value="CLASS NAME">CLASS NAME</td>
				</tr>'
		end

		inserted += table_end
		inserted += table_schedule

		html_output.insert(index,inserted)
	end



	html_output
end

post '/add_drop_classes' do

	html_output = ""

	error_crns = Array.new

	#if( params[:SUB_BTN] == "Submit Changes")
		for crn in [ params[:CRN_IN1], params[:CRN_IN2], params[:CRN_IN3], params[:CRN_IN4], params[:CRN_IN5] , params[:CRN_IN6] , params[:CRN_IN7] , params[:CRN_IN8], params[:CRN_IN9] , params[:CRN_IN10]     ]
			if(crn!="")
				puts crn

				if(current_user.canRegister(crn,classes))
					current_user.add_class(crn)
					puts "REGISTERED FOR CRN '" + crn + "' (netid: '" + current_user.netid + "')"

				else
					error_crns.push(crn)
					puts "FAILED TO REGISTER FOR CRN '" + crn + "' (netid: '" + current_user.netid + "')"

				end


			end
		end
	#end


	File.open( FILE_ADD_DROP_CLASSES, 'r') do |f1|
		while line = f1.gets
			html_output += line
		end
	end

	if( error_crns.size > 0)
		error_start= '<table class="plaintable" summary="This layout table holds message information">
			<tbody><tr>
			<td class="pldefault">

			</td>
			<td class="pldefault">
			<span class="errortext">Registration Add Errors</span>
			<br>
			</td>
			</tr>
			</tbody></table>
			<table class="datadisplaytable" summary="This layout table is used to present Registration Errors.">
			<tbody><tr>
			<th class="ddheader" scope="col">Status</th>
			<th class="ddheader" scope="col"><acronym title="Course Reference Number">CRN</acronym></th>
			<th class="ddheader" scope="col"><abbr title="Subject">Subj</abbr></th>
			<th class="ddheader" scope="col"><abbr title="Course">Crse</abbr></th>
			<th class="ddheader" scope="col"><abbr title="Section">Sec</abbr></th>
			<th class="ddheader" scope="col">Level</th>
			<th class="ddheader" scope="col"><abbr title="Credit Hours">Cred</abbr></th>
			<th class="ddheader" scope="col">Grade Mode</th>
			<th class="ddheader" scope="col">Title</th>
			</tr>'

		error_end = '<tbody></table><br>'

		index = html_output.index("<!--REGISTRATION_ERRORS-->")
		inserted = ""

		inserted += error_start

		for crn in error_crns
			inserted += '
			<tr>
			<td class="dddefault">ERROR MESSAGE</td>
			<td class="dddefault">'+crn+'</td>
			<td class="dddefault">SUBJ</td>
			<td class="dddefault">101</td>
			<td class="dddefault">A</td>
			<td class="dddefault">Undergrad - Urbana-Champaign</td>
			<td class="dddefault">    0.000</td>
			<td class="dddefault">Standard Letter DFR - UIUC</td>
			<td class="dddefault">NAME</td>
			</tr>'
		end

		inserted += error_end
		html_output.insert(index,inserted)
	end

	if( current_user != nil && current_user.crns.size > 0 )
		table_start = '<h3>Current Schedule</h3>
		<table class="datadisplaytable" summary="Current Schedule">
		<tbody><tr>
		<th class="ddheader" scope="col">Status</th>
		<th class="ddheader" scope="col">Action</th>
		<th class="ddheader" scope="col"><acronym title="Course Reference Number">CRN</acronym></th>
		<th class="ddheader" scope="col"><abbr title="Subject">Subj</abbr></th>
		<th class="ddheader" scope="col"><abbr title="Course">Crse</abbr></th>
		<th class="ddheader" scope="col"><abbr title="Section">Sec</abbr></th>
		<th class="ddheader" scope="col">Level</th>
		<th class="ddheader" scope="col"><abbr title="Credit Hours">Cred</abbr></th>
		<th class="ddheader" scope="col">Grade Mode</th>
		<th class="ddheader" scope="col">Title</th>
		</tr>'

		table_end = '</tbody></table><br>'

		table_schedule = '<table class="plaintable" summary="Schedule Summary">
		<tbody><tr>
		<td class="pldefault">Total Credit Hours: </td>
		<td class="pldefault">    3.000</td>
		</tr>
		<tr>
		<td class="pldefault">Billing Hours:</td>
		<td class="pldefault">    3.000</td>
		</tr>
		<tr>
		<td class="pldefault">Minimum Hours:</td>
		<td class="pldefault">     12.000</td>
		</tr>
		<tr>
		<td class="pldefault">Maximum Hours:</td>
		<td class="pldefault">     18.000</td>
		</tr>
		<tr>
		<td class="pldefault">Date:</td>
		<td class="pldefault">Apr 08, 2014 09:18 am</td>
		</tr>
		</tbody></table>
		<br>'


		index = html_output.index("<!--CURRENT_SCHEDULE-->")

		inserted = ""

		inserted += table_start

		for crn in current_user.crns
			inserted += '<tr>
				<td class="dddefault"><input type="hidden" name="MESG" value="DUMMY">**Web Registered** on Apr 08, 2014</td>
				<td class="dddefault">
				<label for="action_id1"><span class="fieldlabeltextinvisible">Action</span></label>
				<select name="RSTS_IN" size="1" id="action_id1">
				<option value="" selected="">None
				</option><option value="DW">Web Drop Course
				</option></select>
				</td>
				<td class="dddefault"><input type="hidden" name="assoc_term_in" value="120148"><input type="hidden" name="CRN_IN" value="'+crn+'">'+crn+'<input type="hidden" name="start_date_in" value="08/25/2014"><input type="hidden" name="end_date_in" value="12/10/2014"></td>
				<td class="dddefault"><input type="hidden" name="SUBJ" value="SUBJ">SUBJ</td>
				<td class="dddefault"><input type="hidden" name="CRSE" value="101">101</td>
				<td class="dddefault"><input type="hidden" name="SEC" value="Q3">Q3</td>
				<td class="dddefault"><input type="hidden" name="LEVL" value="Undergrad - Urbana-Champaign">Undergrad - Urbana-Champaign</td>
				<td class="dddefault"><input type="hidden" name="CRED" value="    3.000">    3.000</td>
				<td class="dddefault"><input type="hidden" name="GMOD" value="Standard Letter">Standard Letter</td>
				<td class="dddefault"><input type="hidden" name="TITLE" value="CLASS NAME">CLASS NAME</td>
				</tr>'
		end

		inserted += table_end
		inserted += table_schedule

		html_output.insert(index,inserted)
	end



	html_output

end

get '/detailed' do
	html_output = ""

	crn = params[:crn_in]
	if(classExists(crn,classes))
		section = getSection(crn,classes)

		File.open( FILE_DETAILED, 'r') do |f1|
			while line = f1.gets
				html_output += line
			end
		end


		index = html_output.index("<!--CRN-->")
		html_output.insert(index,section.course_reg_number)

		index = html_output.index("<!--SUBJ-->")
		html_output.insert(index,section.subject)

		index = html_output.index("<!--COURSE-->")
		html_output.insert(index,section.course)

		index = html_output.index("<!--CAPACITY-->")
		html_output.insert(index,section.capacity)

		index = html_output.index("<!--ACTUAL-->")
		html_output.insert(index,section.num_enrolled)

		index = html_output.index("<!--REMAINING-->")
		html_output.insert(index,(section.capacity.to_i-section.num_enrolled.to_i).to_s)

	else
		html_output = "error crn not found. (proper url: detailed?crn_in=12345 )"
	end







	html_output
end
